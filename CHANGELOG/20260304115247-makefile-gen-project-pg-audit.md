<!-- CHANGELOG/20260304115247-makefile-gen-project-pg-audit.md -->
# Auditoria — alvos Makefile por projeto para geração PostgreSQL (API e MFE Parcel Paging)

## Data/Hora UTC
2026-03-04T11:52:47Z

## Plano relacionado
- `CHANGELOG/20260304115247-makefile-gen-project-pg-plan.md`

## Comandos executados
1. `date -u +%Y%m%d%H%M%S`
2. Edição do `Makefile` para adicionar alvos dinâmicos por projeto:
   - `gen-<project>-pg-api`
   - `gen-<project>-pg-parcel-paging`

## Resultado resumido
- Implementação dos alvos no `Makefile`: **PASSOU**.
- Execução funcional dos novos alvos neste ciclo: **PENDENTE** (não executada nesta etapa para manter foco no registro do plano e mudança estrutural solicitada).
- Política de execução exclusiva via `Makefile` registrada no plano, no `AGENTS.md` e no `opencode.json`: **PASSOU**.

## Evidências obrigatórias
- Arquivos alterados:
  - `Makefile`
  - `AGENTS.md`
  - `opencode.json`
  - `CHANGELOG/20260304115247-makefile-gen-project-pg-plan.md`
  - `CHANGELOG/20260304115247-makefile-gen-project-pg-audit.md`
- Definição de pronto (escopo desta solicitação):
  - [x] Novo plano registrado em `CHANGELOG/` com pendências explícitas.
  - [x] Inclusão de entradas por projeto para `gen-<project>-pg-api`.
  - [x] Inclusão de entradas por projeto para `gen-<project>-pg-parcel-paging`.
  - [x] Padronização de saída para API em `output/api/postgres/<project>`.
  - [x] Padronização de saída para MFE Parcel Paging em `output/parcel/postgres/<project>/mfe-parcel-paging`.
  - [x] Regra explícita de execução exclusiva via `Makefile` (proibição de execução direta `npm`, `sh`, `docker`, `docker-compose` e equivalentes).
  - [ ] Validação de execução ponta a ponta dos novos alvos (pendente para próximo ciclo operacional).

## Pendências remanescentes referenciadas
- `make e2e-api-addresses` ainda falha no runner multi-db quando inclui `sqlserver`.
- `PLAYWRIGHT_PROJECT=addresses make playwright-test` ainda falha com `404` em endpoints esperados.
