<!-- CHANGELOG/20260305153000-service-discovery-mfe-correcoes-impl.md -->
# 2026-03-05 15:30:00 UTC - Correções pós-implementação service-discovery MFE

## Plano relacionado
- `CHANGELOG/20260305153000-service-discovery-mfe-correcoes-plan.md`

## Arquivos alterados
- `gen/templates/mfe-docker-compose.ejs` - corrigido VITE_API_URL para usar variável de ambiente

## Requisitos e regras atendidos
- `REG-SD-005`: importUrl de manifesto usa placeholder `${VITE_MFE_BASE_URL:-http://localhost:9000}`
- `REG-SD-003`: VITE_API_URL agora usa `${VITE_API_URL:-http://api:3000}` com fallback seguro
- Fallback localhost presente apenas como fallback (menor prioridade) - conforme planejado

## Comandos executados (via Makefile)
1. `make gen-mfe GEN_PROJECT=projects/accounts GEN_OUTPUT=output/accounts/postgres`
2. `make gen-mfe GEN_PROJECT=projects/contacts GEN_OUTPUT=output/contacts/postgres`
3. `make gen-mfe GEN_PROJECT=projects/orders GEN_OUTPUT=output/orders/postgres`

## Resultado resumido
- accounts: **PASSOU** (1 MFE gerado com manifest.json correto)
- contacts: **PASSOU** (1 MFE gerado com manifest.json correto)
- orders: **PASSOU** (2 MFEs gerados com manifest.json correto)

Todos manifestos gerados com:
- name: @mfe/<name>
- module: @mfe/<name>
- route: /<name>
- title: <Name>
- description: MFE <Name>
- importUrl: ${VITE_MFE_BASE_URL:-http://localhost:9000}/mfes/<name>-mfe/spa.js

## Pendências objetivas
- Nenhuma pendência restante neste ciclo

## Checklists executados
- [x] Templates: placeholders de variáveis de ambiente verificados
- [x] Código morto: não encontrado (Bootstrap.tsx e ErrorBoundary.tsx são utilizados)
- [x] Build: geração sem erros TypeScript (erro de conexão com banco é esperado sem banco rodando)
- [x] Teste com 3 projetos diferentes: accounts, contacts, orders - todos OK
