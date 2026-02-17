---
name: Análise do SonarQ
about: Avaliar inconformidades detectadas pelo SonarQ a partir dos arquivos já gerados
  no projeto.
title: Inconformidades detectadas pelo SonarQ
labels: "\U0001F916 copilot, \U0001F4C4 documentation, \U0001F50E review"
assignees: ''

---

Você é um analista técnico e deve avaliar inconformidades detectadas pelo SonarQ a partir dos arquivos já gerados no projeto.

## Contexto
- Os arquivos do SonarQ estão em: `{{SONARQ_REPORT_GLOB}}`.
- Objetivo: transformar os achados em análise acionável, priorização e templates de issues por fase.

## Tarefas obrigatórias
1. Ler todos os arquivos de `{{SONARQ_REPORT_GLOB}}`.
2. Consolidar métricas e achados por severidade/tipo (bugs, vulnerabilities, code smells, hotspots, debt, duplicação, cobertura quando existir).
3. Separar itens críticos para correção imediata de itens aceitáveis/planejáveis.
4. Propor plano de execução em fases (mínimo: Fase 1 crítica, Fase 2 importante, Fase 3 documentação/governança).
5. Gerar os arquivos abaixo com conteúdo consistente entre si.

## Arquivos de saída obrigatórios
- `docs/sonarq/sonarq-analysis-summary.md`
- `docs/sonarq/sonarq-analysis-visual.md`
- `docs/sonarq/sonarq-issues-guide.md`
- `docs/issues/sonarq-phase1-critical.md`
- `docs/issues/sonarq-phase2-important.md`
- `docs/issues/sonarq-phase3-documentation.md`
- `CHANGELOG/<timestamp>-sonarq-analysis.md`

## Requisitos de conteúdo
### 1) `docs/sonarq/sonarq-analysis-summary.md`
- Resumo executivo com totais, severidades e impacto.
- Principais módulos/arquivos com maior concentração de problemas.
- Itens bloqueantes para produção.
- Próximos passos objetivos.

### 2) `docs/sonarq/sonarq-analysis-visual.md`
- Visualização em ASCII (tabelas/barras) para severidade e categorias.
- Ranking de riscos por tipo e por área afetada.
- Priorização por sprint/fase com justificativa.

### 3) `docs/sonarq/sonarq-issues-guide.md`
- Guia para criação das issues.
- Comandos `gh issue create` para cada fase.
- Labels sugeridas (prioridade, tipo, fase, esforço).
- Checklist final para publicação e rastreabilidade.

### 4) `docs/issues/sonarq-phase1-critical.md`
- Issue para correções críticas (ex.: blocker/critical e security high).
- Contexto, objetivo, tarefas, critérios de aceite, riscos e estimativa.

### 5) `docs/issues/sonarq-phase2-important.md`
- Issue para melhorias importantes (major/medium).
- Critérios de aceite com redução objetiva dos alertas.

### 6) `docs/issues/sonarq-phase3-documentation.md`
- Issue para documentação, padronização e governança dos alertas restantes.
- Plano para evitar regressão (checklists, revisão, métricas mínimas).

### 7) `CHANGELOG/<timestamp>-sonarq-analysis.md`
- Registrar: arquivos analisados, metodologia, evidências, recomendações e próximos passos.
- Incluir referências cruzadas para todos os artefatos gerados.

## Regras de execução
- Não inventar dados: usar somente evidências dos arquivos em `{{SONARQ_REPORT_GLOB}}`.
- Não expandir escopo além da análise SonarQ e plano de correção.
- Manter linguagem auditável e orientada à execução.
- Destacar explicitamente falso positivo e justificativas técnicas quando houver.
- Diferenciar débito técnico aceitável de não conformidade bloqueante.

## Formato de resposta esperado
- Listar arquivos criados/atualizados.
- Listar comandos executados.
- Resumo de validação (passou/falhou) com motivo objetivo.
- Confirmar "definição de pronto" item a item:
  - [ ] análise concluída
  - [ ] priorização definida
  - [ ] plano em fases gerado
  - [ ] issues por fase criadas
  - [ ] changelog criado
