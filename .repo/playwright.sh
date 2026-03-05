#!/bin/bash
# .repo/playwright.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
. "${SCRIPT_DIR}/env.sh"

NODE_MIN_MAJOR=18
PLAYWRIGHT_PACKAGE='@playwright/cli@latest'
LOCAL_NPM_PREFIX="${HOME}/.local"
LOCAL_BIN_DIR="${LOCAL_NPM_PREFIX}/bin"

log() {
  printf '[playwright-setup] %s\n' "$1"
}

fail() {
  printf '[playwright-setup][erro] %s\n' "$1" >&2
  exit 1
}

usage() {
  printf 'Uso: %s [all|codex|opencode]\n' "${0}"
  printf '  all      Instala/configura skills para codex e opencode (padrao)\n'
  printf '  codex    Instala/configura skills apenas para codex\n'
  printf '  opencode Instala/configura skills apenas para opencode\n'
}

require_node() {
  command -v node >/dev/null 2>&1 || fail 'Node.js nao encontrado. Instale Node.js 18+.'
  command -v npm >/dev/null 2>&1 || fail 'npm nao encontrado. Instale npm.'

  local node_major
  node_major="$(node -p "process.versions.node.split('.')[0]")"
  if [ "${node_major}" -lt "${NODE_MIN_MAJOR}" ]; then
    fail "Node.js ${NODE_MIN_MAJOR}+ obrigatorio. Versao atual: $(node -v)"
  fi
}

install_playwright_cli() {
  log "Instalando ${PLAYWRIGHT_PACKAGE}..."
  if npm install -g "${PLAYWRIGHT_PACKAGE}"; then
    return 0
  fi

  log 'Instalacao global falhou. Tentando prefix local em ~/.local...'
  mkdir -p "${LOCAL_BIN_DIR}"
  npm install -g --prefix "${LOCAL_NPM_PREFIX}" "${PLAYWRIGHT_PACKAGE}"
  export PATH="${LOCAL_BIN_DIR}:${PATH}"
}

resolve_playwright_cli() {
  if command -v playwright-cli >/dev/null 2>&1; then
    return 0
  fi
  fail 'playwright-cli nao encontrado apos instalacao.'
}

install_skills_for_agent() {
  local agent="$1"
  local session_id
  session_id="${agent}-$(basename "$(pwd)")"
  if [ -n "${PLAYWRIGHT_CLI_SESSION_PREFIX:-}" ]; then
    session_id="${PLAYWRIGHT_CLI_SESSION_PREFIX}-${session_id}"
  fi

  log "Instalando skills para ${agent} (sessao: ${session_id})..."
  PLAYWRIGHT_CLI_SESSION="${session_id}" playwright-cli install --skills
}

verify_agent_binary() {
  local agent="$1"
  if command -v "${agent}" >/dev/null 2>&1; then
    log "CLI ${agent} detectada."
  else
    log "CLI ${agent} nao detectada no PATH. Skills foram instaladas, mas a CLI precisa estar instalada para uso."
  fi
}

main() {
  local target="${1:-all}"

  case "${target}" in
    all|codex|opencode) ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      usage
      fail "Alvo invalido: ${target}"
      ;;
  esac

  require_node
  install_playwright_cli
  resolve_playwright_cli
  playwright-cli --help >/dev/null

  case "${target}" in
    all)
      verify_agent_binary codex
      verify_agent_binary opencode
      install_skills_for_agent codex
      install_skills_for_agent opencode
      ;;
    codex)
      verify_agent_binary codex
      install_skills_for_agent codex
      ;;
    opencode)
      verify_agent_binary opencode
      install_skills_for_agent opencode
      ;;
  esac

  log 'Instalacao e configuracao concluida.'
}

main "${1:-all}"
