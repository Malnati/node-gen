<!-- CHANGELOG/20260305204008-microsoft-sentinel-data-exploration-mcp-setup.md -->
# 2026-03-05 20:40:08 UTC - Script de instalacao do Microsoft Sentinel Data Exploration MCP

## Arquivos alterados
- .repo/microsoft-sentinel-data-exploration.sh
- .repo/README.md
- opencode.json
- CHANGELOG/20260305204008-microsoft-sentinel-data-exploration-mcp-setup.md

## Comandos executados
- `pwd && ls -la && ls -la .repo`
- `rg --files .repo`
- `rg -n "codex|opencode|mcp|install|repo" .repo -S`
- `sed -n '1,220p' .repo/microsoft-learn.sh`
- `sed -n '1,220p' .repo/context7.sh`
- `sed -n '1,220p' .repo/env.sh`
- `sed -n '1,220p' .repo/README.md`
- `date -u +%Y%m%d%H%M%S`
- `chmod +x .repo/microsoft-sentinel-data-exploration.sh`
- `bash -n .repo/microsoft-sentinel-data-exploration.sh`
- `bash .repo/microsoft-sentinel-data-exploration.sh --help`
- `bash .repo/microsoft-sentinel-data-exploration.sh codex`
- `bash .repo/microsoft-sentinel-data-exploration.sh opencode`
- `git status --short`

## Resultado resumido
- Script: **passou** (arquivo criado, executavel e com sintaxe valida).
- Codex: **passou** (MCP global `microsoft-sentinel-data-exploration` adicionado com sucesso).
- OpenCode: **passou** (entrada MCP adicionada/atualizada em `opencode.json`).
- Documentacao: **passou** (`.repo/README.md` atualizado com arquivo, uso e comportamento).

## Definicao de pronto
- [x] Criar `/.repo/microsoft-sentinel-data-exploration.sh` seguindo o padrao dos scripts em `.repo/*`.
- [x] Configurar endpoint remoto `https://sentinel.microsoft.com/mcp/data-exploration` para Codex e OpenCode.
- [x] Executar instalador para `codex`.
- [x] Executar instalador para `opencode`.
- [x] Atualizar `.repo/README.md` com instrucoes do novo script.
- [x] Registrar evidencias em novo arquivo de changelog com timestamp UTC.
