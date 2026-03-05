#!/bin/bash
# .repo/sonarq.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
. "${SCRIPT_DIR}/env.sh"

SONARQ_NAME='sonarqube'
CURSOR_MCP_FILE='.cursor/mcp.json'
OPENCODE_CONFIG_FILE='opencode.json'
SONARQUBE_TOKEN_PLACEHOLDER='__SET_SONARQUBE_TOKEN__'
SONARQUBE_ORG_PLACEHOLDER='__SET_SONARQUBE_ORG__'
SONARQUBE_URL_PLACEHOLDER='__SET_SONARQUBE_URL__'

log() {
  printf '[sonarq-setup] %s\n' "$1"
}

fail() {
  printf '[sonarq-setup][erro] %s\n' "$1" >&2
  exit 1
}

usage() {
  printf 'Uso: %s [all|codex|opencode|cursor]\n' "${0}"
  printf '  all      Configura SonarQube para codex, opencode e cursor (padrao)\n'
  printf '  codex    Configura apenas Codex MCP\n'
  printf '  opencode Configura apenas OpenCode MCP\n'
  printf '  cursor   Configura apenas Cursor MCP\n'
  printf '\n'
  printf 'Modo Cloud (padrao): define SONARQUBE_ORG (e opcional SONARQUBE_URL para cloud US)\n'
  printf 'Modo Server: nao define SONARQUBE_ORG e define SONARQUBE_URL\n'
}

require_node() {
  command -v node >/dev/null 2>&1 || fail 'Node.js nao encontrado. Instale Node.js.'
}

require_codex() {
  command -v codex >/dev/null 2>&1 || fail 'CLI codex nao encontrada no PATH.'
}

is_cloud_mode() {
  [ -n "${SONARQUBE_ORG:-}" ]
}

upsert_codex_sonarq() {
  require_codex

  local token_value org_value url_value
  token_value="${SONARQUBE_TOKEN:-${SONARQUBE_TOKEN_PLACEHOLDER}}"
  org_value="${SONARQUBE_ORG:-${SONARQUBE_ORG_PLACEHOLDER}}"
  url_value="${SONARQUBE_URL:-}"

  log 'Configurando MCP no Codex...'
  codex mcp remove "${SONARQ_NAME}" >/dev/null 2>&1 || true

  if is_cloud_mode; then
    if [ -n "${url_value}" ]; then
      codex mcp add "${SONARQ_NAME}" \
        --env "SONARQUBE_TOKEN=${token_value}" \
        --env "SONARQUBE_ORG=${org_value}" \
        --env "SONARQUBE_URL=${url_value}" \
        -- docker run --init --pull=always -i --rm -e SONARQUBE_TOKEN -e SONARQUBE_ORG -e SONARQUBE_URL mcp/sonarqube
    else
      codex mcp add "${SONARQ_NAME}" \
        --env "SONARQUBE_TOKEN=${token_value}" \
        --env "SONARQUBE_ORG=${org_value}" \
        -- docker run --init --pull=always -i --rm -e SONARQUBE_TOKEN -e SONARQUBE_ORG mcp/sonarqube
    fi
  else
    url_value="${SONARQUBE_URL:-${SONARQUBE_URL_PLACEHOLDER}}"
    codex mcp add "${SONARQ_NAME}" \
      --env "SONARQUBE_TOKEN=${token_value}" \
      --env "SONARQUBE_URL=${url_value}" \
      -- docker run --init --pull=always -i --rm -e SONARQUBE_TOKEN -e SONARQUBE_URL mcp/sonarqube
  fi
}

upsert_opencode_sonarq() {
  local repo_root
  repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
  local file_path="${repo_root}/${OPENCODE_CONFIG_FILE}"

  [ -f "${file_path}" ] || fail "Arquivo nao encontrado: ${OPENCODE_CONFIG_FILE}"
  require_node

  local token_value org_value url_value
  token_value="${SONARQUBE_TOKEN:-${SONARQUBE_TOKEN_PLACEHOLDER}}"
  org_value="${SONARQUBE_ORG:-${SONARQUBE_ORG_PLACEHOLDER}}"
  url_value="${SONARQUBE_URL:-}"

  log "Configurando MCP no ${OPENCODE_CONFIG_FILE}..."

  if is_cloud_mode; then
    if [ -n "${url_value}" ]; then
      node -e "const fs=require('fs');const p=process.argv[1];const token=process.argv[2];const org=process.argv[3];const url=process.argv[4];const data=JSON.parse(fs.readFileSync(p,'utf8'));if(!data.mcp)data.mcp={};data.mcp.sonarqube={type:'local',command:['docker','run','--init','--pull=always','-i','--rm','-e','SONARQUBE_TOKEN','-e','SONARQUBE_ORG','-e','SONARQUBE_URL','mcp/sonarqube'],env:{SONARQUBE_TOKEN:token,SONARQUBE_ORG:org,SONARQUBE_URL:url},enabled:true};fs.writeFileSync(p,JSON.stringify(data,null,2)+'\n');" "${file_path}" "${token_value}" "${org_value}" "${url_value}"
    else
      node -e "const fs=require('fs');const p=process.argv[1];const token=process.argv[2];const org=process.argv[3];const data=JSON.parse(fs.readFileSync(p,'utf8'));if(!data.mcp)data.mcp={};data.mcp.sonarqube={type:'local',command:['docker','run','--init','--pull=always','-i','--rm','-e','SONARQUBE_TOKEN','-e','SONARQUBE_ORG','mcp/sonarqube'],env:{SONARQUBE_TOKEN:token,SONARQUBE_ORG:org},enabled:true};fs.writeFileSync(p,JSON.stringify(data,null,2)+'\n');" "${file_path}" "${token_value}" "${org_value}"
    fi
  else
    url_value="${SONARQUBE_URL:-${SONARQUBE_URL_PLACEHOLDER}}"
    node -e "const fs=require('fs');const p=process.argv[1];const token=process.argv[2];const url=process.argv[3];const data=JSON.parse(fs.readFileSync(p,'utf8'));if(!data.mcp)data.mcp={};data.mcp.sonarqube={type:'local',command:['docker','run','--init','--pull=always','-i','--rm','-e','SONARQUBE_TOKEN','-e','SONARQUBE_URL','mcp/sonarqube'],env:{SONARQUBE_TOKEN:token,SONARQUBE_URL:url},enabled:true};fs.writeFileSync(p,JSON.stringify(data,null,2)+'\n');" "${file_path}" "${token_value}" "${url_value}"
  fi
}

upsert_cursor_sonarq() {
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

  local token_value org_value url_value
  token_value="${SONARQUBE_TOKEN:-${SONARQUBE_TOKEN_PLACEHOLDER}}"
  org_value="${SONARQUBE_ORG:-${SONARQUBE_ORG_PLACEHOLDER}}"
  url_value="${SONARQUBE_URL:-}"

  log "Configurando MCP no ${CURSOR_MCP_FILE}..."

  if is_cloud_mode; then
    if [ -n "${url_value}" ]; then
      node -e "const fs=require('fs');const p=process.argv[1];const token=process.argv[2];const org=process.argv[3];const url=process.argv[4];const data=JSON.parse(fs.readFileSync(p,'utf8'));if(!data.mcpServers)data.mcpServers={};data.mcpServers.sonarqube={command:'docker',args:['run','--init','--pull=always','-i','--rm','-e','SONARQUBE_TOKEN','-e','SONARQUBE_ORG','-e','SONARQUBE_URL','mcp/sonarqube'],env:{SONARQUBE_TOKEN:token,SONARQUBE_ORG:org,SONARQUBE_URL:url}};fs.writeFileSync(p,JSON.stringify(data,null,2)+'\n');" "${file_path}" "${token_value}" "${org_value}" "${url_value}"
    else
      node -e "const fs=require('fs');const p=process.argv[1];const token=process.argv[2];const org=process.argv[3];const data=JSON.parse(fs.readFileSync(p,'utf8'));if(!data.mcpServers)data.mcpServers={};data.mcpServers.sonarqube={command:'docker',args:['run','--init','--pull=always','-i','--rm','-e','SONARQUBE_TOKEN','-e','SONARQUBE_ORG','mcp/sonarqube'],env:{SONARQUBE_TOKEN:token,SONARQUBE_ORG:org}};fs.writeFileSync(p,JSON.stringify(data,null,2)+'\n');" "${file_path}" "${token_value}" "${org_value}"
    fi
  else
    url_value="${SONARQUBE_URL:-${SONARQUBE_URL_PLACEHOLDER}}"
    node -e "const fs=require('fs');const p=process.argv[1];const token=process.argv[2];const url=process.argv[3];const data=JSON.parse(fs.readFileSync(p,'utf8'));if(!data.mcpServers)data.mcpServers={};data.mcpServers.sonarqube={command:'docker',args:['run','--init','--pull=always','-i','--rm','-e','SONARQUBE_TOKEN','-e','SONARQUBE_URL','mcp/sonarqube'],env:{SONARQUBE_TOKEN:token,SONARQUBE_URL:url}};fs.writeFileSync(p,JSON.stringify(data,null,2)+'\n');" "${file_path}" "${token_value}" "${url_value}"
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

  case "${target}" in
    all)
      upsert_codex_sonarq
      upsert_opencode_sonarq
      upsert_cursor_sonarq
      ;;
    codex)
      upsert_codex_sonarq
      ;;
    opencode)
      upsert_opencode_sonarq
      ;;
    cursor)
      upsert_cursor_sonarq
      ;;
  esac

  log 'Instalacao e configuracao do SonarQube MCP concluida.'
}

main "${1:-all}"
