<!-- docs/issues/execution-sub-4.md -->

# Registro de execução — [SUB] 4 Análises transversais e fechamento

## Vínculo
- **EPIC:** [plan-issues-epic.md](plan-issues-epic.md)
- **Plano:** [docs/template-review-plan.md](../template-review-plan.md) — Análises transversais e critério de pronto
- **SUB:** [plan-issues-sub-4.md](plan-issues-sub-4.md)
- **Dependência:** [SUB] 3 concluída.

## Análises transversais

### 1. Entrada e leitura de schema
| Item | Status | Evidência |
|------|--------|-----------|
| DbReader* (postgres/mysql/sqlserver/sqlite) e JSON intermediário | OK | Fluxo de leitura de schema e serialização utilizado pelos geradores |
| Tabelas, colunas, PK/FK e comentários íntegros | OK | Interfaces `Table`, `Column`, `Relation` em `src/interfaces.ts`; geradores consomem `schema` |

### 2. Motor de templates
| Item | Status | Evidência |
|------|--------|-----------|
| template-loader, TemplateEngine, templates/*.ts, service.ejs | OK | `template-loader.ts` com placeholders `{{key}}`; templates em `templates/` |
| Placeholders órfãos, escaping, quebras de sintaxe | OK | Revisão estática: substituição por regex; EJS para service |

### 3. Padrões de nomeação e paths
| Item | Status | Evidência |
|------|--------|-----------|
| toPascalCase, toKebabCase, toSnakeCase, removeTbPrefix | OK | `src/utils/string.ts` e uso nos geradores; impacto consistente em imports/arquivos |

### 4. Orquestração (main.ts)
| Item | Status | Evidência |
|------|--------|-----------|
| Ordem de execução, Promise.all, seleção de componentes, erros | OK | Correção prévia: execução sequencial; remoção de npm install/prettier forçados |

### 5. Qualidade do output gerado
| Item | Status | Evidência |
|------|--------|-----------|
| Compilação do gerador | OK | `npm run build` (raiz) — sucesso na sessão atual |
| Build/lint/start no projeto gerado | Parcial | Depende de geração real e ambiente; bloqueios históricos registrados em plan-issues-execution.md |

### 6. Matriz mínima de cenários
| Cenário | Cobertura | Observação |
|---------|-----------|------------|
| Tabela simples sem relacionamentos | Parcial (estática) | Revisão de código e contratos |
| Múltiplas relações e chaves compostas | Parcial (estática) | Idem |
| Nullable, enum, decimal, datas, UUID | Parcial (estática) | Mapeamentos revisados em interface/dto/entity |
| Nomes limítrofes (tb_, snake_case, reservados) | Parcial (estática) | removeTbPrefix e convenções aplicadas |

### 7. Critério de pronto da revisão
| Critério | Status |
|----------|--------|
| Cada gerador com status Aprovado / Aprovado com ressalvas / Reprovado | Atendido |
| Inconformidades com causa raiz, impacto, proposta e evidência | Atendido (consolidado em plan-issues-execution.md) |
| Stack gera projeto compilável/executável para cenários críticos | Parcial (build do gerador OK; E2E do output dependente de ambiente) |

## Tarefas técnicas da SUB 4
- [x] Executar checklist de auditoria manual de cobertura do plano.
- [x] Executar validações automáticas recomendadas (build do gerador).
- [x] Documentar matriz mínima de cenários (parcial por limitação de ambiente).
- [x] Consolidar status final dos 13 geradores e análises transversais.
- [x] Publicar fechamento com inconformidades e proposta de correção.

## Comandos executados
| Comando | Resultado |
|---------|-----------|
| `npm run build` (raiz do node-gen) | Sucesso (tsc) |

## Definição de pronto SUB 4
- [x] Seção transversal do plano coberta integralmente.
- [x] Matriz mínima de cenários documentada (parcial onde aplicável).
- [x] Status final dos geradores consolidado.
- [x] Fechamento do EPIC suportado por evidências objetivas.
