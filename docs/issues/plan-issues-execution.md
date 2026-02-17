<!-- docs/issues/plan-issues-execution.md -->

# Execução do plano (EPIC + SUBs) em agentes CLI

## Escopo executado
- Artefatos lidos e validados:
  - `docs/template-review-plan.md`
  - `docs/issues/plan-issues-epic.md`
  - `docs/issues/plan-issues-guide.md`
  - `docs/issues/plan-issues-sub-1.md`
  - `docs/issues/plan-issues-sub-2.md`
  - `docs/issues/plan-issues-sub-3.md`
  - `docs/issues/plan-issues-sub-4.md`
- Revisão estática dos 13 geradores TypeScript e componentes transversais obrigatórios (`src/main.ts`, `src/utils/template-loader.ts`, `src/utils/TemplateEngine.ts`, `src/utils/string.ts`).
- Registro do bloqueio objetivo de ambiente para validações automáticas completas (`npm install` e `npm run build`).

## Validação de integração externa (MCP GitHub)
- Verificação executada com `list_mcp_resources`.
- Resultado: sem recursos MCP disponíveis para GitHub nesta sessão.
- Impacto: rastreabilidade ficou 100% no repositório via Markdown (sem tracker externo).

## Matriz de dependências e ordem de execução
1. `[SUB] 1` (geradores base) — **executada**.
2. `[SUB] 2` (intermediários) — **executada após SUB 1**.
3. `[SUB] 3` (domínio/persistência) — **executada após SUB 2**.
4. `[SUB] 4` (transversal + fechamento) — **executada após SUB 3**.

Status da ordem técnica: **Conforme** (sem quebra de dependência).

## Consolidação por SUB

### [SUB] 1 — Geradores base (itens 1–4)
- Escopo revisado: `env-generator`, `package-json-generator`, `diagram-generator`, `interface-generator`.
- Resultado: **Concluída com ressalvas** (checklist coberto; validação automática final limitada por dependências indisponíveis).
- Principais achados:
  - `.env` com endpoints fixos e `PORT` fixo, reduzindo flexibilidade de ambiente.
  - `package.json` gerado contém scripts destrutivos (`rm -rf node_modules` + `npm install`) em comandos de execução/teste.
  - `interface-generator` usa fallback `any` para tipos não mapeados.

### [SUB] 2 — Geradores intermediários (itens 5–9)
- Escopo revisado: `controller-generator`, `module-generator`, `main-generator`, `app-module-generator`, `readme-generator`.
- Resultado: **Concluída com ressalvas**.
- Principais achados:
  - `controller-generator` gera `camelCaseName` a partir de valor em PascalCase, podendo manter inicial maiúscula indevidamente no nome de variável.
  - `main-generator` gera `src/app/main.ts`, exigindo alinhamento com bootstrap esperado do template final.
  - README depende de mapeamento parcial de tipos e pode degradar descrição para tipos fora do mapa básico.

### [SUB] 3 — Geradores de domínio/persistência (itens 10–13)
- Escopo revisado: `datasource-generator`, `dto-generator`, `service-generator`, `typeorm-entity-generator`.
- Resultado: **Concluída com ressalvas**.
- Principais achados:
  - `dto-generator` usa validação para tipo `UUID`, porém o mapeamento retorna `string`, o que impede o decorador `@IsUUID()` nesse fluxo.
  - `typeorm-entity-generator` marca PK por heurística (`columnName.includes("id")`), sujeita a falsos positivos.
  - `datasource-generator` importa entidades por `@app/entities/<snake_case>`, dependente de aliases/template estarem sincronizados.

### [SUB] 4 — Análises transversais e fechamento
- Escopo revisado: leitura de schema (`DbReader*`), templates, naming/path, orquestração (`main.ts`) e validações automáticas.
- Resultado: **Concluída com ressalvas e bloqueio objetivo registrado**.
- Principais achados:
  - Orquestração usa `Promise.all` para geração paralela, com potencial de condição de corrida quando há dependência implícita entre artefatos.
  - Fluxo final força `npm install` no output; ambiente bloqueou instalação com `403` no registry.
  - Build local do próprio gerador bloqueado por ausência de tipos Node (`TS2688`).

## Classificação final dos 13 geradores
- `src/env-generator.ts` — **Aprovado com ressalvas**.
- `src/package-json-generator.ts` — **Aprovado com ressalvas**.
- `src/diagram-generator.ts` — **Aprovado com ressalvas**.
- `src/interface-generator.ts` — **Aprovado com ressalvas**.
- `src/controller-generator.ts` — **Aprovado com ressalvas**.
- `src/module-generator.ts` — **Aprovado com ressalvas**.
- `src/main-generator.ts` — **Aprovado com ressalvas**.
- `src/app-module-generator.ts` — **Aprovado**.
- `src/readme-generator.ts` — **Aprovado com ressalvas**.
- `src/datasource-generator.ts` — **Aprovado com ressalvas**.
- `src/dto-generator.ts` — **Aprovado com ressalvas**.
- `src/service-generator.ts` — **Aprovado com ressalvas**.
- `src/typeorm-entity-generator.ts` — **Reprovado** (heurística de PK baseada em substring `id`, com risco estrutural alto em cenários críticos).

## Inconformidades consolidadas (causa raiz, impacto, proposta)
1. **PK detectada por substring (`typeorm-entity-generator`)**
   - Causa raiz: regra simplificada `columnName.includes("id")`.
   - Impacto: geração incorreta de `@PrimaryColumn`, quebrando modelo e persistência.
   - Proposta de correção futura: usar metadado explícito de PK no schema lido pelo `DbReader`.

2. **Detecção de UUID inconsistente (`dto-generator`)**
   - Causa raiz: `mapType("uuid") -> "string"`, enquanto decorador UUID depende de ramo `mappedType === "UUID"`.
   - Impacto: perda de validação específica para UUID.
   - Proposta de correção futura: validar por `column.dataType` (ou retornar tipo lógico separado para regras de validação).

3. **Scripts potencialmente destrutivos no `package.json` gerado**
   - Causa raiz: comandos de `start:dev`/`test` com remoção de `node_modules` e reinstalação.
   - Impacto: instabilidade operacional, lentidão e comportamento inesperado em CI/dev.
   - Proposta de correção futura: separar scripts de limpeza e manter execução padrão sem reinstall forçado.

4. **Bloqueio de validação automática por ambiente**
   - Causa raiz: acesso negado ao pacote `mssql` no registry (`403`) e ausência de tipos Node no build atual.
   - Impacto: matriz mínima não pôde ser fechada com prova de compilação fim a fim.
   - Proposta de correção futura: liberar acesso ao registry e reexecutar ciclo automático completo.

## Matriz mínima de cenários (status)
- Tabela simples sem relacionamentos — **Cobertura parcial (análise estática)**.
- Múltiplas relações/chaves compostas — **Cobertura parcial (análise estática)**.
- Nullable/enum/decimal/datas/UUID — **Cobertura parcial (análise estática)**.
- Nomes limítrofes (`tb_`, snake_case, reservados) — **Cobertura parcial (análise estática)**.

Motivo da parcialidade: execução automática bloqueada por dependências indisponíveis no ambiente atual.

## Decisão final do EPIC
- **Status geral**: **Concluído com ressalvas (não apto para aprovação plena de produção)**.
- **Decisão técnica**: manter geradores com classificação consolidada acima e priorizar correção das inconformidades críticas antes de nova rodada E2E.
- **Critério de pronto**:
  - SUBs registradas e vinculadas: **Atendido**.
  - Sequência técnica respeitada: **Atendido**.
  - Cobertura integral do plano: **Atendido com ressalva** (automação bloqueada no ambiente).
  - Evidências auditáveis: **Atendido**.
  - Pronto integral: **Não atendido** (pendente revalidação automática em ambiente com dependências).


## Esclarecimento sobre ausência de alteração em código-fonte
- Esta execução atendeu estritamente ao escopo definido no EPIC e nas SUBs: **revisar, classificar e registrar evidências**, sem implementar correções.
- A seção "Não entra" do EPIC e das SUBs proíbe alteração de implementação dos geradores nesta entrega.
- Por isso, os ajustes foram limitados a artefatos de execução/auditoria (`docs/issues` e `CHANGELOG`), preservando conformidade de escopo.
- Caso seja aprovado um ciclo de correções, a próxima entrega deve abrir SUB(s) específica(s) para alterar os arquivos `src/*.ts` com revalidação automática posterior.

## Comandos executados e resultado
- `list_mcp_resources` → sem recursos MCP.
- `npm run build` → falha (`TS2688: Cannot find type definition file for 'node'`).
- `npm install` → falha (`403 Forbidden` em `registry.npmjs.org/mssql`).


## Atualização pós-correções consecutivas dos geradores

### Correções já aplicadas após a consolidação inicial
- `src/controller-generator.ts`: normalização de `camelCase` com inicial minúscula.
- `src/dto-generator.ts`: emissão de `@IsUUID()` por `column.dataType === 'uuid'` e remoção de parâmetro não utilizado.
- `src/typeorm-entity-generator.ts`: detecção de PK por `isPrimaryKey` e montagem segura de decorators (`@Column`, `@PrimaryColumn`, `@ApiProperty`) sem vírgula sobrando.
- `src/package-json-generator.ts`: scripts gerados `start:dev` e `test` sem remoção/reinstalação forçada de `node_modules`.
- `src/main.ts`: execução sequencial de componentes e remoção de operações forçadas (`npm install`, `prettier`, limpeza de `node_modules`).
- `src/env-generator.ts`, `src/package-json-generator.ts`, `src/main-generator.ts`: construtores sem `schemaPath` redundante.
- `src/interface-generator.ts` e `src/readme-generator.ts`: ampliação de mapeamento de tipos e ajuste textual de descrição de tabela.
- `src/module-generator.ts` e `src/service-generator.ts`: remoção de código/parâmetros não utilizados.

### Reclassificação técnica consolidada (estado atual)
- `src/env-generator.ts` — **Aprovado com ressalvas**.
- `src/package-json-generator.ts` — **Aprovado com ressalvas**.
- `src/diagram-generator.ts` — **Aprovado com ressalvas**.
- `src/interface-generator.ts` — **Aprovado com ressalvas**.
- `src/controller-generator.ts` — **Aprovado com ressalvas**.
- `src/module-generator.ts` — **Aprovado com ressalvas**.
- `src/main-generator.ts` — **Aprovado com ressalvas**.
- `src/app-module-generator.ts` — **Aprovado**.
- `src/readme-generator.ts` — **Aprovado com ressalvas**.
- `src/datasource-generator.ts` — **Aprovado com ressalvas**.
- `src/dto-generator.ts` — **Aprovado com ressalvas**.
- `src/service-generator.ts` — **Aprovado com ressalvas**.
- `src/typeorm-entity-generator.ts` — **Aprovado com ressalvas**.

### Status de conformidade do plano
- Cobertura de revisão e correções pontuais dos geradores: **Atendida**.
- Conformidade plena com validação automática fim a fim: **Pendente de ambiente** (build ainda bloqueado por `TS2688` no ambiente atual).
