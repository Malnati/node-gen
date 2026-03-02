<!-- CHANGELOG/20260302094414-sspa-comprehensive-playwright-plan.md -->
# Plano 2026-03-02 09:44:14 UTC - Cobertura Abrangente SSPA (Playwright + Logs)

## 1. Arquivos existentes relevantes para o escopo
- `/root/w/node-gen/Makefile`
- `/root/w/node-gen/test/sspa.spec.ts`
- `/root/w/node-gen/.docker/Dockerfile.sspa`
- `/root/w/node-gen/.docker/docker-compose.projects.postgres.yml`
- `/root/w/node-gen/CHANGELOG/20260302034851-sspa-playwright-remediation-plan.md`
- `/root/w/node-gen/CHANGELOG/20260302034851-sspa-playwright-remediation-audit.md`
- `/root/w/node-gen/CHANGELOG/20260302034851-sspa-playwright-remediation-impl.md`

## 2. Arquivos que serão alterados
- `/root/w/node-gen/Makefile`
- `/root/w/node-gen/test/sspa.spec.ts`
- `/root/w/node-gen/.docker/Dockerfile.sspa`
- `/root/w/node-gen/CHANGELOG/20260302094414-sspa-comprehensive-playwright-audit.md`
- `/root/w/node-gen/CHANGELOG/20260302094414-sspa-comprehensive-playwright-impl.md`

## 3. Requisitos combinados da mudança específica e globais
- Cobrir de forma mais abrangente o SSPA via Playwright para cenários prováveis de acesso, autenticação, autorização, inclusão, alteração, exclusão e segurança.
- Validar códigos HTTP retornados para operações CRUD sem credencial e com credencial inválida.
- Validar comportamento do orquestrador para rotas dos micro-frontends sem regressão de `404`/`5xx`.
- Registrar logs e resultados com rastreabilidade entre containers `sspa`, `apis` e `postgres-shared`.
- Executar os testes via Makefile (`make playwright-test`) com artefatos persistidos em disco.

## 4. Requisitos atualmente não atendidos que o plano busca resolver
- Cobertura atual não valida matriz ampla de métodos HTTP (GET/POST/PATCH/DELETE) por projeto/entidade.
- Não há assertiva de segurança para tentativas comuns de path traversal no orquestrador.
- Logs de runtime não são exportados de forma consolidada para todos os containers necessários no mesmo ciclo.

## 5. Regras combinadas da mudança específica e regras globais do projeto
- Escopo cirúrgico: alterar apenas arquivos necessários ao teste e rastreabilidade.
- Manter execução via Makefile e Playwright já existentes.
- Não introduzir novas dependências ou scripts shell dedicados.
- Preservar conformidade de governança com registro em CHANGELOG.

## 6. Regras atualmente não atendidas que motivam os ajustes
- Cobertura de testes insuficiente para o risco operacional do orquestrador multi-projeto.
- Ausência de trilha consolidada de logs entre `sspa`, `apis` e `db` na mesma execução dos testes.

## 7. Plano de auditoria (verificações manuais e automáticas)
- Executar `make playwright-clean`.
- Executar `docker compose -f .docker/docker-compose.projects.postgres.yml --project-directory . down -v --remove-orphans`.
- Executar `make playwright-test`.
- Confirmar geração de:
  - `playwright-results/playwright-run.log`
  - `playwright-results/results.json`
  - `playwright-results/containers-sspa.log`
  - `playwright-results/containers-apis.log`
  - `playwright-results/containers-postgres.log`
  - `playwright-results/http-matrix.json`
- Validar que os testes abrangentes passam sem `404` inesperado no orquestrador e com códigos HTTP coerentes para autenticação/autorização/CRUD provável.

## 8. Checklists aplicáveis
- `docs/checklists/` não encontrado no estado atual do repositório.
- Checklist obrigatório aplicado: execução automatizada completa, validação de segurança básica, coleta de logs multi-container e rastreabilidade em CHANGELOG.

## Referências cruzadas
- Auditoria: `/root/w/node-gen/CHANGELOG/20260302094414-sspa-comprehensive-playwright-audit.md`
- Implementação: `/root/w/node-gen/CHANGELOG/20260302094414-sspa-comprehensive-playwright-impl.md`
