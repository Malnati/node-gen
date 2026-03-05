#!/bin/bash
# .repo/env.sh

if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
  set -euo pipefail
fi

repo_env_root() {
  cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd
}

load_repo_env() {
  local root
  root="$(repo_env_root)"
  local env_file="${1:-${root}/.repo.env}"

  if [ ! -f "${env_file}" ]; then
    return 0
  fi

  set -a
  # shellcheck disable=SC1090
  . "${env_file}"
  set +a
}

if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
  load_repo_env "${1:-}"
else
  load_repo_env
fi
