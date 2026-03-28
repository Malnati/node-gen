<!-- CHANGELOG/20260305154454-context7-mcp-setup-codex-opencode-cursor.md -->
# 2026-03-05 15:44:54 UTC - Context7 MCP Setup (Codex/OpenCode/Cursor)

## Arquivos modificados
- `.repo/context7.sh`
- `.repo/README.md`
- `opencode.json`
- `CHANGELOG/20260305154454-context7-mcp-setup-codex-opencode-cursor.md`

## Referencias cruzadas
- Politicas aplicadas: `AGENTS.md`, `.github/copilot-instructions.md`, `opencode.json`
- Script base de referencia: `.repo/playwright.sh`

## Requisitos atendidos
- Adicionado setup automatizado para Context7 em `.repo/context7.sh`.
- Fluxo com selecao de alvo: `all`, `codex`, `opencode`, `cursor`.
- Adicionada configuracao MCP `context7` no `opencode.json`.
- Atualizada documentacao de scripts em `.repo/README.md`.

## Comandos executados
- `rg --files .repo`
- `rg --files | rg 'AGENTS.md|copilot-instructions|opencode|CHANGELOG|playwright\\.sh|mcp|cursor'`
- `git status --short`
- `sed -n '1,220p' .repo/playwright.sh`
- `sed -n '1,260p' .repo/README.md`
- `sed -n '1,260p' .github/copilot-instructions.md`
- `rg -n "context7|mcp|opencode|cursor|codex" -S .repo opencode.json README.md AGENTS.md .github`
- `sed -n '1,260p' opencode.json`
- `codex --help`
- `opencode --help`
- `codex mcp --help`
- `codex mcp add --help`
- `codex mcp list`
- `date -u +%Y%m%d%H%M%S`
- `bash -n .repo/context7.sh`
- `node -e "JSON.parse(require('fs').readFileSync('opencode.json','utf8'))"`

## Resultado resumido
- `PASSOU`: Script `.repo/context7.sh` criado para setup de Codex/OpenCode/Cursor.
- `PASSOU`: MCP `context7` adicionado em `opencode.json`.
- `PASSOU`: README do diretório `.repo` atualizado com uso do novo script.
- `NAO EXECUTADO`: rodar o setup real no ambiente (`bash .repo/context7.sh all`).

## Definicao de pronto (item a item)
- [x] MCP Context7 adicionado no repositório.
- [x] Instalacao/setup automatizado criado em `.repo/context7.sh`.
- [x] Cobertura de setup para `codex`, `opencode` e `cursor`.
- [x] Escopo mantido apenas no necessario para a solicitacao.

## Pendencias relevantes
- Executar `bash .repo/context7.sh all` no ambiente alvo para aplicar a configuracao de MCP em cada cliente.
