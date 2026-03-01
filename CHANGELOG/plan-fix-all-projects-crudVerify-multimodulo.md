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
3. Executar `make e2e <project>` em projetos multi-modulo representativos.
4. Confirmar em log:
- `CRUD endpoint alvo: ...` para endpoints esperados.
- cobertura GET de todos os endpoints do projeto.
- fallback funcional quando `crudVerify[]` nao existir.
5. Caso haja defeito, corrigir e retestar o mesmo projeto.
6. Registrar resultado final (passou/falhou) com motivo objetivo.

## 8. Checklists aplicaveis em `docs/checklists/`
- Obrigatorios independentemente do tema:
  - Rastreabilidade em `CHANGELOG/`
  - Evidencias (arquivos, comandos, resultados)
  - Definicao de pronto com checklist objetivo
- Especificos desta mudanca:
  - Cobertura CRUD multi-endpoint por projeto
  - Fallback `postVerify` preservado
  - Validacao via `make e2e <project>`

## Definicao de pronto deste plano
- Runner valida CRUD multi-endpoint por `crudVerify[]` de forma consistente.
- Fallback para `postVerify` permanece funcional.
- Defeitos encontrados foram corrigidos e retestados.
- Nenhum arquivo foi criado/excluido durante implementacao deste plano.
