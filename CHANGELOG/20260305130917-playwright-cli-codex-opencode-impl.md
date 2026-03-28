<!-- CHANGELOG/20260305130917-playwright-cli-codex-opencode-impl.md -->
# 2026-03-05 13:09:17 UTC - Automacao Playwright CLI + Skills (Codex/OpenCode)

## Arquivos modificados
- `.repo/playwright.sh`
- `CHANGELOG/20260305130917-playwright-cli-codex-opencode-impl.md`

## Referencias cruzadas
- Politicas aplicadas: `AGENTS.md`, `.github/copilot-instructions.md`, `opencode.json`
- Ciclos correlatos de Playwright: `CHANGELOG/20260302030713-playwright-sspa-impl.md`, `CHANGELOG/20260302030713-playwright-sspa-plan.md`

## Requisitos atendidos
- Automatizada a instalacao do `@playwright/cli@latest` com fallback para prefixo local (`~/.local`).
- Automatizada a instalacao de skills via `playwright-cli install --skills`.
- Configuracao suportando execucao por alvo: `all`, `codex` e `opencode`.
- Incluidas validacoes objetivas de ambiente: Node.js >= 18, `node`/`npm` presentes e resolucao de `playwright-cli`.

## Comandos executados
- `rg --files`
- `ls -la .repo || true`
- `find . -maxdepth 3 -name 'AGENTS.md' -o -name 'copilot-instructions.md' -o -name '*.instructions.md'`
- `sed -n '1,220p' .repo/playwright.sh`
- `sed -n '1,260p' .github/copilot-instructions.md`
- `sed -n '1,260p' .github/instructions/agent-skills.instructions.md`
- `sed -n '1,260p' .github/instructions/no-heredoc.instructions.md`
- `ls -la .repo && rg -n "playwright|codex|opencode|skills" opencode.json .repo -S`
- `sed -n '1,260p' opencode.json`
- `git status --short`
- `rg -n "codex|opencode|playwright-cli|PLAYWRIGHT_CLI_SESSION|skills" -S . | head -n 200`
- `date -u +%Y%m%d%H%M%S`

## Resultado resumido
- `PASSOU`: Script `.repo/playwright.sh` atualizado com automacao e configuracao para `codex` e `opencode`.
- `NAO EXECUTADO`: Instalacao real de pacotes no ambiente (sem execucao do script nesta entrega).

## Definicao de pronto (item a item)
- [x] Existe automacao em `.repo/playwright.sh` para instalacao do Playwright CLI.
- [x] Existe automacao em `.repo/playwright.sh` para instalacao de skills.
- [x] Fluxo contempla `codex` e `opencode` com selecao por alvo.
- [x] Mudanca restrita ao escopo solicitado.

## Pendencias relevantes
- Executar `.repo/playwright.sh all` no ambiente alvo para efetivar a instalacao dos binarios e skills.
