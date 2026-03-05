<!-- .repo/README.md -->
# Playwright Setup

Este diretório contém o script de bootstrap do Playwright CLI e skills para agentes.

## Arquivos
- `playwright.sh`: instala `@playwright/cli@latest` e executa `playwright-cli install --skills` para os alvos selecionados.

## Pré-requisitos
- Node.js 18+
- `npm`

## Uso
- `bash .repo/playwright.sh` ou `bash .repo/playwright.sh all`
- `bash .repo/playwright.sh codex`
- `bash .repo/playwright.sh opencode`

## Comportamento
- Valida versão mínima do Node.js.
- Tenta instalação global do `playwright-cli`.
- Se instalação global falhar, usa prefixo local em `~/.local`.
- Instala skills por sessão (`PLAYWRIGHT_CLI_SESSION`) para `codex` e/ou `opencode`.
