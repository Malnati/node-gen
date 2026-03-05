#!/bin/bash
# .repo/context7.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
. "${SCRIPT_DIR}/env.sh"

NODE_MIN_MAJOR=18
CONTEXT7_NAME='context7'
CONTEXT7_MCP_PACKAGE='@upstash/context7-mcp'
CURSOR_MCP_FILE='.cursor/mcp.json'
OPENCODE_CONFIG_FILE='opencode.json'
CODEX_CONFIG_FILE="${HOME}/.codex/config.toml"
CODEX_CONTEXT7_STARTUP_TIMEOUT_SEC="${CODEX_CONTEXT7_STARTUP_TIMEOUT_SEC:-30}"

log() {
  printf '[context7-setup] %s\n' "$1"
}

fail() {
  printf '[context7-setup][erro] %s\n' "$1" >&2
  exit 1
}

usage() {
  printf 'Uso: %s [all|codex|opencode|cursor]\n' "${0}"
  printf '  all      Configura Context7 para codex, opencode e cursor (padrao)\n'
  printf '  codex    Configura apenas Codex MCP\n'
  printf '  opencode Configura apenas OpenCode MCP\n'
  printf '  cursor   Configura apenas Cursor MCP\n'
}

require_node() {
  command -v node >/dev/null 2>&1 || fail 'Node.js nao encontrado. Instale Node.js 18+.'
  command -v npm >/dev/null 2>&1 || fail 'npm nao encontrado. Instale npm.'
  command -v npx >/dev/null 2>&1 || fail 'npx nao encontrado. Instale npm.'

  local node_major
  node_major="$(node -p "process.versions.node.split('.')[0]")"
  if [ "${node_major}" -lt "${NODE_MIN_MAJOR}" ]; then
    fail "Node.js ${NODE_MIN_MAJOR}+ obrigatorio. Versao atual: $(node -v)"
  fi
}

require_codex() {
  command -v codex >/dev/null 2>&1 || fail 'CLI codex nao encontrada no PATH.'
}

upsert_codex_startup_timeout() {
  local config_file="${CODEX_CONFIG_FILE}"
  local timeout="${CODEX_CONTEXT7_STARTUP_TIMEOUT_SEC}"

  if ! [[ "${timeout}" =~ ^[0-9]+$ ]]; then
    fail "CODEX_CONTEXT7_STARTUP_TIMEOUT_SEC invalido: ${timeout}"
  fi

  if [ ! -f "${config_file}" ]; then
    mkdir -p "$(dirname "${config_file}")"
    printf '' > "${config_file}"
  fi

  local tmp_file
  tmp_file="$(mktemp)"

  awk -v timeout="${timeout}" '
    BEGIN { in_section = 0; done = 0; found = 0 }
    {
      if ($0 ~ /^\[mcp_servers\.context7\]/) {
        found = 1
        print
        in_section = 1
        next
      }
      if (in_section && $0 ~ /^\[/) {
        if (!done) {
          print "startup_timeout_sec = " timeout
          done = 1
        }
        in_section = 0
      }
      if (in_section && $0 ~ /^startup_timeout_sec[[:space:]]*=/) {
        if (!done) {
          print "startup_timeout_sec = " timeout
          done = 1
        }
        next
      }
      print
    }
    END {
      if (in_section && !done) {
        print "startup_timeout_sec = " timeout
        done = 1
      }
      if (!found) {
        if (NR > 0) {
          print ""
        }
        print "[mcp_servers.context7]"
        print "startup_timeout_sec = " timeout
      }
    }
  ' "${config_file}" > "${tmp_file}"

  mv "${tmp_file}" "${config_file}"
  log "startup_timeout_sec configurado para ${timeout} em ${config_file}."
}

upsert_codex_context7() {
  require_codex

  log 'Configurando MCP no Codex...'
  codex mcp remove "${CONTEXT7_NAME}" >/dev/null 2>&1 || true

  if [ -n "${CONTEXT7_API_KEY:-}" ]; then
    codex mcp add "${CONTEXT7_NAME}" -- npx -y "${CONTEXT7_MCP_PACKAGE}" --api-key "${CONTEXT7_API_KEY}"
  else
    codex mcp add "${CONTEXT7_NAME}" -- npx -y "${CONTEXT7_MCP_PACKAGE}"
  fi

  upsert_codex_startup_timeout
}

upsert_opencode_context7() {
  local repo_root
  repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
  local file_path="${repo_root}/${OPENCODE_CONFIG_FILE}"

  [ -f "${file_path}" ] || fail "Arquivo nao encontrado: ${OPENCODE_CONFIG_FILE}"

  log "Configurando MCP no ${OPENCODE_CONFIG_FILE}..."

  if [ -n "${CONTEXT7_API_KEY:-}" ]; then
    node -e "const fs=require('fs');const p=process.argv[1];const key=process.argv[2];const data=JSON.parse(fs.readFileSync(p,'utf8'));if(!data.mcp)data.mcp={};data.mcp.context7={type:'remote',url:'https://mcp.context7.com/mcp',headers:{CONTEXT7_API_KEY:key},enabled:true};fs.writeFileSync(p,JSON.stringify(data,null,2)+'\n');" "${file_path}" "${CONTEXT7_API_KEY}"
  else
    node -e "const fs=require('fs');const p=process.argv[1];const data=JSON.parse(fs.readFileSync(p,'utf8'));if(!data.mcp)data.mcp={};data.mcp.context7={type:'remote',url:'https://mcp.context7.com/mcp',enabled:true};fs.writeFileSync(p,JSON.stringify(data,null,2)+'\n');" "${file_path}"
  fi
}

upsert_cursor_context7() {
  local repo_root
  repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
  local file_path="${repo_root}/${CURSOR_MCP_FILE}"
  local file_dir
  file_dir="$(dirname "${file_path}")"

  mkdir -p "${file_dir}"
  if [ ! -f "${file_path}" ]; then
    printf '{\n  "mcpServers": {}\n}\n' > "${file_path}"
  fi

  log "Configurando MCP no ${CURSOR_MCP_FILE}..."

  if [ -n "${CONTEXT7_API_KEY:-}" ]; then
    node -e "const fs=require('fs');const p=process.argv[1];const key=process.argv[2];const data=JSON.parse(fs.readFileSync(p,'utf8'));if(!data.mcpServers)data.mcpServers={};data.mcpServers.context7={url:'https://mcp.context7.com/mcp',headers:{CONTEXT7_API_KEY:key}};fs.writeFileSync(p,JSON.stringify(data,null,2)+'\n');" "${file_path}" "${CONTEXT7_API_KEY}"
  else
    node -e "const fs=require('fs');const p=process.argv[1];const data=JSON.parse(fs.readFileSync(p,'utf8'));if(!data.mcpServers)data.mcpServers={};data.mcpServers.context7={url:'https://mcp.context7.com/mcp'};fs.writeFileSync(p,JSON.stringify(data,null,2)+'\n');" "${file_path}"
  fi
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

  require_node

  case "${target}" in
    all)
      upsert_codex_context7
      upsert_opencode_context7
      upsert_cursor_context7
      ;;
    codex)
      upsert_codex_context7
      ;;
    opencode)
      upsert_opencode_context7
      ;;
    cursor)
      upsert_cursor_context7
      ;;
  esac

  if [ -z "${CONTEXT7_API_KEY:-}" ]; then
    log 'CONTEXT7_API_KEY nao definido. Configuracao criada sem chave (limite menor).'
  fi

  log 'Instalacao e configuracao do Context7 concluida.'
}

main "${1:-all}"
