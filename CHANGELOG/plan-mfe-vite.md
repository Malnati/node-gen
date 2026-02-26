<!-- CHANGELOG/plan-mfe-vite.md -->
# Plano de Prompt — MFE com Vite + Single-spa (Opções 4, 5 e 6)

## 1) Arquivos existentes relevantes para o escopo
- `gen/src/main.ts` — habilita componentes `mfes` e `app-shell` no fluxo do gerador.
- `gen/src/microfrontend-generator.ts` — geração de MFEs por tabela, assets frontend e teste e2e de MFE.
- `gen/src/appshell-generator.ts` — geração do App Shell e import map.
- `gen/templates/mfe-vite-config.ejs` — template de configuração Vite para MFE.
- `gen/templates/mfe-app.ejs` — template de App React do MFE.
- `gen/templates/mfe-list-page.ejs` — template de listagem por recurso.
- `gen/templates/mfe-details-page.ejs` — template de detalhes/edição por recurso.
- `gen/templates/app-shell-root-config.ejs` — template do root config do Single-spa.
- `gen/templates/app-shell-import-map.ejs` — template do import map do App Shell.
- `gen/templates/app-shell-app.ejs` — template de rotas do App Shell.
- `gen/templates/app-shell-index-html.ejs` — HTML do App Shell com import map.
- `gen/templates/mfe-test-playwright.ejs` — template de teste E2E gerado para MFE.
- `gen/static-mfe/src/api/client.ts` — client HTTP base com placeholders para endpoint.
- `gen/static-mfe/vite.config.ts` — base Vite do MFE com plugin `vite-plugin-single-spa`.
- `gen/static-mfe/app-shell/package.json` e `gen/static-mfe/app-shell/vite.config.ts` — base do App Shell.
- `test/e2e-generator/e2e.js` — orquestração e2e atual do node-gen.
- `test/e2e-generator/e2e.json` — matriz atual de componentes (sem `mfes,app-shell` no padrão).
- `test/e2e-generator/README.md` — documentação operacional dos fluxos e2e existentes.
- `CHANGELOG/plan-mfes.md` — referência histórica de planejamento de micro front-ends.

## 2) Arquivos que serão alterados
- `CHANGELOG/plan-mfe-vite.md` (este arquivo de planejamento/prompt).

## 3) Requisitos combinados (mudança específica + requisitos globais)
- Elaborar um **prompt/plano altamente detalhado** para conduzir a implementação da trilha Vite + Single-spa.
- Cobrir explicitamente os objetivos solicitados:
  1. **Opção 4:** adotar Vite como caminho e detalhar o que falta para gerar MFEs + Single-spa de forma operacional real.
  2. **Opção 5:** preparar geração de **1 MFE por endpoint** (não apenas por tabela).
  3. **Opção 6:** preparar execução de container com Single-spa + Vite e fluxo E2E automatizado ponta-a-ponta.
- Seguir padrão de planos anteriores do repositório, com linguagem objetiva, rastreável e acionável.
- Incluir engenharia de prompt atualizada:
  - contexto e objetivo claro;
  - critérios de aceite verificáveis;
  - limites de escopo;
  - passos executáveis;
  - evidências obrigatórias;
  - checklist final.
- Preservar conformidade com governança baseada em `CHANGELOG/*` para rastreabilidade.

## 4) Requisitos não atendidos atualmente que o plano busca resolver
- Não há plano único consolidando Opções 4, 5 e 6 em uma sequência de execução com critérios de pronto verificáveis.
- O fluxo atual de e2e não valida por padrão a trilha `mfes + app-shell` no escopo principal.
- A geração atual é orientada ao schema/tabela; falta especificação de transição para granularidade por endpoint.
- Ausência de plano formal de containerização e orquestração operacional para App Shell + MFEs com Vite/Single-spa.

## 5) Regras combinadas (mudança específica + regras globais)
- Não expandir escopo além do plano/prompt solicitado.
- Não propor múltiplas soluções desconexas; entregar sequência direta de implementação.
- Não introduzir dependências, pipelines ou refactors amplos sem justificativa e critério objetivo.
- Garantir que todo passo tenha validação objetiva (comando, saída esperada, artefato, status).
- Especificar cadeia de configuração para frontend/containers (`.env -> compose -> app`) ao descrever execução.
- Exigir evidências no PR final da implementação derivada deste plano:
  - lista de arquivos alterados;
  - lista de comandos executados;
  - resultado passou/falhou por comando;
  - definição de pronto item a item.

## 6) Regras não atendidas que motivam os ajustes
- Falta de definição formal para converter geração por tabela em geração por endpoint.
- Falta de plano auditável para “subir container + executar E2E integrado” de shell + MFEs.
- Falta de critérios explícitos de completude para declarar o caminho Vite/Single-spa pronto para uso real.

## 7) Plano de auditoria (manual + automático)
- **Auditoria de arquitetura/geração**
  - Validar, por inspeção e testes, que o gerador produz:
    - App Shell funcional;
    - MFEs independentes por endpoint definido;
    - import map consistente com os artefatos gerados.
- **Auditoria de build/runtime frontend**
  - Build de App Shell e de cada MFE com Vite.
  - Verificação de resolução de módulos no Single-spa e carregamento por rota.
- **Auditoria de integração API**
  - Confirmar que cada MFE usa endpoint correto via configuração de ambiente.
  - Validar GET/list, GET/id, POST, PUT/PATCH e DELETE quando aplicável.
- **Auditoria de containerização**
  - Validar docker compose para subir shell + MFEs + API (ou mock API) em rede comum.
  - Verificar health checks e logs mínimos para diagnóstico.
- **Auditoria E2E**
  - Executar E2E de jornada real: shell sobe -> rota ativa MFE -> chamadas API -> asserts visuais/funcionais.
  - Coletar evidência de execução (exit code, logs e artefatos de teste).
- **Auditoria de regressão do gerador**
  - Confirmar que geração backend existente permanece íntegra.

## 8) Seleção de checklists aplicáveis
- **Obrigatórios independentemente do tema**
  - Checklist de governança/rastreabilidade em `CHANGELOG/*`.
  - Checklist de validação de comandos executados + resultados.
  - Checklist de definição de pronto com critérios mensuráveis.
- **Aplicáveis ao contexto MFE + Orquestração**
  - Checklist de geração de artefatos por endpoint.
  - Checklist de Vite + Single-spa (build/dev/prod).
  - Checklist de import map e roteamento do App Shell.
  - Checklist de configuração por ambiente (`.env`, compose, runtime).
  - Checklist de E2E ponta-a-ponta em container.

---

# Prompt recomendado (engenharia de prompts atualizada)

## Papel do executor
Você é um engenheiro sênior responsável por concluir a evolução do `node-gen` para suportar Micro Frontends com **Vite + Single-spa** em nível de produção, com rastreabilidade completa em `CHANGELOG/*`.

## Objetivo principal
Implementar as três frentes abaixo de forma sequencial e auditável:
1. **Opção 4:** consolidar Vite como caminho oficial para MFEs + App Shell em Single-spa, fechando lacunas para operação real.
2. **Opção 5:** migrar a estratégia de geração para **1 micro-frontend por endpoint**.
3. **Opção 6:** habilitar execução containerizada (Single-spa + Vite + MFEs + API) com E2E ponta-a-ponta automatizado.

## Escopo estrito
- Alterar somente arquivos necessários para atingir os critérios de aceite.
- Não adicionar melhorias estéticas, refactors amplos ou mudanças arquiteturais não exigidas pelos objetivos.
- Toda decisão técnica deve ser registrada com justificativa objetiva.

## Entregáveis obrigatórios
1. Geração de MFEs e App Shell funcional com Vite + Single-spa.
2. Mapeamento e geração por endpoint, com convenção explícita de nome/rota.
3. Stack containerizada para execução integrada.
4. E2E automatizado cobrindo jornada completa do orquestrador aos endpoints.
5. Evidências no changelog com comandos, saídas e status.

## Critérios de aceite (Definition of Done)
- [ ] Gerador produz App Shell e MFEs sem erros de build.
- [ ] Cada endpoint mapeado gera um MFE correspondente com rota e client API corretos.
- [ ] App Shell resolve import map e ativa MFEs por rota.
- [ ] Stack sobe via container com configuração por variáveis de ambiente.
- [ ] E2E executa cenário completo (shell -> navegação -> API -> assert) com resultado reproduzível.
- [ ] Documentação operacional mínima atualizada para executar localmente e em CI.
- [ ] Changelog final contém arquivos alterados, comandos, resultados e pendências (se houver).

## Plano de execução sugerido (fases)
1. **Fase A — Baseline Vite + Single-spa (Opção 4)**
   - Corrigir geração/template e garantir build/run do frontend gerado.
   - Padronizar configuração de endpoints e import map.
2. **Fase B — Geração por endpoint (Opção 5)**
   - Definir origem da lista de endpoints (contrato) e regra de geração 1:1.
   - Ajustar naming, rotas, páginas e client API para granularidade endpoint.
3. **Fase C — Container + E2E ponta-a-ponta (Opção 6)**
   - Subir shell+MFEs+API em compose.
   - Implementar/ajustar E2E para validar fluxo completo.
4. **Fase D — Auditoria e fechamento**
   - Rodar checklist final, registrar evidências e encerrar ciclo no changelog.

## Matriz de verificação mínima
- Build: App Shell + todos MFEs gerados.
- Runtime: navegação por rota do shell para cada MFE.
- API: chamadas CRUD básicas por endpoint.
- E2E: teste automatizado sem intervenção manual.
- Operação: execução containerizada documentada.

## Formato de evidência exigido
- Arquivos alterados.
- Comandos executados.
- Resultado de cada comando (`passou`, `falhou`, `warning` + motivo).
- Cobertura dos critérios de aceite item a item.
- Riscos e pendências remanescentes.

## Restrições críticas
- Não expor segredos.
- Não quebrar fluxo atual do gerador backend.
- Não alterar escopo além das Opções 4, 5 e 6.

## Instrução final ao executor
Execute exatamente o plano acima, fase por fase, registrando rastreabilidade em `CHANGELOG/*` e só conclua quando todos os critérios de aceite estiverem comprovados com evidências objetivas.
