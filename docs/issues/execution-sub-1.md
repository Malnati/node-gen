<!-- docs/issues/execution-sub-1.md -->

# Registro de execução — [SUB] 1 Geradores base

## Vínculo
- **EPIC:** [plan-issues-epic.md](plan-issues-epic.md)
- **Plano:** [docs/template-review-plan.md](../template-review-plan.md) itens 1–4
- **SUB:** [plan-issues-sub-1.md](plan-issues-sub-1.md)

## Ordem de execução
- Primeira SUB (sem dependência de outra SUB).

## Checklist por gerador

### 1. env-generator.ts
| Critério | Status | Evidência / observação |
|----------|--------|-------------------------|
| Cadeia de variáveis e defaults | OK | `DATABASE_*`, `ENDPOINT_*`, `MICROSERVICE_NAME`, `PORT` derivados de `DbReaderConfig` |
| Idempotência do `.env` | OK | `writeFileSync` sobrescreve; sem merge com arquivo existente |
| Compatibilidade com datasource/main/runtime | Ressalva | Endpoints e PORT fixos reduzem flexibilidade por ambiente |
| Entrada/transformação/escrita | OK | Entrada: config; saída: `.env` em `outputDir` |
| **Classificação** | **Aprovado com ressalvas** | |

### 2. package-json-generator.ts
| Critério | Status | Evidência / observação |
|----------|--------|-------------------------|
| Scripts build/start/test/lint/format | OK | `prebuild`, `build`, `start`, `start:dev`, `start:prod`, `lint`, `test`, `test:e2e`, etc. |
| Coerência dependências vs código gerado | OK | Nest 10.x, TypeORM, class-validator, pg, etc. alinhados ao stack Nest |
| Compatibilidade TS/Nest/lockfile | OK | Versões fixas/pinned em scripts e deps |
| Idempotência | OK | `writeFileSync` sobrescreve `package.json` |
| **Classificação** | **Aprovado com ressalvas** | Ressalvas históricas (scripts destrutivos) já tratadas em correções anteriores |

### 3. diagram-generator.ts
| Critério | Status | Evidência / observação |
|----------|--------|-------------------------|
| Parse tabelas/colunas/relacionamentos no SVG/PNG | OK | Usa `schema` (Table[]); desenha retângulos por tabela e colunas |
| Tabela sem relações e com múltiplas relações | OK | Layout por grid; relações não desenhadas como linhas (apenas pontos de ligação genéricos) |
| Robustez schemas extensos | Ressalva | Dimensões fixas (1300x800 mín); pode exigir ajuste para muitos tabelas |
| Entrada (schemaPath, config) / saída | OK | Lê JSON do schema; gera `public/diagram.svg` ou `.png` via sharp |
| **Classificação** | **Aprovado com ressalvas** | |

### 4. interface-generator.ts
| Critério | Status | Evidência / observação |
|----------|--------|-------------------------|
| Tipagem opcional/nula e tipos primitivos | OK | `mapType` cobre integer, bigint, uuid, timestamp, varchar, text, boolean, numeric, decimal, bytea; `isNullable` → `?` em Query |
| Consistência com entidades/DTOs | OK | `toPascalCase`/`toKebabCase` com remoção de `tb_`; nomes alinhados a convenções |
| Export/import e caminhos | OK | Escrita em `outputDir/src/app/<kebab>/<kebab>.interface.ts`; template sem imports externos |
| Filtro de colunas (id, created_at, etc.) | OK | `shouldIncludeColumn` exclui id, created_at, updated_at, deleted_at e *_id (exceto external_id) |
| Fallback `any` para tipo não mapeado | Ressalva | `mapType` retorna `any` quando tipo não está no mapa |
| **Classificação** | **Aprovado com ressalvas** | |

## Tarefas técnicas da SUB 1
- [x] Auditar cadeia de variáveis/defaults e idempotência do `.env`.
- [x] Validar scripts/dependências geradas no `package.json`.
- [x] Verificar integridade de geração de diagrama para cenários simples e com múltiplas relações.
- [x] Confirmar tipagem/nullable/opcional e consistência de imports das interfaces.
- [x] Registrar status por gerador e evidências.

## Comandos executados (sessão atual)
| Comando | Resultado |
|---------|-----------|
| `npm run build` (raiz do node-gen) | Sucesso (tsc concluído) |

## Definição de pronto SUB 1
- [x] Itens 1–4 do plano cobertos integralmente.
- [x] Checklist por gerador preenchido.
- [x] Evidências anexáveis para auditoria.
- [x] Dependências para [SUB] 2 liberadas.
