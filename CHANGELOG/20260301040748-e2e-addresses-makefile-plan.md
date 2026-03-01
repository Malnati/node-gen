<!-- CHANGELOG/20260301040748-e2e-addresses-makefile-plan.md -->
# Plano — E2E `addresses` via Makefile com correção e reteste

## Data/Hora UTC
2026-03-01T04:07:48Z

## 1. Arquivos existentes relevantes
- `Makefile`
- `.docker/docker-compose.e2e.yml`
- `.docker/entrypoint.e2e.sh`
- `test/e2e-generator/run.js`
- `test/e2e-generator/e2e.js`
- `test/e2e-generator/e2e.json`
- `test/e2e-generator/projects/addresses/db/*`
- `CHANGELOG/*`

## 2. Arquivos que serão alterados
- `CHANGELOG/20260301040748-e2e-addresses-makefile-plan.md`
- `CHANGELOG/20260301040748-e2e-addresses-makefile-audit.md`
- Arquivos mínimos necessários para corrigir falhas detectadas no fluxo E2E de `addresses`

## 3. Requisitos combinados
- Executar E2E do projeto `addresses` usando somente `Makefile`.
- Não executar diretamente comandos Node/Docker para o fluxo de teste.
- Verificar resultado objetivo (passou/falhou) por execução.
- Corrigir defeitos encontrados com mudança mínima.
- Reexecutar o E2E via Makefile após correções.
- Registrar evidências no changelog de auditoria.
- Não excluir arquivos existentes.

## 4. Requisitos não atendidos no início do ciclo
- Não existia plano dedicado ao ciclo `addresses` com execução/correção/reteste via Makefile.
- Faltava referência consolidada de planos sem evidência de execução vinculada.

## 5. Regras combinadas
- Comandos de execução obrigatórios: `make e2e-clean`, `make e2e-addresses`.
- Escopo limitado ao defeito observado.
- Sem refatoração estética.
- Sem múltiplas soluções paralelas.

## 6. Regras não atendidas que motivam o ciclo
- Ausência de trilha dedicada e auditável deste fluxo específico.

## 7. Plano de auditoria
1. Criar plano e auditoria com mesmo prefixo de timestamp.
2. Executar `make e2e-clean`.
3. Executar `make e2e-addresses`.
4. Em caso de falha, corrigir somente a causa raiz.
5. Reexecutar `make e2e-addresses`.
6. Registrar no arquivo de auditoria:
- Comandos executados.
- Arquivos alterados.
- Resultado por tentativa (passou/falhou e motivo).
- Checklist de definição de pronto.

## 8. Checklists aplicáveis
- Governança e rastreabilidade por `CHANGELOG`.
- Execução E2E via comandos padronizados de `Makefile`.
- Mudança mínima sem expansão de escopo.

## Referências cruzadas — planos sem evidência de execução vinculada
- `CHANGELOG/20260217233500-plan-cli-test-execution-run.md`
- `CHANGELOG/20260217234500-plan-mock-project-codegen.md`
- `CHANGELOG/20260218000000-plan-test-project-generator-vs-mock.md`
- `CHANGELOG/20260227120000-api-generator-scope-plan.md`
- `CHANGELOG/20260227200000-api-nestjs-structure-plan.md`
- `CHANGELOG/plan-mfes.md`
