#!/bin/bash
# .repo/microsoft-learn.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
. "${SCRIPT_DIR}/env.sh"

MICROSOFT_LEARN_NAME='microsoft-learn'
MICROSOFT_LEARN_URL='https://learn.microsoft.com/api/mcp'
CURSOR_MCP_FILE='.cursor/mcp.json'
OPENCODE_CONFIG_FILE='opencode.json'

log() {
  printf '[microsoft-learn-setup] %s\n' "$1"
}

fail() {
  printf '[microsoft-learn-setup][erro] %s\n' "$1" >&2
  exit 1
}

usage() {
  printf 'Uso: %s [all|codex|opencode|cursor]\n' "${0}"
  printf '  all      Configura Microsoft Learn para codex, opencode e cursor (padrao)\n'
  printf '  codex    Configura apenas Codex MCP\n'
  printf '  opencode Configura apenas OpenCode MCP\n'
  printf '  cursor   Configura apenas Cursor MCP\n'
}

require_node() {
  command -v node >/dev/null 2>&1 || fail 'Node.js nao encontrado. Instale Node.js.'
}

require_codex() {
  command -v codex >/dev/null 2>&1 || fail 'CLI codex nao encontrada no PATH.'
}

upsert_codex_microsoft_learn() {
  require_codex

  log 'Configurando MCP no Codex...'
  codex mcp remove "${MICROSOFT_LEARN_NAME}" >/dev/null 2>&1 || true
  codex mcp add "${MICROSOFT_LEARN_NAME}" --url "${MICROSOFT_LEARN_URL}"
}

upsert_opencode_microsoft_learn() {
  local repo_root
  repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
  local file_path="${repo_root}/${OPENCODE_CONFIG_FILE}"

  [ -f "${file_path}" ] || fail "Arquivo nao encontrado: ${OPENCODE_CONFIG_FILE}"
  require_node

  log "Configurando MCP no ${OPENCODE_CONFIG_FILE}..."
  node -e "const fs=require('fs');const p=process.argv[1];const data=JSON.parse(fs.readFileSync(p,'utf8'));if(!data.mcp)data.mcp={};data.mcp['microsoft-learn']={type:'remote',url:'https://learn.microsoft.com/api/mcp',enabled:true};fs.writeFileSync(p,JSON.stringify(data,null,2)+'\n');" "${file_path}"
}

upsert_cursor_microsoft_learn() {
  local repo_root
  repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
  local file_path="${repo_root}/${CURSOR_MCP_FILE}"
  local file_dir
  file_dir="$(dirname "${file_path}")"

  mkdir -p "${file_dir}"
  if [ ! -f "${file_path}" ]; then
    printf '{\n  "mcpServers": {}\n}\n' > "${file_path}"
  fi

  require_node

  log "Configurando MCP no ${CURSOR_MCP_FILE}..."
  node -e "const fs=require('fs');const p=process.argv[1];const data=JSON.parse(fs.readFileSync(p,'utf8'));if(!data.mcpServers)data.mcpServers={};data.mcpServers['microsoft-learn']={url:'https://learn.microsoft.com/api/mcp'};fs.writeFileSync(p,JSON.stringify(data,null,2)+'\n');" "${file_path}"
}

main() {
  local target="${1:-all}"

  case "${target}" in
    all|codex|opencode|cursor) ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      usage
      fail "Alvo invalido: ${target}"
      ;;
  esac

  case "${target}" in
    all)
      upsert_codex_microsoft_learn
      upsert_opencode_microsoft_learn
      upsert_cursor_microsoft_learn
      ;;
    codex)
      upsert_codex_microsoft_learn
      ;;
    opencode)
      upsert_opencode_microsoft_learn
      ;;
    cursor)
      upsert_cursor_microsoft_learn
      ;;
  esac

  log 'Instalacao e configuracao do Microsoft Learn MCP concluida.'
}

main "${1:-all}"
