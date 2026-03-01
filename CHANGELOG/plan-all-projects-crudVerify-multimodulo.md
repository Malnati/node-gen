<!-- CHANGELOG/plan-all-projects-crudVerify-multimodulo.md -->
# Plano - Padronizacao `crudVerify[]` para projetos multi-modulo

## 1. Arquivos existentes relevantes para o escopo
- `test/e2e-generator/e2e.js`
- `test/e2e-generator/e2e.json`
- `test/e2e-generator/projects/*/db/database.*.sql`
- `Makefile`
- `CHANGELOG/20260301073905-e2e-notifications-cobertura-completa-crud.md`

## 2. Arquivos que serao alterados
- `test/e2e-generator/e2e.json`
- `CHANGELOG/plan-all-projects-crudVerify-multimodulo.md`
- `CHANGELOG/<timestamp>-all-projects-crudverify-multimodulo.md` (registro de execucao)

## 3. Requisitos combinados da mudanca e globais do projeto
- Aplicar o padrao `crudVerify[]` para os projetos multi-modulo restantes no `e2e.json`.
- Manter compatibilidade com o fluxo atual de `postVerify` para projetos sem `crudVerify[]`.
- Preservar execucao via `make e2e <project>` com foco em um projeto por validacao.
- Registrar evidencias de comandos executados e resultado objetivo em `CHANGELOG/`.
- Nao expandir escopo para refactors nao solicitados.

## 4. Requisitos atualmente nao atendidos que o plano busca resolver
- Cobertura CRUD completa ainda nao esta padronizada em todos os projetos multi-modulo.
- Parte dos projetos multi-modulo depende apenas de um endpoint de verificacao CRUD.

## 5. Regras combinadas da mudanca e regras globais do projeto
- Alterar somente o minimo necessario para suportar a padronizacao no `e2e.json`.
- Nao adicionar dependencias, novos servicos ou novos fluxos fora do E2E atual.
- Executar validacao apenas com alvos `make e2e <project>` (sem rodar todos os projetos de uma vez).
- Registrar no changelog final: arquivos alterados, comandos e status passou/falhou.

## 6. Regras atualmente nao atendidas que motivam os ajustes
- Ausencia de configuracao `crudVerify[]` em todos os projetos multi-modulo.
- Ausencia de checklist unico de cobertura CRUD por modulo para todos os multi-modulo.

## 7. Plano de auditoria (verificacoes manuais e automaticas)
1. Identificar no `e2e.json` quais projetos possuem mais de um modulo e ainda nao usam `crudVerify[]`.
2. Para cada projeto multi-modulo alvo, definir ao menos um endpoint CRUD por modulo (quando aplicavel).
3. Atualizar `e2e.json` mantendo formato JSON valido.
4. Validar sintaxe com parse JSON local.
5. Executar `make e2e <project>` em amostragem representativa de projetos multi-modulo alterados.
6. Confirmar em log E2E a presenca de `CRUD endpoint alvo: ...` para cada endpoint configurado no projeto testado.
7. Registrar evidencias no changelog de execucao com resultado objetivo.

## 8. Checklists aplicaveis em `docs/checklists/`
- Obrigatorios independentemente do tema:
  - Rastreabilidade da mudanca em `CHANGELOG/`
  - Evidencias de execucao (comandos + resultado)
  - Definicao de pronto com itens objetivos
- Checklists de contexto da tarefa:
  - Cobertura E2E por endpoint/modulo
  - Regressao do fluxo `make e2e <project>`

## Definicao de pronto deste plano
- Todos os projetos multi-modulo em `e2e.json` possuem `crudVerify[]` consistente com seus modulos/endpoints.
- O runner E2E permanece compativel com projetos single-modulo.
- Existe changelog de execucao da implementacao com evidencias de teste e status final.
