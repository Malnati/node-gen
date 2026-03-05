#!/bin/bash
# .repo/microsoft-sentinel-data-exploration.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
. "${SCRIPT_DIR}/env.sh"

MICROSOFT_SENTINEL_DATA_EXPLORATION_NAME='microsoft-sentinel-data-exploration'
MICROSOFT_SENTINEL_DATA_EXPLORATION_URL='https://sentinel.microsoft.com/mcp/data-exploration'
CURSOR_MCP_FILE='.cursor/mcp.json'
OPENCODE_CONFIG_FILE='opencode.json'

log() {
  printf '[microsoft-sentinel-data-exploration-setup] %s\n' "$1"
}

fail() {
  printf '[microsoft-sentinel-data-exploration-setup][erro] %s\n' "$1" >&2
  exit 1
}

usage() {
  printf 'Uso: %s [all|codex|opencode|cursor]\n' "${0}"
  printf '  all      Configura Microsoft Sentinel Data Exploration para codex, opencode e cursor (padrao)\n'
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

upsert_codex_microsoft_sentinel_data_exploration() {
  require_codex

  log 'Configurando MCP no Codex...'
  codex mcp remove "${MICROSOFT_SENTINEL_DATA_EXPLORATION_NAME}" >/dev/null 2>&1 || true
  codex mcp add "${MICROSOFT_SENTINEL_DATA_EXPLORATION_NAME}" --url "${MICROSOFT_SENTINEL_DATA_EXPLORATION_URL}"
}

upsert_opencode_microsoft_sentinel_data_exploration() {
  local repo_root
  repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
  local file_path="${repo_root}/${OPENCODE_CONFIG_FILE}"

  [ -f "${file_path}" ] || fail "Arquivo nao encontrado: ${OPENCODE_CONFIG_FILE}"
  require_node

  log "Configurando MCP no ${OPENCODE_CONFIG_FILE}..."
  node -e "const fs=require('fs');const p=process.argv[1];const data=JSON.parse(fs.readFileSync(p,'utf8'));if(!data.mcp)data.mcp={};data.mcp['microsoft-sentinel-data-exploration']={type:'remote',url:'https://sentinel.microsoft.com/mcp/data-exploration',enabled:true};fs.writeFileSync(p,JSON.stringify(data,null,2)+'\n');" "${file_path}"
}

upsert_cursor_microsoft_sentinel_data_exploration() {
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
  node -e "const fs=require('fs');const p=process.argv[1];const data=JSON.parse(fs.readFileSync(p,'utf8'));if(!data.mcpServers)data.mcpServers={};data.mcpServers['microsoft-sentinel-data-exploration']={url:'https://sentinel.microsoft.com/mcp/data-exploration'};fs.writeFileSync(p,JSON.stringify(data,null,2)+'\n');" "${file_path}"
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
      upsert_codex_microsoft_sentinel_data_exploration
      upsert_opencode_microsoft_sentinel_data_exploration
      upsert_cursor_microsoft_sentinel_data_exploration
      ;;
    codex)
      upsert_codex_microsoft_sentinel_data_exploration
      ;;
    opencode)
      upsert_opencode_microsoft_sentinel_data_exploration
      ;;
    cursor)
      upsert_cursor_microsoft_sentinel_data_exploration
      ;;
  esac

  log 'Instalacao e configuracao do Microsoft Sentinel Data Exploration MCP concluida.'
}

main "${1:-all}"
