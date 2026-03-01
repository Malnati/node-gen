<!-- CHANGELOG/plan-fix-all-projects-crudVerify-multimodulo.md -->
# Plano - Fix all projects `crudVerify` multi-modulo

## 1. Arquivos existentes relevantes para o escopo
- `test/e2e-generator/e2e.js`
- `test/e2e-generator/e2e.json`
- `Makefile`
- `CHANGELOG/plan-all-projects-crudVerify-multimodulo.md`
- `CHANGELOG/20260301181242-all-projects-crudverify-multimodulo-execucao.md`

## 2. Arquivos que serao alterados
- `test/e2e-generator/e2e.js` (se houver defeitos de execucao/validacao)
- `test/e2e-generator/e2e.json` (se houver defeitos de configuracao `crudVerify[]`)
- `CHANGELOG/plan-fix-all-projects-crudVerify-multimodulo.md`

## 3. Requisitos combinados da mudanca e globais do projeto
- Testar multiplos endpoints CRUD por projeto via `crudVerify[]`.
- Manter fallback para `postVerify` quando `crudVerify[]` nao existir.
- Se encontrar defeitos, corrigir no menor escopo possivel.
- Executar validacao via `make e2e <project>` (sem rodar todos os projetos).
- Nao criar novos arquivos adicionais na implementacao deste plano.
- Nao excluir arquivos existentes.
- Registrar evidencias objetivas em changelog de execucao.

## 4. Requisitos atualmente nao atendidos que o plano busca resolver
- Possiveis regressos em cenarios multi-modulo com payload generico.
- Divergencias de cobertura CRUD entre bancos para endpoints sem corpo explicito.
- Necessidade de confirmar fallback `postVerify` funcionando quando aplicavel.

## 5. Regras combinadas da mudanca e regras globais do projeto
- Proibido criar novos arquivos na fase de implementacao deste plano.
- Proibido excluir arquivos.
- Alterar apenas `e2e.js` e/ou `e2e.json` se estritamente necessario.
- Nao adicionar dependencias, pipelines, servicos ou refactors amplos.
- Manter rastreabilidade de comandos e resultados.

## 6. Regras atualmente nao atendidas que motivam os ajustes
- Falhas potenciais de CRUD em endpoints com restricoes de dominio (campos obrigatorios).
- Falhas potenciais de resolucao de ID em fallback de endpoints genericos.

## 7. Plano de auditoria (verificacoes manuais e automaticas)
1. Revisar `e2e.js` para garantir ordem e fallback corretos (`crudVerify[]` -> `postVerify`).
2. Validar `e2e.json` para consistencia dos endpoints multi-modulo.
3. Executar `make e2e <project>` em TODOS os projetos multi-modulo:
   - addresses (4 modulos: country, state, city, address)
   - communications (4 modulos: email-template, smtp-config, send-history, delivery-tracking)
   - config (5 modulos: config, integration-config, webhook, branding, label)
   - consents (2 modulos: consent-record, notification-preference)
   - gmail (3 modulos: gmail-integration, gmail-message-template, gmail-message)
   - google-calendar (3 modulos: calendar-integration, calendar, calendar-event)
   - google-drive (3 modulos: drive-integration, drive-folder, drive-file)
   - llm (5 modulos: llm-log, llm-provider-config, prompt-template, llm-execution-log, llm-usage-summary)
   - logistics (2 modulos: shipment, shipment-event)
   - maps (3 modulos: map-provider-config, geocode-cache, route-cache)
   - notifications (2 modulos: notification-template, notification)
   - orders (2 modulos: order, order-item)
   - payments (2 modulos: payment-type, payment)
   - products (3 modulos: currency, unit-of-measure, product)
   - reports (3 modulos: consolidated-sales-monthly, current-warehouse-stock, logistics-performance)
   - roles (4 modulos: role, feature, role-feature, user-role)
   - schedule (6 modulos: resource, slot, recurrence-rule, booking, booking-participant, booking-history)
   - selling (2 modulos: order, order-line)
   - todo (4 modulos: category, simple-item, tag, simple-item-tag)
4. Executar `make e2e <project>` em projetos com apenas postVerify (verificacao de fallback):
   - accounts, auth, contacts, tenant, transactions, users, warehouse
5. Confirmar em log:
   - `CRUD endpoint alvo: ...` para cada endpoint do crudVerify[].
   - cobertura GET de todos os endpoints do projeto.
   - fallback funcional quando `crudVerify[]` nao existir.
6. Caso haja defeito, corrigir e retestar o mesmo projeto.
7. Registrar resultado final (passou/falhou) com motivo objetivo.

## 8. Checklists aplicaveis em `docs/checklists/`
- Obrigatorios independentemente do tema:
  - Rastreabilidade em `CHANGELOG/`
  - Evidencias (arquivos, comandos, resultados)
  - Definicao de pronto com checklist objetivo
- Especificos desta mudanca:
  - Cobertura CRUD multi-endpoint por projeto
  - Fallback `postVerify` preservado
  - Validacao via `make e2e <project>`

## Status do plano
- **Data de execucao**: 2026-03-01 19:44:00 UTC
- **Status**: CONCLUIDO (sem defeitos encontrados)
- **Resultado**: Todos os 26 projetos testados passaram (19 multi-modulo + 7 com postVerify)
