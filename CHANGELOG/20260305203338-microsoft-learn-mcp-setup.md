<!-- CHANGELOG/20260305203338-microsoft-learn-mcp-setup.md -->
# 2026-03-05 20:33:38 UTC - Script de instalacao do Microsoft Learn MCP

## Arquivos alterados
- .repo/microsoft-learn.sh
- .repo/README.md
- CHANGELOG/20260305203338-microsoft-learn-mcp-setup.md

## Comandos executados
- `git status --short`
- `date -u +%Y%m%d%H%M%S`
- `chmod +x .repo/microsoft-learn.sh`
- `bash -n .repo/microsoft-learn.sh`
- `bash .repo/microsoft-learn.sh --help`

## Resultado resumido
- Script: **passou** (arquivo criado com sintaxe valida e ajuda funcional).
- Documentacao: **passou** (README atualizado com arquivo, uso e comportamento).

## Definicao de pronto
- [x] Criar `/.repo/microsoft-learn.sh` seguindo o padrao dos scripts em `.repo/*`.
- [x] Suportar alvos `all|codex|opencode|cursor` com `all` como padrao.
- [x] Configurar endpoint remoto `https://learn.microsoft.com/api/mcp` para Codex, OpenCode e Cursor.
- [x] Atualizar `.repo/README.md` com instrucoes do novo script.
- [x] Registrar evidencias em novo arquivo de changelog com timestamp UTC.
