#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="${1:-output}"
FILTER_PROJECT=""
FILTER_DB=""
MERGE_ON_REMOTE="false"
MONOREPO_MODE="false"
DELETE_REMOTE="false"

is_known_db() {
  case "${1:-}" in
    mysql|postgres|sqlite|sqlserver) return 0 ;;
    *) return 1 ;;
  esac
}

parse_args() {
  local args=("$@")
  local i=1
  while [[ $i -lt ${#args[@]} ]]; do
    local k="${args[$i]}"
    local v=""
    if [[ $((i+1)) -lt ${#args[@]} ]]; then
      v="${args[$((i+1))]}"
    fi

    case "$k" in
      --project)
        FILTER_PROJECT="${v:-}"
        i=$((i+2))
        ;;
      --db)
        FILTER_DB="${v:-}"
        i=$((i+2))
        ;;
      --merge)
        MERGE_ON_REMOTE="${v:-false}"
        i=$((i+2))
        ;;
      --monorepo)
        MONOREPO_MODE="${v:-false}"
        i=$((i+2))
        ;;
      --delete)
        DELETE_REMOTE="${v:-true}"
        if [[ $((i+1)) -lt ${#args[@]} && ( "$v" == "true" || "$v" == "false" ) ]]; then
          i=$((i+2))
        else
          i=$((i+1))
        fi
        ;;
      *)
        if [[ -z "$FILTER_PROJECT" && -z "$FILTER_DB" ]]; then
          if is_known_db "$k"; then
            FILTER_DB="$k"
          else
            FILTER_PROJECT="$k"
          fi
        elif [[ -n "$FILTER_PROJECT" && -z "$FILTER_DB" ]]; then
          if is_known_db "$k"; then
            FILTER_DB="$k"
          fi
        fi
        i=$((i+1))
        ;;
    esac
  done

  if [[ "$MERGE_ON_REMOTE" != "true" && "$MERGE_ON_REMOTE" != "false" ]]; then
    MERGE_ON_REMOTE="false"
  fi

  if [[ "$MONOREPO_MODE" != "true" && "$MONOREPO_MODE" != "false" ]]; then
    MONOREPO_MODE="false"
  fi

  if [[ "$DELETE_REMOTE" != "true" && "$DELETE_REMOTE" != "false" ]]; then
    DELETE_REMOTE="false"
  fi
}

parse_args "$@"

OWNER="${GITHUB_OWNER:-milleniumbrasil}"
PREFIX="${REPO_PREFIX:-mod}"
VISIBILITY="${REPO_VISIBILITY:-private}"
PUSH_MODE="${PUSH_MODE:-upsert}"
DEFAULT_BRANCH="${DEFAULT_BRANCH:-main}"
COMMIT_MESSAGE="${COMMIT_MESSAGE:-chore: sync}"
SIGN_COMMITS="${SIGN_COMMITS:-false}"
PR_BASE_BRANCH="${PR_BASE_BRANCH:-}"
PR_TITLE="${PR_TITLE:-chore: sync}"
PR_BODY="${PR_BODY:-Automated sync.}"

if [[ ! -d "$BASE_DIR" ]]; then
  echo "Diretório não encontrado: $BASE_DIR" >&2
  exit 1
fi

abs_base_dir="$(cd "$BASE_DIR" && pwd)"

git_commit() {
  if [[ "$SIGN_COMMITS" == "true" ]]; then
    git commit -S -m "$COMMIT_MESSAGE" >/dev/null
  else
    git commit -m "$COMMIT_MESSAGE" >/dev/null
  fi
}

repo_exists() {
  gh repo view "$1" >/dev/null 2>&1
}

create_repo() {
  local full="$1"
  local vis_flag="--private"
  if [[ "$VISIBILITY" == "public" ]]; then
    vis_flag="--public"
  fi
  gh repo create "$full" "$vis_flag" >/dev/null
}

delete_repo() {
  local full="$1"
  if repo_exists "$full"; then
    gh repo delete "$full" --yes >/dev/null
    echo "DELETE: ${full}"
  else
    echo "SKIP (não existe): ${full}"
  fi
}

remote_url() {
  echo "https://github.com/$1.git"
}

ensure_gitignore() {
  if [[ ! -f .gitignore ]]; then
    : > .gitignore
  fi

  python3 - <<'PY'
import pathlib

p = pathlib.Path(".gitignore")
existing = set()
for line in p.read_text(encoding="utf-8", errors="ignore").splitlines():
    s = line.strip()
    if s:
        existing.add(s)

needed = [
    "node_modules/",
    "dist/",
    ".env",
    ".env.*",
    "*.log",
    ".DS_Store",
]
out = p.read_text(encoding="utf-8", errors="ignore").splitlines()
changed = False
if out and out[-1].strip() != "":
    out.append("")
    changed = True

for n in needed:
    if n not in existing:
        out.append(n)
        changed = True

if changed:
    p.write_text("\n".join(out).rstrip("\n") + "\n", encoding="utf-8")
PY
}

cleanup_build_artifacts_single_dir() {
  rm -rf node_modules dist .DS_Store >/dev/null 2>&1 || true
}

cleanup_build_artifacts_tree() {
  find . -type d -name node_modules -prune -exec rm -rf {} + >/dev/null 2>&1 || true
  find . -type d -name dist -prune -exec rm -rf {} + >/dev/null 2>&1 || true
  find . -type f -name .DS_Store -delete >/dev/null 2>&1 || true
}

ensure_repo_initialized() {
  if [[ ! -d ".git" ]]; then
    git init >/dev/null
  fi
}

ensure_origin() {
  local full="$1"
  local url
  url="$(remote_url "$full")"

  if git remote get-url origin >/dev/null 2>&1; then
    git remote set-url origin "$url" >/dev/null
  else
    git remote add origin "$url" >/dev/null
  fi
}

detect_remote_default_branch() {
  local full="$1"
  local api
  api="$(gh api -H "Accept: application/vnd.github+json" "/repos/${full}" --jq '.default_branch' 2>/dev/null || true)"
  if [[ -n "$api" && "$api" != "null" ]]; then
    echo "$api"
    return
  fi
  echo "$DEFAULT_BRANCH"
}

remote_has_heads() {
  if git ls-remote --heads origin 2>/dev/null | grep -q .; then
    return 0
  fi
  return 1
}

ensure_branch_name() {
  local branch="$1"
  git branch -M "$branch" >/dev/null
}

create_sync_branch() {
  local scope="$1"
  local ts
  ts="$(date -u +%Y%m%d-%H%M%S)"
  echo "sync/${scope}/${ts}"
}

ensure_local_branch() {
  local branch="$1"
  if git show-ref --verify --quiet "refs/heads/${branch}"; then
    git checkout "$branch" >/dev/null
  else
    git checkout -b "$branch" >/dev/null
  fi
}

push_ref() {
  local ref="$1"
  if [[ "$PUSH_MODE" == "force" ]]; then
    git push -u origin "$ref" --force >/dev/null
  else
    git push -u origin "$ref" >/dev/null
  fi
}

commit_if_needed() {
  if [[ -n "$(git status --porcelain)" ]]; then
    git add -A >/dev/null
    if git diff --cached --quiet; then
      return 1
    fi
    git_commit
    return 0
  fi
  return 1
}

push_if_remote_empty() {
  local base_branch="$1"

  if remote_has_heads; then
    return 1
  fi

  ensure_branch_name "$base_branch"
  push_ref "$base_branch"
  return 0
}

create_pr() {
  local full="$1"
  local head_branch="$2"
  local base_branch="$3"

  if gh pr view -R "$full" --head "$head_branch" >/dev/null 2>&1; then
    return 0
  fi

  gh pr create -R "$full" --head "$head_branch" --base "$base_branch" --title "$PR_TITLE" --body "$PR_BODY" >/dev/null
  return 0
}

merge_pr() {
  local full="$1"
  local head_branch="$2"

  local pr_number
  pr_number="$(gh pr view -R "$full" --head "$head_branch" --json number --jq '.number' 2>/dev/null || true)"
  if [[ -z "$pr_number" ]]; then
    return 1
  fi

  gh pr merge -R "$full" "$pr_number" --merge --delete-branch >/dev/null
  return 0
}

remove_nested_git_dirs_in_project() {
  rm -rf ./*/.git >/dev/null 2>&1 || true
}

project_has_db() {
  local project_dir="$1"
  local db="$2"
  [[ -d "${project_dir}/${db}" ]]
}

publish_repo_dir() {
  local full="$1"
  local scope_for_branch="$2"
  local base_for_pr="$3"

  ensure_repo_initialized
  ensure_origin "$full"

  if repo_exists "$full"; then
    git fetch origin >/dev/null 2>&1 || true

    local base
    if [[ -n "$PR_BASE_BRANCH" ]]; then
      base="$PR_BASE_BRANCH"
    else
      if [[ "$MERGE_ON_REMOTE" == "true" ]]; then
        base="$DEFAULT_BRANCH"
      else
        base="$base_for_pr"
      fi
    fi

    if push_if_remote_empty "$base"; then
      return
    fi

    local branch
    branch="$(create_sync_branch "$scope_for_branch")"
    ensure_local_branch "$branch"

    if ! commit_if_needed; then
      echo "SKIP (sem mudanças): ${full}"
      return
    fi

    push_ref "$branch"

    if [[ "$MERGE_ON_REMOTE" == "true" ]]; then
      create_pr "$full" "$branch" "$DEFAULT_BRANCH"
      merge_pr "$full" "$branch" || true
      return
    fi

    create_pr "$full" "$branch" "$base"
    return
  fi

  create_repo "$full"

  local base_new
  base_new="$(detect_remote_default_branch "$full")"

  if ! commit_if_needed; then
    echo "SKIP (sem mudanças): ${full}"
    return
  fi

  ensure_branch_name "$base_new"
  push_ref "$base_new"
}

publish_one() {
  local project="$1"
  local db="$2"
  local dir="$3"

  local repo="${PREFIX}-${project}-${db}"
  local full="${OWNER}/${repo}"

  echo "==> ${full}"
  cd "$dir"

  cleanup_build_artifacts_single_dir
  ensure_gitignore

  local base
  base="$(detect_remote_default_branch "$full")"
  publish_repo_dir "$full" "${project}-${db}" "$base"

  cd "$abs_base_dir"
}

publish_monorepo_project() {
  local project="$1"
  local project_dir="$2"

  local repo="${PREFIX}-${project}-monorepo"
  local full="${OWNER}/${repo}"

  echo "==> ${full}"
  cd "$project_dir"

  remove_nested_git_dirs_in_project
  cleanup_build_artifacts_tree
  ensure_gitignore

  local base
  base="$(detect_remote_default_branch "$full")"
  publish_repo_dir "$full" "${project}-monorepo" "$base"

  cd "$abs_base_dir"
}

delete_targets() {
  cd "$abs_base_dir"

  if [[ "$MONOREPO_MODE" == "true" ]]; then
    for project_dir in "$abs_base_dir"/*; do
      [[ -d "$project_dir" ]] || continue
      local project
      project="$(basename "$project_dir")"

      if [[ -n "$FILTER_PROJECT" && "$project" != "$FILTER_PROJECT" ]]; then
        continue
      fi

      if [[ -n "$FILTER_DB" ]]; then
        if ! project_has_db "$project_dir" "$FILTER_DB"; then
          continue
        fi
      fi

      local repo="${PREFIX}-${project}-monorepo"
      local full="${OWNER}/${repo}"
      delete_repo "$full"
    done
    return
  fi

  for project_dir in "$abs_base_dir"/*; do
    [[ -d "$project_dir" ]] || continue
    local project
    project="$(basename "$project_dir")"

    if [[ -n "$FILTER_PROJECT" && "$project" != "$FILTER_PROJECT" ]]; then
      continue
    fi

    for db_dir in "$project_dir"/*; do
      [[ -d "$db_dir" ]] || continue
      local db
      db="$(basename "$db_dir")"

      if [[ -n "$FILTER_DB" && "$db" != "$FILTER_DB" ]]; then
        continue
      fi

      local repo="${PREFIX}-${project}-${db}"
      local full="${OWNER}/${repo}"
      delete_repo "$full"
    done
  done
}

if [[ "$DELETE_REMOTE" == "true" ]]; then
  delete_targets
  echo "OK"
  exit 0
fi

cd "$abs_base_dir"

if [[ "$MONOREPO_MODE" == "true" ]]; then
  for project_dir in "$abs_base_dir"/*; do
    [[ -d "$project_dir" ]] || continue
    project="$(basename "$project_dir")"

    if [[ -n "$FILTER_PROJECT" && "$project" != "$FILTER_PROJECT" ]]; then
      continue
    fi

    if [[ -n "$FILTER_DB" ]]; then
      if ! project_has_db "$project_dir" "$FILTER_DB"; then
        continue
      fi
    fi

    publish_monorepo_project "$project" "$project_dir"
  done

  echo "OK"
  exit 0
fi

for project_dir in "$abs_base_dir"/*; do
  [[ -d "$project_dir" ]] || continue
  project="$(basename "$project_dir")"

  if [[ -n "$FILTER_PROJECT" && "$project" != "$FILTER_PROJECT" ]]; then
    continue
  fi

  for db_dir in "$project_dir"/*; do
    [[ -d "$db_dir" ]] || continue
    db="$(basename "$db_dir")"

    if [[ -n "$FILTER_DB" && "$db" != "$FILTER_DB" ]]; then
      continue
    fi

    publish_one "$project" "$db" "$db_dir"
  done
done

echo "OK"
