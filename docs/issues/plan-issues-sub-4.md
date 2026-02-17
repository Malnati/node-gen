<!-- docs/issues/plan-issues-sub-4.md -->

# [SUB] 4 Executar análises transversais, matriz de cenários e fechamento de revisão

## Contexto
- Origem no plano: seção “Análises transversais obrigatórias (stack completo)”, plano de auditoria e critério de pronto.
- Motivação: consolidar validação fim a fim após revisão individual dos geradores.

- Execução prevista para agentes CLI multi-LLM com rastreabilidade em arquivos Markdown no repositório.

## Objetivo
Executar a validação transversal completa do pipeline (entrada, templates, naming, orquestração e qualidade do output), incluindo a matriz mínima de cenários críticos.

## Escopo
### Entra
- Revisão transversal de:
  - Entrada e leitura de schema (`DbReader*` e serialização intermediária).
  - Motor de templates (`template-loader`, `TemplateEngine`, `templates/*.ts`, `templates/service.ejs`).
  - Padrões de nomeação/paths (`toPascalCase`, `toKebabCase`, `toSnakeCase`, `removeTbPrefix`).
  - Orquestração em `src/main.ts`.
  - Qualidade do output (build/lint/start quando aplicável).
  - Matriz mínima de cenários do plano.

### Não entra
- Alterações de implementação para corrigir falhas detectadas.
- Inclusão de cenários além da matriz mínima definida no plano.

## Tarefas técnicas
- [ ] Executar checklist de auditoria manual de cobertura do plano.
- [ ] Executar validações automáticas recomendadas (`npm run build` no gerador e validações do output gerado).
- [ ] Rodar matriz mínima de cenários (simples, múltiplas relações/chaves compostas, nullable/enum/decimal/datas/UUID, nomes limítrofes).
- [ ] Consolidar status final dos 13 geradores e das análises transversais.
- [ ] Publicar fechamento com inconformidades, impacto e proposta de correção futura.

## Critérios de aceite
- [ ] Todas as análises transversais do plano executadas com evidências.
- [ ] Matriz mínima de cenários executada e documentada.
- [ ] Critério de pronto do plano atendido integralmente.
- [ ] Consolidação final apta para auditoria técnica.

## Riscos e dependências
- Dependência: conclusão de `[SUB] 3`.
- Risco: indisponibilidade de ambiente/DB para alguns cenários pode exigir registro explícito de limitação objetiva.

## Evidências esperadas
- Relatório de execução de auditoria manual + automática.
- Registro de comandos e resultados por cenário.
- Consolidação final com classificação dos geradores e decisão de prontidão.

## Definição de pronto
- [ ] Seção transversal do plano coberta integralmente.
- [ ] Matriz mínima de cenários validada.
- [ ] Status final dos geradores consolidado.
- [ ] Fechamento do EPIC suportado por evidências objetivas.
