---
name: Análise de hardcode
about: Avaliar inconformidades de hardcode a partir de um relatório JSON já gerado.
title: Avalise de inconformidades de hardcode
labels: ''
assignees: ''

---

Você é um analista técnico e deve avaliar inconformidades de hardcode a partir de um relatório JSON já gerado.

## Contexto
- HARDCODE_REPORT_PATH: XXXXXXXXXX
- O relatório foi gerado por automação com regex e está em: `{{HARDCODE_REPORT_PATH}}`.
- Objetivo: produzir análise acionável com priorização, plano em fases e templates de issues para execução.

## Tarefas obrigatórias
1. Ler e analisar o arquivo `{{HARDCODE_REPORT_PATH}}`.
2. Classificar achados por severidade e por tipo (ex.: auto-gerado, teste, código-fonte, técnico aceitável).
3. Identificar o que deve ser corrigido agora vs. o que pode ser aceito/documentado.
4. Propor plano de execução em fases (mínimo: Fase 1 crítica, Fase 2 importante, Fase 3 documentação).
5. Gerar os arquivos abaixo com conteúdo completo e consistente entre si.

## Arquivos de saída obrigatórios
- `docs/hardcode/hardcode-analysis-summary.md`
- `docs/hardcode/hardcode-analysis-visual.md`
- `docs/hardcode/hardcode-issues-guide.md`
- `docs/issues/hardcode-phase1-white-label.md`
- `docs/issues/hardcode-phase2-oauth.md`
- `docs/issues/hardcode-phase3-documentation.md`
- `CHANGELOG/<timestamp>-hardcode-analysis.md`

## Requisitos de conteúdo
### 1) `docs/hardcode/hardcode-analysis-summary.md`
- Resumo executivo com totais e percentuais.
- Separação clara entre ignoráveis, aceitáveis e itens que exigem ação.
- Destaque do problema mais crítico e impacto.
- Próximos passos objetivos.

### 2) `docs/hardcode/hardcode-analysis-visual.md`
- Visão visual em ASCII (barras/tabelas) com distribuição dos achados.
- Priorização por categoria com justificativa de sprint/fase.
- Mapa de categorias de hardcode com exemplos de arquivos.

### 3) `docs/hardcode/hardcode-issues-guide.md`
- Guia para criar as issues.
- Comandos `gh issue create` prontos para cada fase.
- Labels sugeridas e ordem de implementação.
- Checklist final de criação/publicação das issues.

### 4) `docs/issues/hardcode-phase1-white-label.md`
- Issue crítica com contexto, objetivo, tarefas detalhadas, critérios de aceite, riscos e estimativa.
- Foco em remover hardcode de branding e tornar white-label configurável.

### 5) `docs/issues/hardcode-phase2-oauth.md`
- Issue importante com foco em configuração OAuth obrigatória e validações.
- Critérios de aceite com comportamento esperado em ambiente sem configuração.

### 6) `docs/issues/hardcode-phase3-documentation.md`
- Issue de documentação para registrar hardcodes técnicos aceitáveis.
- Atualização de README com guia de configuração, exemplos e troubleshooting.

### 7) `CHANGELOG/<timestamp>-hardcode-analysis.md`
- Registrar: arquivo analisado, metodologia, categorias, recomendações, evidências e próximos passos.
- Incluir referências cruzadas para todos os arquivos gerados.

## Regras de execução
- Não inventar dados: derive métricas e exemplos do JSON analisado.
- Não expandir escopo além da análise de hardcode e plano de correção.
- Manter linguagem objetiva, auditável e orientada à execução.
- Se houver grande volume de falso positivo (ex.: lock files), evidenciar explicitamente.
- Diferenciar hardcode técnico aceitável de hardcode de negócio indevido.

## Formato de resposta esperado
- Entregar lista dos arquivos criados/atualizados.
- Entregar comandos executados.
- Entregar resumo de validação (passou/falhou) com motivo objetivo.
- Confirmar "definição de pronto" item a item:
  - [ ] análise concluída
  - [ ] priorização definida
  - [ ] plano em fases gerado
  - [ ] issues por fase criadas
  - [ ] changelog criado
