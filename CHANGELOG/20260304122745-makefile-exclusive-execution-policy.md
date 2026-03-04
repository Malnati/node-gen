<!-- CHANGELOG/20260304122745-makefile-exclusive-execution-policy.md -->
# 2026-03-04 12:27:45 UTC — Política de execução exclusiva via Makefile

## Arquivos modificados
- `AGENTS.md`
- `opencode.json`
- `CHANGELOG/20260304115247-makefile-gen-project-pg-plan.md`
- `CHANGELOG/20260304115247-makefile-gen-project-pg-audit.md`

## Regras e requisitos atendidos
- Inclusão explícita, no plano do ciclo atual, da regra de execução exclusiva por `Makefile`.
- Inclusão em `AGENTS.md` da proibição de execução direta de comandos operacionais fora do `Makefile` (`npm`, `sh`, `docker`, `docker-compose` e equivalentes).
- Inclusão da mesma política no `opencode.json`:
  - Prompt do agente de governança.
  - Template do comando `gov/plan`.
- Rastreabilidade preservada entre plano e auditoria do mesmo ciclo.

## Pendências relevantes
- Implementação dos novos alvos `e2e-<project>-pg-api` e `e2e-<project>-pg-parcel-paging` permanece pendente.
- Validação ponta a ponta da execução desses novos alvos permanece pendente.
