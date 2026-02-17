<!-- docs/issues/plan-issues-sub-1.md -->

# [SUB] 1 Revisar geradores base e checklist estrutural inicial

## Contexto
- Origem no plano: ordem de revisão itens 1 a 4 (`env-generator.ts`, `package-json-generator.ts`, `diagram-generator.ts`, `interface-generator.ts`) e auditoria de cobertura dos 13 geradores.
- Motivação: validar base de configuração/contratos antes de avançar para geradores dependentes.

## Objetivo
Concluir revisão técnica dos geradores base e estabelecer baseline confiável de naming, contratos e artefatos iniciais.

## Escopo
### Entra
- Revisão dos geradores:
  - `src/env-generator.ts`
  - `src/package-json-generator.ts`
  - `src/diagram-generator.ts`
  - `src/interface-generator.ts`
- Verificação dos critérios mínimos por gerador (entrada, transformação, escrita, idempotência, naming/path, templates, compilação do output).

### Não entra
- Revisão de controller/module/main/app-module/readme/datasource/dto/service/entity.
- Revisão de orquestração global em `src/main.ts`.

## Tarefas técnicas
- [ ] Auditar cadeia de variáveis/defaults e idempotência do `.env`.
- [ ] Validar scripts/dependências geradas no `package.json`.
- [ ] Verificar integridade de geração de diagrama para cenários simples e com múltiplas relações.
- [ ] Confirmar tipagem/nullable/opcional e consistência de imports das interfaces.
- [ ] Registrar status por gerador (`Aprovado`, `Aprovado com ressalvas`, `Reprovado`) e evidências.

## Critérios de aceite
- [ ] Quatro geradores base revisados com checklist completo.
- [ ] Achados com causa raiz e impacto técnico descritos.
- [ ] Evidências de validação do output registradas para cada gerador.
- [ ] Sem lacunas de rastreabilidade para itens 1–4 do plano.

## Riscos e dependências
- Dependência: nenhuma SUB anterior.
- Risco: inconsistências de naming/contrato nesta etapa afetam todas as próximas SUBs.

## Evidências esperadas
- Matriz de revisão dos geradores 1–4 com resultado objetivo.
- Comandos executados para validação local do output gerado.
- Lista de inconformidades com proposta de correção futura (sem implementar).

## Definição de pronto
- [ ] Itens 1–4 do plano cobertos integralmente.
- [ ] Checklist por gerador preenchido.
- [ ] Evidências anexáveis para auditoria.
- [ ] Dependências para `[SUB] 2` liberadas.
