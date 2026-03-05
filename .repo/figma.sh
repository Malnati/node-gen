#!/bin/bash
# .repo/figma.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
. "${SCRIPT_DIR}/env.sh"

FIGMA_NAME='figma'
FIGMA_URL='https://mcp.figma.com/mcp'
CURSOR_MCP_FILE='.cursor/mcp.json'
OPENCODE_CONFIG_FILE='opencode.json'

log() {
  printf '[figma-setup] %s\n' "$1"
}

fail() {
  printf '[figma-setup][erro] %s\n' "$1" >&2
  exit 1
}

usage() {
  printf 'Uso: %s [all|codex|opencode|cursor]\n' "${0}"
  printf '  all      Configura Figma para codex, opencode e cursor (padrao)\n'
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

upsert_codex_figma() {
  require_codex

  log 'Configurando MCP no Codex...'
  codex mcp remove "${FIGMA_NAME}" >/dev/null 2>&1 || true
  codex mcp add "${FIGMA_NAME}" --url "${FIGMA_URL}"
}

upsert_opencode_figma() {
  local repo_root
  repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
  local file_path="${repo_root}/${OPENCODE_CONFIG_FILE}"

  [ -f "${file_path}" ] || fail "Arquivo nao encontrado: ${OPENCODE_CONFIG_FILE}"
  require_node

  log "Configurando MCP no ${OPENCODE_CONFIG_FILE}..."
  node -e "const fs=require('fs');const p=process.argv[1];const data=JSON.parse(fs.readFileSync(p,'utf8'));if(!data.mcp)data.mcp={};data.mcp.figma={type:'remote',url:'https://mcp.figma.com/mcp',enabled:true};fs.writeFileSync(p,JSON.stringify(data,null,2)+'\n');" "${file_path}"
}

upsert_cursor_figma() {
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
  node -e "const fs=require('fs');const p=process.argv[1];const data=JSON.parse(fs.readFileSync(p,'utf8'));if(!data.mcpServers)data.mcpServers={};data.mcpServers.figma={url:'https://mcp.figma.com/mcp'};fs.writeFileSync(p,JSON.stringify(data,null,2)+'\n');" "${file_path}"
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
      upsert_codex_figma
      upsert_opencode_figma
      upsert_cursor_figma
      ;;
    codex)
      upsert_codex_figma
      ;;
    opencode)
      upsert_opencode_figma
      ;;
    cursor)
      upsert_cursor_figma
      ;;
  esac

  log 'Instalacao e configuracao do Figma MCP concluida.'
}

main "${1:-all}"
