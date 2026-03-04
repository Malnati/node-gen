<!-- AGENTS.md -->

# AGENTS.md

# Propósito
Este arquivo define o comportamento obrigatório de agentes (Copilot coding agent e equivalentes) ao modificar este repositório.

# Prioridade de instruções
1. Issue (requisitos e critérios)
2. Instruções do repositório (.github/copilot-instructions.md)
3. Instruções por caminho (.github/instructions/*.instructions.md)
4. AGENTS.md (este arquivo)

# Comportamento obrigatório
- Implementar exatamente o que a issue pede, sem expandir escopo.
- Alterar apenas arquivos necessários para cumprir critérios objetivos.
- Não adicionar dependências, jobs, serviços, pipelines ou refactors abrangentes sem exigência explícita.
- Não incluir conteúdo de IDE, workspace, "spaces environment" ou guias de ferramenta.

# Evidências obrigatórias no PR
- Arquivos alterados (lista)
- Comandos executados (lista)
- Resultado resumido (passou/falhou) com motivo objetivo se falhar
- "Definição de pronto" atendida, item a item, conforme a issue

# Proibição explícita
- Não incluir chaves, tokens, segredos, dumps de ambientes.
- Não "melhorar" arquitetura por iniciativa própria.
- Não entregar múltiplas soluções; entregar a solução direta.

---

# Contribuição assistida por IA

Estas instruções se aplicam a **todo o repositório** e devem ser seguidas por qualquer agente automatizado responsável por gerar código ou documentação.

## Estrutura de diretórios
- Preserve o layout atual de cada serviço. Serviços NestJS devem manter `src/app.controller.ts`, `src/app.service.ts`, `src/app.module.ts`, além de módulos em `src/modules`, tipos compartilhados em `src/types` e utilitários opcionais em `src/utils`.
- Novas capacidades NestJS devem ser criadas dentro de `src/modules`.
- Não adicione nem remova diretórios fora desses padrões sem atualização explícita da documentação arquitetural.
- O diretório `.ref/` contém apenas artefatos de referência copiados de outro projeto e deve ser utilizado exclusivamente como padrão comparativo, sem replicação direta para os subprojetos atuais.

## Política de CHANGELOGs obrigatórios
- Toda alteração de infraestrutura, código, SQL, documentação operacional ou planos deve gerar um arquivo em `CHANGELOG/` com nome `YYYYMMDDHHMMSS.md` (timestamp UTC).
- Cada arquivo de changelog deve iniciar com o comentário de caminho (`<!-- CHANGELOG/<arquivo>.md -->`) seguido de título com data/hora e seções listando arquivos modificados, regras/requisitos atendidos e pendências relevantes.
- Se uma entrega tocar vários domínios, registre todos na mesma entrada descrevendo claramente os impactos; não reutilize arquivos existentes nem agregue mudanças não relacionadas.
- O changelog precisa citar explicitamente novos planos, atualizações de políticas (como este `AGENTS.md`) e correções executadas, garantindo rastreabilidade pós-auditoria.
- Pull requests/commits sem novo changelog são proibidos, **exceto** em casos estritamente de bootstrap/consolidação de governança (por exemplo, criação ou reorganização inicial deste `AGENTS.md` sem impacto em workflows, infraestrutura ou código); nesses casos excepcionais, a justificativa detalhada deve constar na descrição do PR e neste arquivo, de forma a manter a rastreabilidade pós-auditoria mesmo sem novo arquivo em `CHANGELOG/`.

- Sempre que iniciar uma tarefa, confira os changelogs existentes para evitar duplicidades e registre, na nova entrada, referências cruzadas aos planos e políticas atualizados.
- Antes de criar o commit ou abrir o PR, execute `git status` e confirme que há exatamente um arquivo novo em `CHANGELOG/` com timestamp único relativo ao trabalho realizado; se não houver, interrompa a entrega e gere o changelog correspondente.
- Caso uma atividade seja estritamente investigativa e não altere arquivos versionados, ainda assim crie um changelog descrevendo o escopo auditado, os motivos da ausência de mudanças e quaisquer recomendações resultantes.
- Se durante o desenvolvimento detectar alterações anteriores sem changelog, abra correções dedicadas criando entradas retroativas com a justificativa da lacuna e cite-as no novo changelog para manter a trilha de auditoria completa.

### Documentos por fase (hierarquia conforme `docs/`)
- `docs/00-visao/`
  - `README.md` — apresenta o propósito da fase e os artefatos disponíveis.
  - `visao-do-produto.md`, `escopo.md`, `stakeholders.md`, `lgpd.md` — objetivos estratégicos, escopo e compliance.
- `docs/01-arquitetura/`
  - `README.md` — descreve a macroarquitetura e destaca os artefatos-chave.
  - `arquitetura-da-extensao.md`, `integracoes-com-apis.md`, `requisitos-nao-funcionais.md` — camadas, integrações e NFRs.
- `docs/02-design/`
  - `README.md` — introduz a fase de design detalhado e seus artefatos.
  - `design-geral.md`, `componentes.md`, `fluxos.md` — especificações para implementação e validação operacional.
- `docs/02-planejamento/`
  - `README.md` — mantém cronogramas, governança, milestones, riscos, roadmap e WBS.
  - Subdocumentos: `cronograma.md`, `governanca.md`, `milestones.md`, `riscos-e-mitigacoes.md`, `roadmap.md`, `wbs.md`.
- `docs/03-implementacao/`
  - `README.md` — orientações de estrutura, automação, padrões de código e testes.
  - Subdocumentos: `estrutura-de-projeto.md`, `build-e-automacao.md`, `padroes-de-codigo.md`, `testes.md`.
- `docs/04-testes-e-validacao/`
  - `README.md` — estratégia de QA, critérios, E2E e validação de marcos.
  - Subdocumentos: `estrategia-geral.md`, `criterios-de-aceitacao.md`, `testes-end-to-end.md`, `validacao-de-marcos.md`.
- `docs/05-entrega-e-implantacao/`
  - `README.md` — ambientes, empacotamento, versionamento e operação contínua.
  - Subdocumentos: `ambientes-e-configuracoes.md`, `empacotamento.md`, `publicacao-e-versionamento.md`, `operacao-e-manutencao.md`.
- `docs/06-governanca-tecnica-e-controle-de-qualidade/`
  - `README.md` — governança técnica, controle de qualidade, auditoria e revisões com IA.
  - Subdocumentos: `governanca-tecnica.md`, `controle-de-qualidade.md`, `auditoria-e-rastreabilidade.md`, `revisoes-com-ia.md`.
- `docs/06-ux-brand/`
  - `README.md` — diretrizes de UX, acessibilidade e identidade visual.
  - Subdocumentos: `diretrizes-de-ux.md`, `acessibilidade.md`, `identidades-visuais.md`.
- `docs/07-contribuicao/`
  - `README.md` — colaboração, commits e PRs.
  - Subdocumentos: `contribuindo.md`, `padroes-de-commit.md`, `template-de-pr.md`.
- `docs/99-anexos/`
  - `README.md` — glossário e referências de apoio.
  - Subdocumentos: `glossario.md`, `referencias.md`.

### Acervos históricos e validação
- `docs/03-agentes-ia/` — histórico de agentes, pipelines e políticas para auditoria de IA.
- `docs/04-qualidade-testes/` — documentação anterior de QA preservada para consulta.
- `docs/05-operacao-release/` — registros legados de ambientes, publicação e versionamento.
- `.ref/docs/wiki/validation-report.md` e `docs/validation-report.md` — certificação de atualização da wiki e rastreio de pendências.

### Onde registrar novos requisitos
- Utilize o índice para escolher o diretório correspondente na árvore `docs/`, referenciando quando houver.
- Requisitos não funcionais ou restrições técnicas devem ser mantidos em `docs/01-arquitetura/` e espelhados conforme `requisitos-nao-funcionais.md` legado.
- Especificações funcionais, fluxos e contratos devem ser registrados em `docs/02-design/`, alinhados aos artefatos correspondentes na wiki.
- Critérios e planos de teste derivados de novos requisitos precisam estar em `docs/04-testes-e-validacao/`, mantendo vínculo com os cenários históricos.
- Requisitos ligados a entrega, governança ou UX devem atualizar simultaneamente `docs/05-entrega-e-implantacao/`, `docs/06-governanca-tecnica-e-controle-de-qualidade/` e `docs/06-ux-brand/`, citando as seções legadas.

### Observações finais
- Nenhuma regra ou especificação deve ficar fora da árvore `docs/`. Utilize `.ref/docs/wiki/` apenas como fonte de verdade para restauração e comparação.
- Registre no changelog toda decisão que racionalize divergências entre legado e derivação, preservando âncoras cruzadas.
- Consulte os acervos históricos apenas quando necessário para contexto, priorizando sempre os artefatos vigentes em `docs/` para execução atual.


## 📘 requisitos — Panorama Geral
- A pasta `docs/` centraliza a documentação da solução e de todos os subprojetos. Consulte [`docs/README.md`](docs/README.md) para visão geral das fases, convenções e índice atualizado.
- Antes de iniciar qualquer implementação, localize o artefato correspondente na fase adequada e confirme se já existe instrução específica. Atualizações devem manter referência cruzada com o changelog e com `AGENTS.md`.
- Novos requisitos funcionais, técnicos ou de UX precisam ser registrados na docs respectiva. Utilize os READMEs das subpastas para identificar templates e estruturas esperadas.

## Convenções de configuração
- Todos os serviços devem possuir `Dockerfile`, `docker-compose.yml`, `docker-compose.dev.yml`, `Makefile`, `package.json`, `tsconfig.json`, `prometheus.yml` (quando aplicável) e `nest-cli.json` para aplicações NestJS. Garanta que novos arquivos respeitem essa convenção.
- Ao criar ou alterar targets em `Makefile`, reutilize os nomes existentes (`build`, `start`, `stop`, `dev`, `logs`, `clean`, `monitoring`, etc.) e mantenha o padrão de invocação (`docker build -t $(SERVICE_NAME):latest .`, `$(COMPOSE) logs -f $(SERVICE_NAME)`, `$(COMPOSE) down -v --rmi all --remove-orphans`).
- Cada `Makefile` deve expor alvos específicos por serviço declarado no `docker-compose.yml` correspondente. Para cada serviço definido, crie pelo menos `build-<serviço>`, `start-<serviço>`, `stop-<serviço>`, `logs-<serviço>` e `clean-<serviço>` reutilizando `$(COMPOSE) -f $(COMPOSE_FILE)` e garanta variantes adicionais (como `seed-<serviço>`) quando houver comandos globais dependentes de um serviço único.
- Configure variáveis de ambiente usando o formato `${VAR:-default}` nos arquivos de orquestração.
- Os arquivos `docker-compose*.yml` não devem declarar o atributo `version`, evitando avisos deprecatórios das versões recentes do Docker Compose.
- Cada stack Docker (Dockerfile, `docker-compose*.yml`, arquivos de configuração montados por volume e scripts de inicialização) deve ser totalmente parametrizada por variáveis de ambiente. Evite criar variantes duplicadas de arquivos quando placeholders podem ser substituídos durante o build ou start.
- Não mantenha arquivos auxiliares apenas para aplicar valores específicos de ambiente se a mesma finalidade puder ser atingida por substituição em tempo de execução. Prefira um único artefato com placeholders explícitos documentados.
- **Cadeia obrigatória de configuração:** qualquer valor de configuração (flags, parâmetros, argumentos, secrets ou chaves de integração) deve seguir `.env` → `docker-compose*.yml` → serviço/aplicação. Declare nos `.env`, propague nos manifests utilizando `${VAR:-default}` e consuma explicitamente no código ou scripts.
- Ao introduzir novas variáveis, atualize todos os arquivos `.env` e `docker-compose*.yml` impactados (incluindo variantes de desenvolvimento) para que a cadeia permaneça consistente.

### Requisitos gerais
- Cada subprojeto JavaScript ou TypeScript deve incluir `package.json`, TypeScript em modo `strict` e Vite como ferramenta padrão de bundling para interfaces web. Exceções precisam ser documentadas em [`docs/03-implementacao/estrutura-de-projeto.md`](docs/03-implementacao/estrutura-de-projeto.md).
- Todo subprojeto versionado deve possuir `.gitignore` próprio quando ainda não existir arquivo compartilhado que cubra seus artefatos gerados.
- Preserve os diretórios estruturais descritos na arquitetura vigente. Alterações estruturais demandam atualização prévia da req e registro em changelog.
- Valores de configuração devem seguir a cadeia `.env` → `docker-compose.yml` → serviço, conforme [`docs/05-entrega-e-implantacao/ambientes-e-configuracoes.md`](docs/05-entrega-e-implantacao/ambientes-e-configuracoes.md).

# AGENTS.md

## Propósito
Este arquivo define o comportamento obrigatório de agentes (Copilot coding agent e equivalentes) ao modificar este repositório, com foco exclusivo em governança baseada em ciclos e evidências registradas em arquivos CHANGELOG/*md.

## Prioridade de instruções
1. Issue (requisitos e critérios)
2. Instruções do repositório (.github/copilot-instructions.md)
3. Instruções por caminho (.github/instructions/*.instructions.md)
4. AGENTS.md (este arquivo)

## Comportamento obrigatório
- Implementar exatamente o que a issue ou plano aprovado pede, sem expandir escopo.
- Alterar apenas arquivos necessários para cumprir critérios objetivos.
- Não adicionar dependências, jobs, serviços, pipelines ou refactors abrangentes sem exigência explícita.
- Não incluir conteúdo de IDE, workspace, "spaces environment" ou guias de ferramenta.

## Evidências obrigatórias no PR
- Arquivos alterados (lista)
- Comandos executados (lista)
- Resultado resumido (passou/falhou) com motivo objetivo se falhar
- "Definição de pronto" atendida, item a item, conforme a issue ou plano

## Proibições explícitas
- Não incluir chaves, tokens, segredos, dumps de ambientes.
- Não "melhorar" arquitetura por iniciativa própria.
- Não entregar múltiplas soluções; entregar a solução direta.

---

## Governança e Ciclos de Entrega

Toda governança, planos, decisões e rastreabilidade devem ser registrados exclusivamente em arquivos CHANGELOG/*md, conforme os ciclos e padrões definidos em `opencode.json` e instruções do repositório.

- **Planos de mudança, decisões e auditorias**: Devem ser criados e versionados em arquivos CHANGELOG/ com timestamp único, seguindo o padrão `YYYYMMDDHHMMSS-nome.md`.
- **Cada ciclo de governança** (planejamento, execução, revisão, auditoria, conclusão) deve ser documentado em CHANGELOG/*md, referenciando comandos, arquivos e critérios atendidos.
- **Os ciclos de governança e padrões de entrega** estão definidos em `opencode.json` e `.github/copilot-instructions.md`. Sempre consulte estes arquivos para garantir conformidade.

### Ciclo de Governança Padrão
1. **Planejamento**: Definir escopo, arquivos, critérios e plano em CHANGELOG/*-plan.md
2. **Implementação**: Executar apenas o que está no plano aprovado
3. **Revisão**: Validar critérios, comandos e rastreabilidade em CHANGELOG/*md
4. **Auditoria**: Registrar evidências, decisões e pendências em CHANGELOG/*md
5. **Conclusão**: Encerrar ciclo com checklist e referência cruzada

**Exemplo de fluxo:**
- Criar/atualizar `CHANGELOG/20260206120000-nome-da-entrega-plan.md` com escopo, arquivos e critérios
- Implementar apenas arquivos listados no plano
- Registrar comandos e resultados em `CHANGELOG/20260206120000-nome-da-entrega.md`
- Validar e auditar conforme padrões de `opencode.json` e `.github/copilot-instructions.md`

---

## Estrutura de diretórios e arquivos
- Não criar nem referenciar diretórios ou arquivos fora dos padrões deste repositório.
- Não utilizar docs/, wiki,, docs/, req/ ou qualquer estrutura legada.
- Toda documentação de governança, plano, decisão, auditoria e rastreabilidade deve estar em CHANGELOG/*md.
- Arquivos de configuração e instruções vivem em `.github/` e `opencode.*`.

## Convenções de código e automação
- Não utilizar valores fixos (hardcoded) diretamente em funções ou métodos; extraia para constantes.
- Não realizar alterações estéticas, refactors ou melhorias não solicitadas.
- Siga sempre as instruções de `.github/instructions/`, `.github/copilot-instructions.md` e `opencode.json`.    

## Observações finais
- Este repositório utiliza governança baseada em evidências e rastreabilidade em CHANGELOG/*md.
- Não utilize, cite ou crie estruturas, docs/, wiki, req/ ou docs/.
- Toda referência de ciclo, plano, decisão ou auditoria deve apontar para arquivos CHANGELOG/*md e instruções do próprio repositório.
- Consulte sempre `opencode.json` e `.github/copilot-instructions.md` para padrões de ciclo e entrega.

## Proibição de alterações estéticas não solicitadas
- **É estritamente proibido** realizar alterações puramente estéticas em arquivos sem solicitação explícita. Alterações estéticas incluem:
  - Adicionar ou remover comentários explicativos que não sejam tecnicamente necessários
  - Adicionar ou remover espaços em branco, quebras de linha ou linhas vazias
  - Reformatar indentação ou alinhamento de código
  - Reorganizar imports ou declarações sem mudança funcional
  - Adicionar cabeçalhos de caminho em arquivos que não os possuem (exceto quando exigido por nova funcionalidade)
- **Formatação de código é responsabilidade de ferramentas** como Prettier, ESLint, e outros linters configurados no projeto.
- **Exceções permitidas:**
  - Quando a alteração estética é tecnicamente necessária para o funcionamento (ex: corrigir sintaxe)
  - Quando explicitamente solicitado no escopo da tarefa
  - Quando faz parte da configuração de uma nova ferramenta de linting/formatação
- **Para agentes de IA:** Foque exclusivamente nas mudanças funcionais requeridas. Não "melhore" a aparência do código ou adicione comentários "úteis" não solicitados. Deixe a formatação para as ferramentas apropriadas.

## Responsabilidades do projeto
- O subprojeto `api/` concentra as regras de negócio, a integração com provedores externos e os contratos expostos às interfaces de usuário. Toda lógica de persistência, validação e autorização deve residir aqui.
- O subprojeto `ui/` é responsável pela experiência do usuário, compondo interfaces e fluxos de interação baseados exclusivamente nos contratos fornecidos pelo `api/`.
- Alterações compartilhadas entre `api/` e `ui/` devem ser documentadas e negociadas explicitamente para evitar dependências implícitas; utilize diretórios compartilhados apenas quando formalmente aprovados na documentação arquitetural.
- A divisão de responsabilidades entre API, interfaces e serviços auxiliares está detalhada em [`docs/03-implementacao/estrutura-de-projeto.md`](docs/03-implementacao/estrutura-de-projeto.md). Consulte-o antes de modificar qualquer subprojeto.
- Mudanças que afetem múltiplos subprojetos devem ser coordenadas com a documentação de design e arquitetura (`docs/02-design/` e `docs/01-arquitetura/`) e acompanhadas por changelog específico.

## Monitoramento
- Sempre exponha métricas HTTP em `/metrics` e health checks em `/health`.
- Arquivos `prometheus.yml` devem utilizar portas internas padrão (`3002` para `api-rating`, `3003` para `api-key`, `3004` para `api-usage`, `3010` para `api-db`, `3011` para `api-login`) e seguir o formato adotado no arquivo raiz.
- Health checks e métricas obrigatórias estão descritos em [`docs/05-entrega-e-implantacao/ambientes-e-configuracoes.md`](docs/05-entrega-e-implantacao/ambientes-e-configuracoes.md). Exponha no mínimo `/health` e `/metrics` para cada serviço containerizado.
- Ajustes em portas, coletores ou dashboards devem ser documentados previamente nos artefatos de Entrega e Governança (`docs/05-entrega-e-implantacao/` e `docs/06-governanca-tecnica-e-controle-de-qualidade/`).

## Regra obrigatória do SSPA
- Ao expor MFEs pelo orquestrador `sspa` em `.docker/docker-compose.projects.postgres.yml`, mantenha `E2E_SKIP_JWT=true` no serviço `apis` e `SSPA_SKIP_AUTH=true` no serviço `sspa`.
- O frontend do SSPA deve respeitar `SSPA_SKIP_AUTH` para não exigir `SSPA_AUTH_TOKEN` quando o bypass estiver ativo.
- É proibido remover ou sobrescrever essa combinação sem atualização explícita de plano e changelog do ciclo correspondente.

## Documentação
- Atualize os READMEs específicos dos serviços e `docs/README.md` sempre que adicionar variáveis de ambiente, endpoints ou alterações arquiteturais relevantes.
- Mantenha as descrições alinhadas ao comportamento real do código e dos arquivos de configuração.

## Limpeza de código e remoção de código morto
- Após qualquer alteração no código (refatoração, substituição de lógica ou migração de funcionalidades), é obrigatória a remoção de todo o código morto. A verificação deve incluir:

  - **Código-fonte**:
    - Funções, métodos, classes e componentes (incluindo React) que não são mais utilizados.
    - Variáveis, constantes, atributos, hooks customizados e utilitários não referenciados.
    - Tipos, interfaces e enums (TypeScript) que se tornaram obsoletos.
    - Imports não utilizados em todos os arquivos do projeto.

  - **Configuração**:
    - Variáveis de ambiente não utilizadas em arquivos como `vite.config.ts`, `Makefile` e `.env`.

  - **Dependências**:
    - Dependências de pacotes não utilizadas no `package.json`.

  Essa regra se baseia nos princípios de código limpo (Clean Code) e manutenção sustentável. A presença de código morto compromete:
    - Legibilidade e clareza;
    - Facilidade de manutenção;
    - Precisão de testes e cobertura;
    - Segurança em deploys automatizados.

  A verificação deve ser feita recursivamente em todo o projeto, garantindo que nenhuma referência seja esquecida antes da exclusão.

## Política de scripts e automações
- É proibido criar ou utilizar arquivos de shell script (`.sh`, `.bash` ou similares) para execução de tarefas no projeto.
- Toda automação deve ser feita exclusivamente por meio do `Makefile`, que é o único ponto de orquestração permitido.
- Toda e qualquer execução do gerador, de aplicativos gerados, de bancos de dados, de containers e de testes deve ser feita exclusivamente por alvos do `Makefile`.
- É proibido executar diretamente no terminal comandos operacionais como `npm`, `sh`, `docker`, `docker-compose` e equivalentes para fluxos do projeto; use apenas entradas do `Makefile`.
- Não adicione shebangs de shell (`#!/bin/bash`, `#!/usr/bin/env sh`, etc.) a arquivos que não sejam scripts de entrypoint para Docker. A lógica de script deve ser encapsulada nos alvos do `Makefile`.
- Não adicione novos alvos ao `Makefile` sem solicitação explícita.
- Scripts de teste E2E devem ser escritos em JavaScript ou TypeScript utilizando exclusivamente Puppeteer, e executados via `npm run test:e2e` ou por targets existentes do `Makefile`.
- Os únicos arquivos de shell script permitidos são os entrypoints referenciados por `Dockerfile`s.
- Não adicione shebangs (`#!/bin/bash`, `#!/usr/bin/env sh`, etc.) a arquivos que não sejam os scripts de entrypoint permitidos para Dockerfiles.
- Não adicione novos alvos ao `Makefile` sem solicitação explícita.
- Scripts de teste E2E devem ser escritos em JavaScript ou TypeScript, utilizando exclusivamente Puppeteer, e executados via `npm run test:e2e` ou por targets existentes do `Makefile`.
- Os únicos arquivos de shell script permitidos são os entrypoints referenciados por `Dockerfile`s.

## Convenções de cabeçalho de caminho

- Todos os arquivos do projeto devem conter, no topo, um comentário com o caminho relativo real do arquivo dentro do projeto, seguindo a sintaxe específica da linguagem:
  - TypeScript: `// caminho/do/arquivo.ts`
  - TypeScript React: `// caminho/do/arquivo.tsx`
  - JavaScript: `// caminho/do/arquivo.js`
  - JavaScript React: `// caminho/do/arquivo.jsx`
  - YAML: `# caminho/do/arquivo.yaml`
  - Markdown: `<!-- caminho/do/arquivo.md -->`
  - Makefile: `# caminho/do/Makefile`
  - MCD:

    ```
    ---
    description: |
      `// src/rules/arquivo.mdc`
      ... restante da descrição ...

    globs: ['*']
    alwaysApply: true
    ---
    ```

- Quando necessário, preserve elementos obrigatórios da linguagem no topo do arquivo, como shebangs (`#!/bin/bash`) ou declarações de codificação (`# -*- coding: utf-8 -*-`), inserindo o comentário do caminho imediatamente após essas linhas.
- O valor do caminho deve ser calculado automaticamente com base na raiz do repositório, sem permitir divergências.

## Convenções de importação para TypeScript/JavaScript
- Todas as instruções `import` (ES6) ou `require` (CommonJS) devem estar localizadas no topo do arquivo, antes de qualquer execução de código.
- É proibido envolver importações em blocos `try/catch` para contornar erros de carregamento.
- Priorize importações estáticas no topo do arquivo. Importações dinâmicas (com `import()`) devem ser usadas apenas em cenários de carregamento sob demanda (code-splitting) onde o benefício de performance é claro e intencional.
- Em aplicações React/TypeScript, priorize sempre as importações no padrão ES6.
- Qualquer módulo externo referenciado deve estar listado no `package.json` e instalado previamente.
- Organize os imports em três grupos principais, separados por uma linha em branco: bibliotecas externas, módulos internos da aplicação e, por último, importações de tipos (`import type`).

## Regras obrigatórias para `gen/src/main.ts` e geradores
- O arquivo `gen/src/main.ts` deve atuar apenas como orquestrador de geração: parser de argumentos/parâmetros, integrações com banco de dados, integrações com git, cópia de arquivos estáticos e execução de geradores baseados em templates.
- `gen/src/main.ts` não deve implementar responsabilidades de empacotar, executar, testar ou contabilizar artefatos gerados.
- Para qualquer artefato 100% estático (sem interpolação), o conteúdo deve existir em disco em `gen/static/<componente>/` e ser copiado para o destino por função auxiliar dedicada de cópia estática.
- Para qualquer artefato que exija interpolação em tempo de geração, é obrigatório usar arquivo template EJS em `gen/templates/` e arquivo gerador TypeScript; é proibido gerar esses conteúdos com constantes string multiline/hardcode no gerador.
- É proibido definir constantes ou variáveis de texto com mais de 150 caracteres, ou com múltiplas linhas, dentro de arquivos geradores (`gen/src/*generator*.ts`, `gen/src/main.ts`); nesses casos, mover para template EJS ou arquivo estático.

## Regra obrigatória de escopo de correção por tipo de falha de teste
- Ao identificar defeitos durante testes contra as APIs, a correção deve ocorrer apenas nos arquivos de geração, templates e estáticos da API; é proibido alterar banco de dados nesse cenário.
- Ao identificar defeitos durante testes contra frontends, a correção deve ocorrer apenas nos arquivos de geração, templates e estáticos do frontend afetado; é proibido alterar banco de dados e API nesse cenário.
- Ao identificar defeitos durante testes E2E contra UI (frontends) relacionados ao consumo das APIs, a correção deve ocorrer apenas nos arquivos de geração, templates e estáticos do frontend; é proibido alterar API e banco de dados nesse cenário.

## Padrão obrigatório para planos de mudança
- Planos registrados em arquivos Markdown devem seguir uma estrutura comum.
- Cada plano precisa conter, na ordem apresentada, seções tituladas para:
  1. Lista de arquivos existentes relevantes para o escopo.
  2. Lista de arquivos que serão alterados (respeitando as restrições da tarefa).
  3. Lista combinada de requisitos da mudança específica e requisitos globais do projeto.
  4. Lista de requisitos atualmente não atendidos que o plano busca resolver.
  5. Lista combinada de regras da mudança específica e regras globais do projeto.
  6. Lista de regras atualmente não atendidas que motivam os ajustes.
  7. Plano de auditoria descrevendo verificações manuais e automáticas previstas.
  8. Seleção dos checklists em `docs/checklists/` aplicáveis ao contexto, referenciando-os no plano e destacando quais são de uso obrigatório independentemente do tema.
- Use listas ordenadas ou não ordenadas para cada item interno, mantendo descrições objetivas e referenciais cruzados para arquivos quando aplicável.
- O plano deve deixar explícito quando somente determinados tipos de arquivos (por exemplo, SQL) podem ser modificados na execução.
- O nome de cada arquivo de plano deve iniciar com `YYYYMMDDHHMMSS-` seguido de um identificador descritivo e a extensão `.md`, sincronizado com o timestamp do changelog correspondente.
- Sempre que um plano for criado ou atualizado, deve existir um plano de auditoria irmão no mesmo diretório com o mesmo prefixo `YYYYMMDDHHMMSS-` e sufixo `-audit` que replique o padrão observado em `.ref/docs/plans/*-audit.md`.
- Atualizações em planos ou auditorias devem ser registradas no changelog e referenciadas mutuamente para garantir rastreabilidade completa.

## Princípios de reutilização (DRY)
- Siga rigorosamente o princípio DRY (*Don't Repeat Yourself*) em todo o projeto.
- Antes de criar novas funções, classes, componentes ou qualquer implementação, verifique se já existe algo com o mesmo objetivo.
- Reutilize funções ou lógicas equivalentes já existentes. Se o reaproveitamento causar loop de importação, mova a implementação para um módulo comum, como `src/utils/` (para lógica interna de um serviço) ou para o diretório `shared/` (para lógica entre serviços).
- Nunca duplique código por conveniência ou para manter isolamento artificial entre arquivos.
- Parametrize pequenas variações de lógica em funções reutilizáveis.
- Para código React/TypeScript, componentes similares devem ser parametrizados via props, hooks customizados devem concentrar lógica compartilhada, utilitários devem ser centralizados em `src/utils/`, tipos e interfaces em `src/types/` e constantes em `src/constants/`.
- Aplique estas regras a qualquer linguagem utilizada no repositório (TypeScript, JavaScript, React, etc.), promovendo coesão e evitando acoplamento circular conforme recomendado por Clean Code.

## Regras para integrações adicionais
- Novos serviços (por exemplo, gateways, APIs especializadas ou integrações serverless) só podem ser adicionados após documentação prévia em `docs/01-arquitetura/` e `docs/02-design/`. Atualmente não há subprojetos PostgREST ativos neste repositório.
- Ao homologar uma nova integração, registre as convenções técnicas na fase correspondente da req e atualize este documento na revisão subsequente.

## Regras específicas do sub-projeto `api-postrest` (legado — restaurado de `.ref/`)
- A raiz `api-postrest/` deve conter somente `Dockerfile`, `docker-compose.yml`, `entrypoint.sh`, `Makefile`, `README.md`, `env/`, `config/`, `sql/` e `tools/`.
- Garanta que os comentários de caminho previstos neste arquivo estejam presentes em todos os arquivos Markdown e SQL do sub-projeto (ex.: `<!-- api-postrest/README.md -->`, `-- api-postrest/sql/login/0100_schema/0100_tb_login_identity.sql`).
- Scripts DDL e SEED precisam começar com prefixo numérico de pelo menos quatro dígitos (`0001_`, `0900_`, etc.) para preservar a ordem de execução, e as seeds devem ser separadas por tabela em diretório dedicado (`0900_seed/0900_seed_tb_<tabela>.sql`).
- Toda função SQL criada deve receber o prefixo `fn_` e residir no arquivo do domínio correspondente.
- O único script shell permitido no sub-projeto é o `entrypoint.sh`, que deve iniciar com `#!/bin/bash` seguido do comentário de caminho.
- O `Makefile` do sub-projeto deve reutilizar exclusivamente os alvos padrão (`build`, `start`, `stop`, `logs`, `clean`, `seed`) sem introduzir novos alvos sem justificativa explícita.
- É proibido adicionar dependências de linguagens, SDKs ou runtimes externos: somente imagens oficiais do Postgres e PostgREST são aceitas.
- Respeite a ordem de execução nativa do Postgres: ao copiar os arquivos para `/docker-entrypoint-initdb.d`, eles serão executados alfabeticamente. Utilize a numeração (`0001_`, `0100_`, `0700_`, `0800_`, `0900_`) para garantir a sequência correta dentro de cada diretório de banco.
- O diretório `sql/` não pode conter um subdiretório `_shared`. Todo script necessário para inicializar um banco deve residir dentro da árvore do respectivo banco (`login`, `account`, `grant`, `key`, `rating`, `usage`), mesmo que isso implique duplicação explícita dos arquivos. Ajustes comuns devem ser tratados por meio de variáveis de ambiente e substituições de placeholder.
- A execução dos scripts SQL deve aproveitar o comportamento nativo do Postgres: arquivos copiados para `/docker-entrypoint-initdb.d` são executados em ordem lexicográfica. Não utilize `tools/migrations-order.json` nem lógicas customizadas para ordenar migrações.
- O `entrypoint.sh`, único script shell permitido no sub-projeto, não pode mais gerenciar filas de migração personalizadas. Ele deve limitar-se a preparar variáveis de ambiente e delegar a execução ao `docker-entrypoint.sh` padrão do Postgres (ou a comandos equivalentes), evitando dependências do antigo `_shared`.
- Modelagem obrigatória das tabelas: nomes com prefixo `tb_`, colunas mínimas `id BIGSERIAL PRIMARY KEY`, `external_id UUID DEFAULT gen_random_uuid()`, `created_at TIMESTAMPTZ DEFAULT now()`, `updated_at TIMESTAMPTZ DEFAULT now()`, `deleted_at TIMESTAMPTZ` com `CHECK (deleted_at IS NULL OR deleted_at >= created_at)`, além de índice único para `external_id` e campos de negócio relevantes.
- Cada banco deve possuir as tabelas `tb_event` e `tb_event_body`, além da função `fn_event`, para registrar integralmente requests e responses do PostgREST (método, rota, cabeçalhos, parâmetros, corpo, status, latência e correlações `*_exid`) permitindo reconstrução via `curl`.
- Todos os objetos de banco (tabelas, colunas, relacionamentos, funções, gatilhos, tipos ou quaisquer outros artefatos SQL) devem possuir comentários explícitos. Cada comentário precisa residir em arquivo próprio com sufixo `_comments.sql`, imediatamente após o arquivo de criação do recurso (ex.: `0099_recurso_fulano_de_tal.sql` seguido por `0099_recurso_fulano_de_tal_comments.sql`).
- Utilize `*_exid` (`UUID`) para relacionamentos entre bancos, referenciando `external_id` da tabela de origem; relacionamentos internos usam chaves estrangeiras `*_id` com `ON UPDATE CASCADE` e `ON DELETE RESTRICT`.
- Sempre que disponível, prefira `uuid_generate_v7()` para `external_id`; até lá, use `gen_random_uuid()` e documente a futura migração.
- Configure as variáveis `PGRST_*` no `docker-compose.yml` para garantir portas exclusivas (`4101` a `4106`), `db-uri` com usuários específicos e `db-schema` limitado a `public`, respeitando as roles `postgrest_anonymous` (leitura mínima), `postgrest_service` (leitura/escrita controlada) e o owner dedicado do banco.
- As seeds devem criar ao menos um registro coerente por tabela, preservando consistência entre bancos através dos campos `*_exid` e mantendo cada carga em arquivo próprio.
- É proibido adicionar novamente `tools/migrations-order.json` ou quaisquer catálogos auxiliares de ordenação. Confie exclusivamente na ordem alfabética e na numeração dos arquivos.
- O alvo `seed` do `Makefile` deve executar apenas os arquivos de `0900_seed/` respeitando a ordenação nativa dos nomes, sem apoio em catálogos externos.
- Novos bancos requerem aprovação arquitetural e atualização desta seção; alterações em tabelas existentes devem ocorrer por scripts incrementais com numeração sequencial (ex.: `1000_alter_tb_account_profile.sql`).
- Instâncias PostgREST adicionais devem seguir a convenção `postgrest-<domínio>` no `docker-compose.yml`, com variáveis `PGRST_*` dedicadas e portas subsequentes. Dependências externas devem ser versionadas no `Dockerfile` e documentadas no `README.md` do sub-projeto.

## 🎨 Regra de Cores 60-30-10 (603010)
### Escopo
- Aplicável a qualquer entrega de front-end (páginas web, apps, micro-frontends, telas, e-mails, relatórios, mensagens ao usuário, dashboards, componentes, temas).

### Definição
- **60% — Cor Primária (Base):** fundo predominante e grandes áreas estruturais.
- **30% — Cor Secundária (Suporte):** blocos, cartões, barras, áreas funcionais.
- **10% — Cor de Destaque (Accent):** CTAs, links, estados ativos, badges, alertas.

### Diretrizes
1. **Paleta mínima:** defina explicitamente primária, secundária e accent (uma de cada).
2. **Tolerância:** aceite variação de ±5% por grupo (55–65 / 25–35 / 5–15) para acomodar conteúdo dinâmico.
3. **Acessibilidade:** contraste mínimo WCAG AA para texto e ícones sobre as três cores.
4. **Hierarquia:** o usuário deve identificar CTAs e estados em <3s ao primeiro olhar.
5. **Consistência:** a cor accent não pode ser reutilizada como fundo dominante.
6. **Estados e feedback:** foco/hover/ativo usam derivações da cor original (mesma família).
7. **Exceções controladas:** gráficos e heatmaps podem usar paletas próprias, sem quebrar a hierarquia global (legendas e eixos seguem 60-30-10).

### Medição (amostragem objetiva)
- **Áreas:** estime por área visível (containers, seções, cartões, barras) e peso visual (tamanho + recorrência).
- **Componentes:** audite 10 componentes representativos; a média deve respeitar 60-30-10.
- **E-mail/relatório:** avalie header, body, sidebar, footer e CTAs; reporte percentuais.

### Critérios de Aceite
- Paleta registrada (nomes e usos).
- Percentuais dentro da tolerância.
- CTAs e elementos críticos usando exclusivamente accent.
- Todos os textos em superfícies coloridas com contraste AA+.

## 🔍 Regra de Revisão 1 — Verificação Antialucinação
**Objetivo:** garantir que a aplicação do 603010 não introduziu suposições falsas, cores inexistentes ou quebras de padrão.

### Checklist (obrigatório)
- As cores citadas existem na paleta/tema do projeto (sem inventar tokens).
- Nomes/variáveis de cor batem com o design system (sem sinônimos não pactuados).
- Não houve troca silenciosa de significado (ex.: accent virando cor de fundo).
- Estados (hover/focus/active) mantêm a mesma família de cor.
- Contraste recalculado após mudanças (não assumir valores anteriores).

**Resultado:** “Aprovado” ou “Reprovado com correções” + breve justificativa.

## 📊 Regra de Revisão 2 — Auditoria do 60-30-10
**Objetivo:** confirmar conformidade quantitativa e perceptiva do 603010.

### Checklist (obrigatório)
- Percentuais por área e por componente dentro de ±5%.
- accent limitado a elementos de chamada (≤15% do total).
- secundária não ultrapassa 35% nem toma o papel da primária.
- CTAs são imediatamente distinguíveis (teste de atenção em 3s).
- Acessibilidade AA confirmada em exemplos-chave (hero, cards, tabelas, formulários, toasts).

**Resultado:** “Conforme 603010” ou “Não conforme 603010” + lista curta de ajustes.

### Observações finais
- Sempre registrar a paleta (nomes, usos e exemplos).
- Em exceções (gráficos/heatmaps), documentar a justificativa e manter o restante da interface em 60-30-10.

## 🔤 Regra Tipográfica 4x2 — Hierarquia e Consistência de Texto

### Escopo

Aplicável a qualquer entrega que contenha texto visível ao usuário: interfaces web, aplicativos, e-mails, relatórios, notificações, mensagens, telas de login, dashboards, formulários, modais, tooltips, PDFs ou qualquer outro artefato de front-end.

⸻

### Definição da Regra

4x2 representa o limite máximo de 4 tamanhos tipográficos e 2 pesos de fonte em um mesmo sistema visual.

#### Estrutura obrigatória

| Função | Tamanho | Peso | Exemplo de uso |
| --- | --- | --- | --- |
| Headline (Título principal) | 1º maior | Semibold ou Bold | títulos de páginas, seções, cabeçalhos principais |
| Subtitle (Subtítulo) | 2º maior | Regular ou Semibold | subtítulos, blocos informativos secundários |
| Body (Corpo de texto) | 3º maior | Regular | conteúdo, descrições, textos explicativos |
| Caption (Texto auxiliar) | 4º maior | Regular | rótulos, tooltips, notas de rodapé |

**Pesos permitidos:**

- Regular
- Semibold (ou Bold, conforme a fonte-base)

⸻

### Diretrizes Gerais

1. **Hierarquia clara:** o contraste entre os quatro tamanhos deve ser perceptível, mantendo ritmo visual e legibilidade.
2. **Limite fixo:** nenhum artefato pode conter mais de 4 tamanhos ou 2 pesos diferentes.
3. **Escala modular:** use progressão lógica (ex.: 32 → 24 → 16 → 12 px) ou baseada em múltiplos de 8.
4. **Coerência tipográfica:** aplique a mesma família tipográfica em toda a interface, exceto quando o estilo exigir destaque intencional documentado.
5. **Acessibilidade:** contraste mínimo WCAG AA e espaçamento adequado entre linhas (line-height ≥ 1.4).
6. **Consistência entre telas:** cada tamanho/peso deve ter nome e uso padronizado no design system (ex.: --text-headline, --text-body, --text-caption).

⸻

### Regra de Revisão 1 — Verificação Antialucinação Tipográfica

**Objetivo:** garantir que nenhuma mudança textual ou visual tenha introduzido estilos inexistentes ou inconsistentes.

#### Checklist (obrigatório)

- As classes ou tokens tipográficos usados existem no design system.
- Nenhum novo tamanho/peso foi criado sem registro.
- Nenhuma substituição implícita de peso (ex.: bold → medium) ocorreu sem justificativa.
- Todos os textos preservam contraste e espaçamento originais.
- Nenhum estilo visual foi inferido a partir de contexto (sem “suposições visuais”).

**Resultado:**

- “Aprovado (sem alucinações)”
- “Reprovado — ajustes necessários” (listar os desvios)

⸻

### Regra de Revisão 2 — Auditoria do 4x2

**Objetivo:** confirmar a conformidade técnica e visual com a regra tipográfica 4x2.

#### Checklist (obrigatório)

- O arquivo utiliza no máximo quatro tamanhos e dois pesos.
- Os tamanhos estão distribuídos hierarquicamente (headline > subtitle > body > caption).
- Nenhum componente isolado possui estilos fora da escala definida.
- A mesma estrutura é mantida em telas, relatórios e mensagens.
- A tipografia comunica corretamente a hierarquia de importância (testar percepção em 3 segundos).

**Resultado:**

- “Conforme 4x2”
- “Não conforme 4x2” (incluir observações e recomendações)

⸻

### Observações Finais

- O agente criador deve referenciar esta regra em commits quando aplicar modificações visuais.
- O agente revisor deve documentar as variações aprovadas, caso haja exceção justificada (ex.: relatórios impressos).
- Em sistemas que possuam dark mode, os tamanhos e pesos devem ser preservados — apenas as cores variam.

## 🔹 Regra de Espaçamento 8pt Grid System — Consistência Espacial e Modularidade

### Escopo

- Aplicável a todas as interfaces digitais: páginas web, aplicações mobile, dashboards, e-mails, relatórios, micro-frontends, componentes reutilizáveis e templates.
- Deve ser seguido por todos os agentes que criam, editam ou ajustam qualquer elemento visual relacionado a layout, espaçamento, padding, margin, grid ou alinhamento.

⸻

### Definição da Regra

O 8pt Grid System define que todos os espaçamentos, tamanhos e proporções de uma interface devem ser múltiplos de 8 px ou divisíveis por 4 px. Isso cria ritmo visual, escalabilidade e harmonia entre elementos.

### Estrutura Base

| Tipo de Espaço | Valores válidos (px) | Exemplos de uso |
| --- | --- | --- |
| Mínimo | 4 | separação entre ícones, labels pequenos |
| Pequeno | 8 | paddings internos, gap entre botões |
| Médio | 16 | espaçamento entre seções pequenas |
| Grande | 24 | separação entre blocos ou cards |
| Extra | 32+ | áreas principais, seções, containers |

#### Fórmula geral

- Use apenas valores divisíveis por 8 ou 4.
- Se o valor não for divisível por 8 ou 4 → não use.

⸻

## Regra de UX Writing e Simplificação de Texto — Clareza, Ação e Consistência

### 🔹 Estrutura obrigatória de documentos `docs/`

- **Escopo:** todos os arquivos dentro do diretório `docs/` e de seus subdiretórios.
- **Pares obrigatórios:** cada artefato deve existir em dupla `A.md` (orientação) e `A-spec.md` (definição específica do produto).
  - `A.md` contém apenas instruções reutilizáveis, descrevendo propósito, regras de preenchimento, passos de atualização e referências cruzadas necessárias. Nunca registre informações do produto atual aqui.
  - `A-spec.md` armazena o conteúdo concreto do projeto (requisitos, métricas, decisões, históricos, checklists). Todos os dados versionados pertencem ao arquivo `*-spec.md` correspondente.
- **Criação de novos artefatos:** ao precisar de um novo documento em `docs/`, crie simultaneamente o par `A.md`/`A-spec.md`, atualize os índices relevantes (`docs/README*.md`) e registre o motivo no `CHANGELOG` e em `docs/audit-history*.md`.
- **Atualizações:** qualquer mudança em conteúdo específico deve ser aplicada apenas no `*-spec.md`, acompanhada de revisão para garantir que o manual (`A.md`) continua livre de dados contextuais. Ajustes estruturais nos dois arquivos devem citar claramente o requisito ou decisão que motivou a alteração.
- **Validação automática:** antes de abrir PR, confirme que nenhum arquivo `docs/**/` ficou sem par através de `find req -name "*.md"` e verifique se todo `*-spec.md` possui o guia correspondente. Diferentes nomes exigem correspondência literal (ex.: `visao-do-produto.md` ↔ `visao-do-produto-spec.md`).
- **Reutilização em novos repositórios:** mantenha exemplos genéricos apenas em `A.md`. Se for necessário demonstrar formatos, use placeholders explícitos (`<REQ-XYZ>`, `<Métrica>`) e explique como preenchê-los.


### Escopo

- Aplica-se a toda interface textual: páginas web, aplicativos, dashboards, e-mails, modais, formulários, mensagens de erro, tooltips e relatórios.
- Todos os textos criados ou revisados pelos agentes devem seguir esta regra, garantindo linguagem funcional, direta e livre de redundâncias.

### Definição da Regra

- A escrita em interfaces deve seguir os princípios de UX Writing e Content Design, priorizando clareza, concisão e contexto.
- Cada texto deve servir a uma ação do usuário e não descrever a interface.

#### Princípios fundamentais

1. **Clareza:** o texto deve ser compreendido imediatamente, sem explicações adicionais.
2. **Concisão:** use o mínimo de palavras para expressar o máximo de sentido.
3. **Consistência:** mantenha o mesmo estilo e tom em todas as telas.
4. **Contexto:** o texto deve responder à pergunta “o que o usuário precisa fazer agora?”.
5. **Ação:** frases orientadas a verbo — sempre priorizar “fazer” em vez de “explicar”.

### Diretrizes Gerais

| Tipo | Recomendação | Exemplo |
| --- | --- | --- |
| Evitar redundâncias | Não use “page”, “screen”, “form”, “section” etc. | Voting page → Voting |
| Ações curtas e diretas | Sempre começar com o verbo principal. | Earn my tokens → Claim UMA |
| Evitar pronomes desnecessários | “My” e “Your” apenas quando o contexto exigir personalização. | My total tokens → Total tokens |
| Remover explicações autoevidentes | Se o contexto é claro, reduza a frase. | Please commit this vote now → Commit vote |
| Usar termos consistentes | O mesmo termo deve manter o mesmo significado em toda a interface. | Commit, Claim, Vote — não variar |
| Foco visual e semântico | O texto deve guiar o olhar, não competir com o conteúdo. | Headlines curtas e CTAs de alto contraste |

⸻

### Regra de Revisão 1 — Verificação Antialucinação de Texto

**Objetivo:** garantir que o agente escritor não inventou termos, intenções ou frases não baseadas em design system ou contexto real.

**Checklist (obrigatório):**

- Todos os textos seguem linguagem objetiva e contextual.
- Nenhum texto inventa conceitos ou fluxos inexistentes.
- O vocabulário está alinhado com o tom e voz do produto (manual de marca, se houver).
- Nenhum termo descritivo substitui uma ação.
- Frases redundantes ou decorativas foram removidas.

**Resultado:**

- “Aprovado (sem alucinações)”
- “Reprovado — ajustar microcopy” (listar inconsistências)

⸻

### Regra de Revisão 2 — Auditoria de Conformidade UX Writing

**Objetivo:** confirmar que o texto aplicado cumpre integralmente as diretrizes de UX Writing e simplificação.

**Checklist (obrigatório):**

- Nenhum rótulo, título ou botão contém palavras redundantes.
- Todos os textos são curtos, claros e acionáveis.
- A hierarquia textual está evidente (headline → ação → feedback).
- Os textos se encaixam visualmente no layout (sem quebra de ritmo).
- Os verbos usados expressam ação direta e única.
- Nenhuma sentença ultrapassa 12 palavras sem necessidade contextual.

**Resultado:**

- “Conforme UX Writing”
- “Não conforme UX Writing” (incluir correções sugeridas)

⸻

### Observações Finais

- O agente criador deve documentar todas as alterações textuais justificando a escolha (ex.: clareza, redundância, foco de ação).
- O agente revisor deve comparar antes e depois, garantindo que a versão final reduz complexidade sem perda de sentido.
- Esta regra deve ser aplicada em conjunto com:
  - Regra 603010 (Cores)
  - Regra 4x2 (Tipografia)
  - Regra 8pt Grid (Espaçamento)
- Dessa forma, garantimos coerência total entre forma, cor, ritmo e linguagem.

⸻

### Diretrizes Gerais

1. **Base modular:** o grid e os componentes devem alinhar-se à grade de 8 px.
2. **Unidade consistente:** usar px apenas como referência base — escalonar via rem/em mantendo equivalência (ex.: 1rem = 8px).
3. **Ritmo vertical:** manter espaçamento vertical uniforme entre títulos, textos e elementos interativos.
4. **Ritmo horizontal:** paddings laterais e margens também seguem múltiplos de 8.
5. **Componentização:** todos os tokens, variáveis e classes de layout devem ser baseados na escala (--space-4, --space-8, --space-16, etc.).
6. **Exceções controladas:** apenas casos documentados (como grids de gráficos) podem usar espaçamentos fora da escala, desde que anotados.

⸻

### Regra de Revisão 1 — Verificação Antialucinação de Espaçamento

**Objetivo:** garantir que nenhum espaçamento ou proporção foi introduzido de forma arbitrária ou incoerente com a escala 8pt.

**Checklist (obrigatório):**

- Todos os valores de margin, padding, gap, width, height, border-radius e line-height são múltiplos de 4 ou 8.
- Nenhum valor decimal (ex.: 7px, 19px, 41px) foi aplicado.
- Tokens ou variáveis de layout referenciam corretamente o sistema (--space-8, --space-16, etc.).
- Nenhuma inferência “visual” (ex.: ajuste empírico) substitui valores baseados na grade.
- Layout e componentes estão visualmente alinhados à grid.

**Resultado:**

- “Aprovado (sem alucinações)”
- “Reprovado — ajustes necessários” (listar valores incorretos)

⸻

### Regra de Revisão 2 — Auditoria do 8pt Grid System

**Objetivo:** confirmar a conformidade estrutural e perceptiva com o sistema 8pt.

**Checklist (obrigatório):**

- Todos os espaçamentos e dimensões seguem múltiplos de 8 ou 4.
- A distribuição dos elementos mantém alinhamento horizontal e vertical.
- Tokens e classes de espaçamento estão documentados no design system.
- Nenhum componente isolado quebra o ritmo modular.
- Escala perceptiva coerente: micro, pequeno, médio, grande e extra.

**Resultado:**

- “Conforme 8pt Grid”
- “Não conforme 8pt Grid” (listar desvios e recomendações)

⸻

### Observações Finais

- O agente criador deve referenciar esta regra em commits ao ajustar espaçamentos ou grids.
- O agente revisor deve comparar com o layout de referência e documentar desvios aceitáveis.
- Em sistemas que utilizem dark mode ou variantes temáticas, o grid deve permanecer inalterado.
- Esta regra é complementar às regras 603010 (cores) e 4x2 (tipografia), garantindo consistência visual e modularidade total no design.

## 🔸 Regra de Simplicidade Visual — “Simplicity Over Flashiness”

### Escopo

Aplica-se a todas as interfaces gráficas e elementos visuais criados ou revisados pelos agentes, incluindo páginas web, aplicativos, relatórios, dashboards, e-mails, micro-frontends e sistemas interativos. O objetivo é garantir que cada componente priorize clareza, propósito e legibilidade, evitando excesso de ornamentos visuais.

⸻

### Definição da Regra

A interface deve adotar o princípio de simplicidade funcional — todo elemento visual deve existir por um motivo funcional, não estético. Esse princípio deriva das metodologias de Design Minimalista, UX Heuristics (Jakob Nielsen) e Material Design, que defendem:

> Remova tudo o que não contribui para a compreensão, ação ou hierarquia.

⸻

### Diretrizes Gerais

| Princípio | Diretriz | Exemplo de Correção |
| --- | --- | --- |
| Clareza acima da estética | Prefira contraste, espaçamento e tipografia equilibrada em vez de brilhos e sombras. | Fundo degradê com sombra → Fundo sólido neutro |
| Propósito sobre aparência | Efeitos visuais só são válidos se reforçarem informação ou interação. | Botão com gradiente 3D → Botão plano com cor de ação |
| Economia visual | Reduza ruído, mantenha apenas o essencial. | Remover ícones redundantes, fundos duplicados, molduras |
| Consistência | Um único estilo visual por sistema (Flat, Material, etc.). | Evitar misturar neomorfismo com flat design |
| Leitura imediata | A mensagem deve ser compreendida em até 3 segundos. | Remover animações lentas ou distrações |
| Hierarquia de foco | Apenas um ponto principal de atenção por tela. | Excesso de cores e brilhos → foco em um único CTA |

⸻

### Estilo visual recomendado

- Cores sólidas e neutras (usando regra 60-30-10).
- Tipografia clara (seguindo regra 4x2).
- Espaçamento previsível e modular (seguindo regra 8pt Grid).
- Ícones simples, vetoriais e com função comunicativa.
- Animações sutis e rápidas (< 300 ms), sempre com propósito funcional.

⸻

### Regra de Revisão 1 — Verificação Antialucinação Visual

**Objetivo:** assegurar que nenhum elemento visual, cor, textura ou efeito foi adicionado sem base funcional ou sem origem no design system.

**Checklist (obrigatório):**

- Todos os elementos gráficos estão documentados no sistema visual (tokens, variáveis, componentes).
- Nenhum efeito visual foi criado sem propósito funcional (ex.: brilho, sombra, reflexo).
- Nenhum novo estilo (degradê, filtro, blur) foi “improvisado” pelo agente.
- O contraste atende aos padrões WCAG AA.
- O foco principal da tela é inequívoco.

**Resultado:**

- “Aprovado (sem alucinações visuais)”
- “Reprovado — ajuste estético necessário” (listar inconsistências)

⸻

### Regra de Revisão 2 — Auditoria de Conformidade Visual

**Objetivo:** confirmar que a interface cumpre o princípio “Simplicidade acima de Aparência” e mantém coerência visual com o restante do sistema.

**Checklist (obrigatório):**

- O layout é limpo, objetivo e funcional.
- Todos os efeitos têm função prática (não meramente estética).
- A hierarquia visual está clara e equilibrada.
- Há consistência de estilo entre telas, componentes e estados.
- A experiência transmite clareza, foco e fluidez, sem poluição visual.
- Nenhuma área da interface compete visualmente com o conteúdo principal.

**Resultado:**

- “Conforme Simplicidade Visual”
- “Não conforme Simplicidade Visual” (com recomendações específicas)

⸻

### Observações Finais

- O agente criador deve documentar o propósito de cada elemento visual quando for introduzido (ex.: “sombra para indicar profundidade interativa”).
- O agente revisor deve comparar antes e depois para garantir que o design evoluiu em direção à simplicidade e não à complexidade.
- Esta regra se aplica em conjunto com:
  - Regra 603010 (Cores)
  - Regra 4x2 (Tipografia)
  - Regra 8pt Grid (Espaçamento)
  - Regra de UX Writing (Texto)
- garantindo coerência estética e comunicativa entre forma, função e linguagem.

⸻

### Estrutura Obrigatória do Side Panel

#### Cabeçalho (Header Zone)
- **Logo dinâmico:** identidade visual adaptável conforme branding do tenant ativo.
- **Nome do tenant:** exibição clara da organização/contexto atual de uso.
- **Status de autenticação:** indicador visual do estado de login (conectado/desconectado).
- **Menu contextual:** máximo de três ações principais (Configurar IA, Preferências, Sair).

#### Corpo Modular (Main Content Area)
Estruturado em blocos reordenáveis conforme fluxo do usuário:
1. **Upload inteligente:** área de arrastar e soltar para PDFs com feedback visual imediato.
2. **Fila de diagnósticos:** lista de exames em processamento/concluídos com status claro.
3. **Insights multimodais:** painel para diagnósticos de texto e áudio gerados.
4. **Alertas/Ações necessárias:** notificações prioritárias e próximos passos.

#### Rodapé (Footer Zone)
- **Texto legal:** informações de conformidade e LGPD sempre visíveis.
- **Última sincronização:** timestamp da última atualização de dados.
- **Links rápidos:** acesso direto para suporte e documentação.

⸻

### Microinterações Padronizadas

| Ação | Duração | Easing | Feedback Visual |
| --- | --- | --- | --- |
| Hover em botões | 150ms | ease-out | Mudança sutil de cor (mesma família) |
| Upload de arquivo | 200ms | ease-in-out | Barra de progresso + ícone de status |
| Expansão de cards | 180ms | ease-out | Animação de altura com fade-in de conteúdo |
| Mudança de seção | 200ms | ease-in-out | Slide horizontal suave |
| Estados de erro | Imediato | n/a | Cor de alerta + ícone + texto explicativo |

### Diretrizes de Navegação

1. **Fluxos lineares:** máximo três passos visíveis por ação principal.
2. **Breadcrumbs sintéticos:** rótulos de seção que indicam contexto atual.
3. **Feedback explícito:** mensagens textuais para ações que envolvam APIs.
4. **Acessibilidade:** navegação completa via teclado sem armadilhas de foco.

⸻

### Estados de Feedback Obrigatórios

- **Carregando:** spinner discreto + texto "Processando..."
- **Sucesso:** ícone verde + mensagem acionável
- **Erro:** ícone vermelho + texto explicativo + ação de correção
- **Vazio:** ilustração + texto motivacional + CTA principal
- **Offline:** banner persistente + opções de cache local

### Critérios de Aceite

- [ ] Cabeçalho com logo, tenant, status de auth e menu contextual (≤3 ações)
- [ ] Corpo com blocos reordenáveis: Upload, Fila, Insights, Alertas
- [ ] Rodapé sempre visível com legal, sync timestamp e links rápidos
- [ ] Microinterações documentadas e implementadas conforme tabela
- [ ] Todos os estados de feedback funcionais e acessíveis
- [ ] Navegação por teclado completa sem armadilhas

⸻

### Paleta Cromática Obrigatória

#### Cores Primárias
- **Roxo profundo:** `#2D0F55` (backgrounds principais, identidade core)
- **Turquesa:** `#00B5B8` (elementos secundários, destaque funcional)
- **Superfície clara:** `#F4F5FB` (backgrounds de conteúdo, cards)

#### Escala Neutra
- **Texto principal:** `#1C1D22` (textos de alta hierarquia)
- **Texto secundário:** `#6B7280` (textos de apoio, descrições)
- **Bordas:** `#D9DBE7` (divisores, outlines)
- **Background neutro:** `#FFFFFF` (fundos limpos)

#### Cores de Feedback
- **Sucesso:** `#1DB954` (confirmações, estados positivos)
- **Atenção:** `#FF9F1C` (alertas, estados de cuidado)
- **Erro:** `#E63946` (falhas, estados críticos)

**Conformidade:** Todas as cores atendem WCAG AA com contraste mínimo 4.5:1 para texto normal e 3:1 para textos grandes.

⸻

### Sistema Tipográfico (Regra 4x2)

#### Famílias de Fonte
- **Títulos:** Manrope (Semibold, Google Fonts)
- **Corpo:** Inter (Regular, Google Fonts)

#### Hierarquia de Tamanhos
| Função | Tamanho | Peso | Line-height | Uso |
| --- | --- | --- | --- | --- |
| Headline | 32px | Semibold | 1.25 | Títulos principais, headers |
| Subtitle | 24px | Semibold | 1.33 | Subtítulos, seções |
| Body | 16px | Regular | 1.5 | Conteúdo, descrições |
| Caption | 12px | Regular | 1.4 | Rótulos, metadados |

⸻

### Tokens de Espaçamento (8pt Grid)

#### Escala Base
- **--space-4:** 4px (separações mínimas)
- **--space-8:** 8px (paddings internos)
- **--space-16:** 16px (espaçamentos entre elementos)
- **--space-24:** 24px (separação entre blocos)
- **--space-32:** 32px (seções principais)
- **--space-48:** 48px (áreas de destaque)

#### Raio de Bordas
- **--radius-sm:** 4px (elementos pequenos)
- **--radius-md:** 8px (botões, inputs)
- **--radius-lg:** 12px (cards, modais)

⸻

### Integração com BrandingHelper.ts

#### Armazenamento IndexedDB
```typescript
interface BrandingTokens {
  palette: {
    primary: string;
    secondary: string;
    accent: string;
    neutral: NeutralScale;
    feedback: FeedbackColors;
  };
  typography: {
    headlines: FontFamily;
    body: FontFamily;
    scale: TypeScale;
  };
  spacing: SpacingScale;
  tenant: {
    logo: string;
    name: string;
    customizations: CustomizationOptions;
  };
}
```

#### Personalização White-label
- Substituição controlada de cores primária e secundária
- Upload de logo personalizado (SVG, máx 24kb)
- Adaptação automática de contraste para acessibilidade
- Fallback para tokens padrão em caso de falha

⸻

### Iconografia Padronizada

- **Biblioteca:** Material Symbols Rounded (Google)
- **Tamanho mínimo:** 20px (para garantir legibilidade)
- **Estados:** outlined (padrão), filled (ativo/foco)
- **Cor:** herda do contexto ou usa tokens de cor

### Critérios de Aceite

- [ ] Paleta implementada com conformidade WCAG AA
- [ ] Tipografia 4x2 aplicada em todos os componentes
- [ ] Espaçamento 8pt Grid respeitado em layout e componentes
- [ ] BrandingHelper.ts integrado com IndexedDB
- [ ] Personalização white-label funcional com fallbacks
- [ ] Iconografia Material Symbols implementada

⸻

## 🔻 Acessibilidade e Feedback Inclusivo — Conformidade WCAG e Experiência Universal (06-UX-003)

### Escopo

Aplicável a todos os componentes interativos, formulários, navegação e feedback da extensão Chrome ModAuth, garantindo conformidade integral com WCAG 2.1 AA e experiência inclusiva para usuários com diferentes necessidades e tecnologias assistivas.

⸻

### Conformidade WCAG 2.1 AA

#### Contraste e Legibilidade
- **Texto normal:** contraste mínimo 4.5:1 sobre qualquer fundo
- **Texto grande (≥18px):** contraste mínimo 3:1 sobre qualquer fundo
- **Elementos gráficos:** contraste mínimo 3:1 para ícones e controles
- **Estados de foco:** contraste mínimo 3:1 para indicadores visuais

#### Navegação por Teclado
- **Tab sequence:** ordem lógica seguindo fluxo visual
- **Indicadores de foco:** outline de 2px com cor contrastante
- **Sem armadilhas:** saída disponível para qualquer elemento focável
- **Atalhos:** teclas de acesso documentadas e consistentes

⸻

### Atributos ARIA Obrigatórios

```html
<!-- Upload de arquivo -->
<input type="file" aria-label="Selecionar PDF para diagnóstico" aria-describedby="upload-help" />
<div id="upload-help">Formatos aceitos: PDF até 10MB</div>

<!-- Estados de progresso -->
<div role="progressbar" aria-valuenow="45" aria-valuemin="0" aria-valuemax="100" aria-label="Processando diagnóstico">
  45% concluído
</div>

<!-- Player de áudio -->
<button aria-label="Reproduzir áudio do diagnóstico" aria-pressed="false">
  <span aria-hidden="true">▶️</span>
</button>
```

```html
<!-- Landmarks -->
<main role="main" aria-label="Painel de diagnósticos">
<nav role="navigation" aria-label="Menu principal">
<aside role="complementary" aria-label="Insights e alertas">

<!-- Headings hierárquicos -->
<h1>Dashboard</h1>
<h2>Diagnósticos Recentes</h2>
<h3>Exame #12345</h3>
```

⸻

### Mensagens e Feedback Inclusivos

#### Estados de Sistema
- **Carregando:** "Processando diagnóstico, aguarde..." + spinner
- **Sucesso:** "Diagnóstico gerado com sucesso. Próximo: revisar resultado."
- **Erro:** "Falha no processamento. Verifique o arquivo e tente novamente."
- **Offline:** "Conexão perdida. Dados salvos localmente serão sincronizados."

#### Instruções Acionáveis
- Evitar linguagem técnica ("Clique em...")
- Priorizar verbos de ação ("Selecione", "Confirme", "Revise")
- Incluir contexto temporal ("Processamento pode levar até 2 minutos")
- Oferecer alternativas ("Ou arraste o arquivo aqui")

⸻

### Tecnologias Assistivas

#### Leitores de Tela
- Textos alternativos descritivos para imagens informativas
- Rótulos claros para elementos interativos
- Anúncios de mudanças de estado (`aria-live`)
- Estrutura semântica com landmarks e headings

#### Magnificação de Tela
- Layout flexível até 200% de zoom sem scroll horizontal
- Controles com área mínima de toque 44x44px
- Espaçamento adequado entre elementos clicáveis

#### Navegação por Voz
- Rótulos únicos e descritivos para comandos
- Elementos identificáveis por texto visível
- Compatibilidade com software de reconhecimento de voz

⸻

### Checklist de Validação Obrigatória

#### Antes de cada Release
- [ ] Teste com leitor de tela (NVDA ou JAWS) em fluxos críticos
- [ ] Navegação completa apenas por teclado
- [ ] Validação de contraste com ferramentas automatizadas
- [ ] Zoom até 200% sem perda de funcionalidade
- [ ] Teste de cores (simulação de daltonismo)
- [ ] Validação de ARIA com axe-core ou similar
- [ ] Linguagem clara e instruções acionáveis
- [ ] Tempos de resposta comunicados adequadamente

#### Critérios de Bloqueio
- Contraste insuficiente em elementos críticos
- Armadilhas de navegação por teclado
- Falta de rótulos em formulários
- Conteúdo não acessível por leitores de tela
- Elementos interativos menores que 44px

⸻

### Ferramentas de Teste Homologadas

- **axe-core:** auditoria automatizada de acessibilidade
- **WAVE:** validação visual e estrutural
- **Lighthouse:** métricas de acessibilidade integradas ao pipeline
- **Color Oracle:** simulação de daltonismo
- **NVDA/JAWS:** teste com leitores de tela reais


⸻

## Diretrizes de UX e Branding
- As regras completas de layout do painel lateral, tokens de identidade visual, acessibilidade e QA estão catalogadas em [`docs/06-ux-brand/diretrizes-de-ux.md`](docs/06-ux-brand/diretrizes-de-ux.md).
- Utilize as seções deste documento sobre cores (603010), tipografia (4x2), espaçamento (8pt Grid), simplicidade visual e UX Writing como checklist resumido, sempre confirmando os detalhes na req antes de alterar componentes.

## 🔧 Fluxo SemVer de Release — Versionamento, Empacotamento e Submissão Chrome Web Store

### Escopo

Define o processo completo de versionamento semântico, empacotamento da extensão e submissão à Chrome Web Store, garantindo rastreabilidade integral entre código-fonte, artefatos gerados e distribuição aos usuários finais.

⸻

### Política de Versionamento SemVer

#### Formato Obrigatório
- **Padrão:** `X.Y.Z` (Major.Minor.Patch)
- **Major (X):** mudanças incompatíveis, breaking changes na API
- **Minor (Y):** novas funcionalidades mantendo compatibilidade
- **Patch (Z):** correções de bugs e melhorias menores

#### Atualização de Versão
- Incrementar no `manifest.json` da extensão
- Sincronizar com `package.json` do projeto
- Atualizar documentação relevante (`README.md`, `CHANGELOG/`)

⸻

### Pipeline de Release

#### 1. Preparação de Release
```bash
# Validar que todas as alterações estão commitadas
git status

# Criar branch de release
git checkout -b release/v1.2.0

# Atualizar versão no manifest.json
# Executar build de produção
cd extension
npm run build

# Validar integridade do build
npm run lint
npm run typecheck
```

#### 2. Empacotamento
- **Diretório fonte:** `extension/dist/` (gerado pelo Vite)
- **Arquivos obrigatórios:** `manifest.json`, assets de `public/`, bundle JS/CSS
- **Formato final:** arquivo ZIP assinado para Chrome Web Store
- **Validações:** tamanho máximo (10MB), permissões mínimas, conformidade MV3

#### 3. Tag Git e Release GitHub
```bash
# Criar tag anotada
git tag -a v1.2.0 -m "Release v1.2.0: [descrição das mudanças]"

# Fazer push da tag
git push origin v1.2.0

# Criar release no GitHub com:
# - Título: "v1.2.0 - [resumo]"
# - Descrição: changelog detalhado
# - Anexo: arquivo ZIP da extensão
# - Assets: evidências de testes
```

#### 4. Submissão à Chrome Web Store
- **Responsável:** conforme definido em [`docs/05-entrega-e-implantacao/empacotamento.md`](docs/05-entrega-e-implantacao/empacotamento.md) ou artefato equivalente.
- **Processo:** upload manual via Chrome Web Store Developer Console seguindo o checklist publicado na req.
- **Validações:** review automático e aprovação editorial da loja.
- **Timeline:** estimativa de 1 a 7 dias úteis, com monitoramento até a publicação definitiva.

⸻

### Controle de Artefatos

#### Retenção Obrigatória (12 meses mínimo)
- Arquivo ZIP submetido à loja
- Logs completos do pipeline de build
- Evidências de testes (screenshots, relatórios)
- Changelog correspondente ao release
- Tags Git com metadados completos

#### Rastreabilidade
- Cada release vinculada a commit específico
- Changelog obrigatório seguindo formato `YYYYMMDDHHMMSS.md`
- Correlação entre versão, tag Git, arquivo ZIP e publicação na loja

⸻

### Rollback e Recuperação

#### Critérios para Rollback
- Falhas críticas detectadas em produção
- Violação de políticas da Chrome Web Store
- Problemas de segurança ou privacidade

#### Processo de Rollback
```bash
# Reverter para tag estável anterior
git checkout v1.1.9

# Regenerar build limpo
npm run build

# Reempacotar e resubmeter à Chrome Web Store
# Comunicar usuários via changelog de emergência
```

⸻

## 🌿 Convenções de Branches e Governança de Aprovação

### Escopo

Estabelece padrões obrigatórios para nomenclatura de branches, fluxo de desenvolvimento e processo de aprovação técnica conforme diretrizes e governança técnica documentada.

⸻

### Convenções de Nomenclatura

#### Padrões Obrigatórios
- **Feature:** `feature/nome-descritivo` (novas funcionalidades)
- **Fix:** `fix/nome-do-problema` (correções de bugs)
- **Hotfix:** `hotfix/correcao-critica` (correções emergenciais)
- **Release:** `release/vX.Y.Z` (preparação de versões)
- **Docs:** `docs/atualizacao-especifica` (documentação)

#### Exemplos Válidos
```
feature/upload-multiple-files
fix/auth-token-expiration
hotfix/memory-leak-insights-panel
release/v1.3.0
docs/update-accessibility-guidelines
```

⸻

### Fluxo de Desenvolvimento

#### 1. Criação de Branch
```bash
# Sempre partir da main atualizada
git checkout main
git pull origin main

# Criar branch seguindo convenção
git checkout -b feature/nova-funcionalidade
```

#### 2. Desenvolvimento e Commits
- Commits atômicos com mensagens descritivas
- Seguir padrão: `tipo: descrição clara em português`
- Referenciar issues quando aplicável: `fix: corrigir login (#123)`

#### 3. Pull Request
- **Título:** seguir padrão da branch (`feature: adicionar upload múltiplo`)
- **Descrição:** contexto, alterações, testes realizados
- **Reviewers:** mínimo 1 aprovação técnica + 1 governança
- **Checks:** pipeline automatizado deve passar (lint, build, testes)

⸻

### Processo de Aprovação Obrigatório

#### Revisão Automatizada
- **Lint e build:** sem erros ou warnings críticos
- **Testes:** cobertura mantida ou melhorada
- **Segurança:** scan de vulnerabilidades aprovado
- **Agentes IA:** relatórios de escopo e arquitetura validados

#### Revisão Humana (Dupla Obrigatória)
1. **Técnica:** desenvolvedor sênior ou tech lead
   - Qualidade de código
   - Aderência aos padrões
   - Impacto em performance
   
2. **Governança:** responsável de governança técnica
   - Alinhamento com roadmap
   - Implicações de release

#### Critérios de Bloqueio
- Falha em testes automatizados
- Violação de padrões de segurança
- Falta de documentação para mudanças críticas
- Não conformidade com diretrizes UX/acessibilidade
- Ausência de changelog quando necessário

⸻

### Proteção da Branch Main

#### Regras Aplicadas
- **Force push:** proibido
- **Merge direto:** bloqueado (apenas via PR aprovado)
- **Status checks:** obrigatórios antes do merge
- **Reviews:** mínimo 2 aprovações conforme descrito
- **Branch atualizada:** merge apenas com main atualizada

#### Exceções Emergenciais
- **Hotfix crítico:** aprovação acelerada com justificativa
- **Rollback:** processo documentado com aval da governança
- **Documentação:** mudanças menores podem ter processo simplificado

⸻

## 🔍 Ferramentas QA Homologadas e Formato de Relatórios

### Escopo

Define as ferramentas oficialmente aprovadas para testes, validação e auditoria da solução baseada em extensão Chrome, incluindo configuração, execução e formato padronizado dos relatórios de qualidade.

⸻

### Ferramentas Automatizadas Homologadas

#### GitHub Actions (Orquestrador Principal)
- **Função:** CI/CD, pipelines automatizados, integração de ferramentas
- **Workflows obrigatórios:**
  - `build.yml` — Build e validação de código
  - `test.yml` — Execução de testes unitários e E2E
  - `review.yml` — Revisão automatizada com agentes IA
  - `release.yml` — Empacotamento e release
  - `audit.yml` — Auditoria de segurança e conformidade

#### Playwright (Testes E2E)
- **Versão homologada:** ≥1.40.0
- **Navegadores:** Chromium (obrigatório), Firefox, WebKit (opcionais)
- **Configuração:** `playwright.config.ts` padronizado
- **Escopo:** fluxos críticos da extensão (auth, upload, insights)

#### Vitest/Jest (Testes Unitários)
- **Framework preferencial:** Vitest para projetos Vite
- **Alternativa:** Jest para compatibilidade legada
- **Cobertura mínima:** 80% para código crítico
- **Configuração:** integração com TypeScript e React

#### Modelos de IA (Revisão assistida)
- Consulte [`docs/06-governanca-tecnica-e-controle-de-qualidade/revisoes-com-ia.md`](docs/06-governanca-tecnica-e-controle-de-qualidade/revisoes-com-ia.md) para a lista de modelos aprovados, tokens autorizados e fluxos de auditoria.

⸻

### Ferramentas de Validação de Qualidade

#### ESLint (Linting)
- **Configuração:** `eslint.config.js` com regras TypeScript/React
- **Regras obrigatórias:** sem warnings em código de produção
- **Integração:** pré-commit hooks + pipeline CI

#### TypeScript (Type Checking)
- **Modo strict:** obrigatório (`"strict": true`)
- **Comando:** `tsc --noEmit` para validação sem build
- **Integração:** IDE + pipeline automatizado

#### axe-core (Acessibilidade)
- **Versão:** ≥4.8.0
- **Integração:** Playwright + relatórios automatizados
- **Cobertura:** todos os componentes interativos

#### Lighthouse (Performance e PWA)
- **Métricas mínimas:**
  - Performance: ≥90
  - Accessibility: ≥95
  - Best Practices: ≥90
- **Execução:** automatizada em pipeline CI

⸻

### Formato Padronizado de Relatórios

#### Estrutura Obrigatória
```markdown
<!-- CHANGELOG/YYYYMMDDHHMMSS-qa-report.md -->
# Relatório QA - [Título da Entrega]

## Informações Básicas
- **Data/Hora UTC:** YYYY-MM-DD HH:mm:ss
- **Branch:** feature/nome-da-branch
- **Commit:** SHA completo
- **Responsável:** Nome do desenvolvedor
- **Reviewer:** Nome do revisor

## Resultados dos Testes

### Testes Automatizados
- **Build:** ✅/❌ Status
- **Lint:** ✅/❌ Status (0 warnings aceitos)
- **TypeScript:** ✅/❌ Status (0 erros aceitos)
- **Testes unitários:** ✅/❌ Status (cobertura: XX%)
- **Testes E2E:** ✅/❌ Status (XX cenários)

### Validações de Qualidade
- **Acessibilidade (axe):** ✅/❌ Status (XX violações)
- **Performance (Lighthouse):** Score XXX/100
- **Segurança:** ✅/❌ Status (vulnerabilidades: XX)

## Revisões por IA
- **Scope Corrector:** ✅/❌ Conforme escopo
- **Architecture Corrector:** ✅/❌ Aderência arquitetural
- **Code Reviewer:** ✅/❌ Qualidade de código

## Evidências
- [Link para screenshots dos testes E2E]
- [Link para relatórios Lighthouse]
- [Link para logs completos do pipeline]

## Observações e Bloqueios
- [Lista de problemas encontrados]
- [Ações corretivas necessárias]
- [Aprovação final: ✅/❌]
```

#### Armazenamento e Rastreabilidade
- **Localização:** `docs/reports/YYYYMMDD/`
- **Nomenclatura:** `qa-report-{branch}-{short-sha}.md`
- **Retenção:** mínimo 12 meses
- **Vinculação:** anexar ao Pull Request correspondente

⸻

### Critérios de Aprovação QA

#### Aprovação Automática
- Todos os testes automatizados passaram
- Lint e TypeScript sem erros
- Cobertura de testes mantida ou melhorada
- Acessibilidade sem violações críticas
- Performance Lighthouse ≥ limites definidos

#### Revisão Manual Obrigatória
- Novos componentes ou funcionalidades
- Alterações em fluxos críticos (auth, payment, data processing)
- Mudanças em configurações de segurança
- Atualizações de dependências externas

#### Critérios de Bloqueio
- Falhas em testes E2E críticos
- Regressão de performance > 10%
- Violações de acessibilidade WCAG AA
- Vulnerabilidades de segurança alta/crítica
- Falta de cobertura em código crítico

⸻

## 🔹 Rastreabilidade e Auditoria de Execuções
- Cada agente deve registrar suas execuções com os seguintes metadados mínimos:
  - `AGENT_ID`
  - `GITHUB_RUN_ID`
  - `MODEL_NAME` (ex.: `deepseek-coder`, `phi3-mini`, `gpt-4o`)
  - `TIMESTAMP`
  - `PROMPT_FILE` e `RESULT_FILE`
  - `REVIEW_STATUS` (`pending`, `approved`, `rejected`)
- O registro completo deve ser exportado automaticamente para `docs/reports/audit-report.md` ao término de cada execução.
- A auditoria dessas execuções ocorre:
  - Automaticamente via GitHub Actions (`audit.yml`).
  - Mensalmente pela equipe de governança, com relatório formal arquivado no repositório.
  - Sempre que houver uma nova versão de agente ou modelo, garantindo verificação extraordinária.

## 🔹 Conformidade com Requisitos, Riscos e Relatórios
- O catálogo de requisitos oficial está em `docs/02-planejamento/especificacao-de-requisitos.md`; qualquer alteração funcional, técnica ou legal deve atualizar o documento e citar o ID `REQ-###` correspondente nos PRs e relatórios.
- A matriz de riscos mantida em `docs/02-planejamento/riscos-e-mitigacoes.md` precisa ser revisada sempre que novos riscos forem identificados ou mitigados; agents devem registrar decisões e apontar `RISK-###` nos metadados exportados.
- O guia de relatórios automatizados vive em `docs/06-governanca-tecnica-e-controle-de-qualidade/auditoria-e-rastreabilidade.md#catalogo-de-relatorios-automatizados`; ajustes em pipelines ou geração de artefatos devem manter a tabela atualizada e sincronizar gatilhos com `revisoes-com-ia.md`.
- O plano da capacidade de diagnóstico colaborativo está em `docs/02-planejamento/capacidade-diagnostico-colaborativo.md`; mantenha os requisitos `REQ-031` a `REQ-045` sincronizados com riscos e relatórios antes de alterar fluxos ou pipelines.
- Nenhum agente pode excluir ou mover esses arquivos sem confirmar que todas as referências na req e nos diretórios `docs/reports/` foram ajustadas e auditadas pelo pipeline `audit.yml`.

## 🔹 Como usar a integração com o GitHub no ambiente Codex
- **Variáveis padrão:** o ambiente Codex já fornece `GH_TOKEN`, `GH_REPO_SLUG` e derivações (`GITHUB_TOKEN`, `GITHUB_PERSONAL_ACCESS_TOKEN`). Sempre valide a presença delas antes de executar qualquer script.
- **Bootstrap do GitHub CLI:** execute `bash scripts/bootstrap-gh.sh` assim que iniciar a sessão. O script instala/configura o `gh`, propaga as credenciais para o `git` via `gh auth setup-git` e valida o acesso ao repositório informado em `GH_REPO_SLUG`.
- **Uso do `gh`:**
  - Para repositórios sem remote configurado, utilize `gh repo view "$GH_REPO_SLUG"` ou adicione um remote (`git remote add origin ...`) antes de usar comandos que dependam do contexto Git.
  - Use `gh auth status` para confirmar a autenticação; ele deve indicar a conta associada ao `GH_TOKEN` já exportado pelo ambiente.
- **Servidor MCP do GitHub:**
  - Inicie ou reinstale com `bash scripts/mcp-github/mcp-bootstrap.sh`. O script cuida da instalação do Go, clona `github-mcp-server` em `/workspace`, compila o binário e inicia o serviço no modo `stdio`.
  - Verifique o log `/tmp/github-mcp.log` e confirme a mensagem `GitHub MCP Server running on stdio`. O processo ativo é registrado em `/tmp/github-mcp.pid`.
  - Sempre confira se o diretório `/workspace/github-mcp-server` existe antes de rodar tarefas que dependam do MCP; se estiver ausente, execute o bootstrap novamente.
- **Diagnóstico rápido:**
  - Se qualquer comando `go` ou `git` solicitar credenciais, assegure-se de que `GIT_TERMINAL_PROMPT=0` e `GIT_ASKPASS` estão exportados (ambos configurados pelos scripts acima).
  - Utilize `gh auth refresh -h "$GH_HOST" -s repo -s read:org -s workflow` caso o token tenha mudado e necessite atualizar os escopos de forma não interativa.
- **Execução coordenada:** antes de iniciar fluxos que combinam `gh` e MCP, rode os dois scripts de bootstrap para garantir ambiente consistente, e registre falhas ou saídas relevantes nos changelogs apropriados.

## 🔹 Padrões Éticos e de Segurança
- Todos os agentes devem obedecer simultaneamente às seguintes diretrizes:
  - LGPD (Lei 13.709/2018): é proibido o uso, armazenamento ou persistência de dados pessoais em execuções automatizadas.
  - Políticas da Chrome Web Store ou marketplace correspondente: nenhuma alteração pós-publicação é autorizada sem aprovação prévia da governança técnica.
  - Políticas de uso dos provedores de IA aprovados: conteúdos sensíveis, discriminatórios ou fora dos termos de serviço são proibidos.
- Nenhum agente pode modificar ou acessar dados de produção; todas as execuções ocorrem em ambientes isolados (local, HML ou CI) e monitorados.

## 🔹 Tabela de Versionamento dos Agentes
| Agente | Versão | Modelo | Última Atualização | Status |
| --- | --- | --- | --- | --- |
| Codex Builder | 1.0.0 | gpt-4o | [gerar via CI] | Ativo |
| Codex Reviewer | 1.0.0 | deepseek-coder | [gerar via CI] | Ativo |
| Scope Corrector | 1.0.0 | phi-3-mini | [gerar via CI] | Ativo |
| Architecture Corrector | 1.0.0 | gpt-4o | [gerar via CI] | Ativo |
| E2E Test Agent | 1.0.0 | starcoder2-3b | [gerar via CI] | Ativo |
| Audit Agent | 1.0.0 | deepseek-coder | [gerar via CI] | Ativo |

## 🔹 Referência de Responsabilidade Técnica
**Responsável técnico:** consulte `docs/06-governanca-tecnica-e-controle-de-qualidade/governanca-tecnica.md` para o quadro atualizado.
**Documento:** `AGENTS.md` (versão expandida com governança)
**Integrações:** GitHub Actions e demais pipelines aprovados pela governança técnica
**Status:** Ativo e sob revisão contínua

## ✅ Verificação final de conformidade
| Critério | Situação |
| --- | --- |
| Conteúdo existente preservado | ✅ Garantido |
| Expansão apenas incremental | ✅ Aplicado |
| Compatibilidade com o plano | ✅ Total |
| Regras éticas e LGPD incluídas | ✅ Cumpridas |
| Integração CI / GitHub Actions | ✅ Detalhada |
| Nenhuma alucinação factual | ✅ Confirmado |

---

# English Governance Documentation / Documentação de Governança em Inglês

> This section contains English-language governance documentation for AI agents, tools, and workflows.  
> Esta seção contém documentação de governança em inglês para agentes de IA, ferramentas e fluxos de trabalho.

---

# Agents and Tools

## Core Tools
- **opencode**: CLI tool for software engineering tasks (e.g., code analysis, linting)
- **act**: Simulates GitHub Actions locally for workflows

## Governance Agents

### **Governance Agent**
- **Purpose**: Apply governance focused on workflow independence and fixture isolation
- **Scope**: Ensures workflows remain generic and self-contained
- **Key Rules**: 
  - Workflow independence (no project-specific dependencies)
  - Fixture isolation (self-contained mock projects)
  - Dynamic detection and fallback mechanisms

### **File Creation Governance Agent**
- **Purpose**: Control and authorize all file creation/modification operations by AI agents
- **Scope**: Prevent unauthorized file creation outside approved plans, issues, or explicit prompts
- **Key Rules**:
  - Files can only be created if listed in governance plans (`CHANGELOG/*-plan.md`)
  - Files can only be created if described in approved issues
  - Files can only be created if explicitly requested in user prompts
  - All operations must comply with `.github/agents/agent-files-structure.md`
- **Reference**: See `.github/agents/agent-governance.md` for complete rules

### **GitHub Actions Agent**
- **Purpose**: Comprehensive GitHub Actions and workflow validation including independence principles
- **Scope**: Workflow structure, language, execution patterns, and independence validation
- **Responsibilities**:
  - Validate workflow structure and best practices
  - Ensure workflow independence and generic behavior
  - Validate generic fallback mechanisms
  - Ensure cross-project compatibility
  - Analyze workflow dependencies
  - Validate CLI orchestration and modular design
- **Key Rules**:
  - Bash-only scripts (no Python)
  - Inline scripts (no external .sh files)
  - Triple execution pattern (dispatch/call/CLI)
  - Dynamic tool detection
  - Generic fallback mechanisms
  - Fixture isolation
  - **Exceptions**: Deploy and CLI workflows may have repository-specific dependencies
- **Reference**: See `.github/agents/agent-actions.md` for complete policies

## Repository Principles

### **Workflow Independence**
- Workflows must be project-agnostic
- Never assume specific project structures
- Create generic fallback mechanisms
- Use fixtures only for testing, not as dependencies

### **Fixture Isolation**
- Fixtures are mock projects for workflow testing ONLY
- Keep configurations within fixture directories
- Create workarounds locally when needed
- No cross-pollution with main repository

### **Error Handling and Observability**

All error messages and critical exceptions must follow a structured format with four mandatory components:

1. **[ERRO NATIVO]**: The native error message from framework/service/library
2. **[MOTIVO]**: Business context - what the system was trying to do
3. **[AÇÃO DESENVOLVEDOR]**: What to change in code/config (with file/variable/function references)
4. **[SUPORTE USUÁRIO]**: What to inform the client (no internal details, secrets, or endpoints)

**Mandatory log format:**

```
================================================================================
[DATA/HORA]: <ISO-8601>
[ERRO NATIVO]: <native message>
[MOTIVO]: <context>
[AÇÃO DESENVOLVEDOR]: <actionable steps>
[SUPORTE USUÁRIO]: <client-facing message>
[STACK TRACE]: <stack>
================================================================================
```

For complete policies and examples, see [.github/agents/agent-error-message.md](.github/agents/agent-error-message.md).

### **⚠️ Fixtures are Out of Scope / Fixtures Fora do Escopo**

Para regras detalhadas sobre fixtures, veja `.github/agents/agent-actions.md` seção "Fora do Escopo: Fixtures".

**Resumo**: NÃO é responsabilidade deste repositório melhorar ou corrigir projetos no diretório `fixtures/`. Se workflows falharem com fixtures, corrija o workflow para ser mais genérico, não os fixtures.

## File Creation and Modification Restrictions

### ⚠️ **Mandatory Authorization for File Operations**

**⚠️ CRITICAL RULE: Nenhum agente de IA, automação ou action pode criar ou modificar arquivos neste repositório EXCETO se o recurso:**

1. **Estiver claramente listado em plano(s) de governança aprovados** (`CHANGELOG/*-plan.md`)
2. **Estiver explicitamente descrito em uma issue aprovada e aberta**
3. **For explicitamente solicitado em comando de usuário** (prompt direto)

**Se NENHUM critério for atendido: PARE imediatamente e solicite aprovação explícita do usuário.**

### Validation Requirements

Antes de criar ou modificar qualquer arquivo, agentes de IA DEVEM:

- ✅ Verificar se o arquivo está mencionado em plano de governança
- ✅ Verificar se existe issue aberta solicitando o arquivo
- ✅ Verificar se o usuário solicitou explicitamente no prompt
- ✅ Validar conformidade com a estrutura de diretórios (`.github/agents/agent-files-structure.md`)
- ⚠️ Se nenhum critério for atendido: **PARAR e solicitar aprovação explícita**

### Exception Handling

**Qualquer exceção a estas regras deve ser precedida pela aprovação de uma issue específica antes da execução.**

Quando um agente identificar necessidade de criar arquivo não previsto:
1. **PARAR** a execução
2. **INFORMAR** ao usuário sobre a necessidade
3. **SOLICITAR** aprovação explícita ou criação de issue
4. **AGUARDAR** autorização antes de prosseguir

### Reference Documentation

> **Toda automação e agentes inteligentes devem seguir `.github/agents/agent-governance.md` como base do controle de escrita.**

Para regras completas e exemplos detalhados, consulte:
- **`.github/agents/agent-governance.md`** - Regras completas de autorização
- **`.github/agents/agent-files-structure.md`** - Estrutura de diretórios aprovada
- **`opencode.json`** - Configuração de agentes e comandos

## Configuration Files / Arquivos de Configuração

### **Modular Instruction Files**

The `.github/instructions/` directory contains modular instruction files for AI agents:

| File | Purpose | Related Agents |
|------|---------|----------------|
| [.github/instructions/governance.instructions.md](.github/instructions/governance.instructions.md) | File authorization and workflow independence | `governance` |
| [.github/instructions/copilot-workflow.instructions.md](.github/instructions/copilot-workflow.instructions.md) | AI agent CLI workflow (explore → plan → review → implement → verify → commit) | `governance`, `general` |
| [.github/instructions/instructions.bash.md](.github/instructions/instructions.bash.md) | Bash scripting policies and best practices | `bash` |

**Discovery Pattern:**
- AI agent CLIs automatically read instructions from `.github/instructions/**/*.instructions.md`
- These files provide focused, modular guidance for specific domains
- They complement the detailed policies in `.github/agents/agent-*.md`

### **opencode.json** — Configuration Schema Compliance

The `opencode.json` file complies with OpenCode's official schema (`https://opencode.ai/config.json`) and contains **executable configuration only**, not documentation.

**Current Structure:**

```json
{
  "$schema": "https://opencode.ai/config.json",
  "agent": {
    "general": { "description": "...", "prompt": "..." },
    "governance": { "description": "...", "prompt": "..." },
    "workflow_independence": { "reference": "...", "prompt": "..." },
    "error_handling": { "reference": "...", "prompt": "..." },
    "actions": { "reference": "...", "prompt": "..." },
    "bash": { "reference": "...", "prompt": "..." },
    "docker_stack": { "reference": "...", "prompt": "..." },
    "yml_structure": { "reference": "...", "prompt": "..." }
  },
  "command": {
    "gov/pending": { ... },
    "actions/review": { ... },
    "error/review": { ... },
    ...
  }
}
```

**Key Principles:**
- **Prompts are brief** (≤10 lines) with references to detailed `.md` files
- **No metadata duplication** - documentation lives in `.md` files, not in JSON
- **Reference field** points to `.github/agents/agent-*.md` for complete policies

### **Agent Reference Files**

All agent reference files are located in `.github/agents/` with the naming pattern `agent-*.md`:

| File | Purpose | OpenCode Agent |
|------|---------|----------------|
| [.github/agents/agent-error-message.md](.github/agents/agent-error-message.md) | Error messaging and observability standards | `general`, `error_handling` |
| [.github/agents/agent-governance.md](.github/agents/agent-governance.md) | Governance with file authorization and workflow independence | `governance` |
| [.github/agents/agent-trigger-workflows.md](.github/agents/agent-trigger-workflows.md) | Workflow independence guidelines | `workflow_independence` |
| [.github/agents/agent-actions.md](.github/agents/agent-actions.md) | GitHub Actions policies and standards | `actions` |
| **[.github/agents/agent-bash.md](.github/agents/agent-bash.md)** | **Bash scripting policies and best practices - ALWAYS follow these policies for any Bash script, including HEREDOC prohibition** | `bash` |
| [.github/agents/agent-docker-stack.md](.github/agents/agent-docker-stack.md) | Docker structure compliance standards | `docker_stack` |
| [.github/agents/agent-yml-structure.md](.github/agents/agent-yml-structure.md) | YAML structure policies | `yml_structure` |
| [.github/agents/agent-files-structure.md](.github/agents/agent-files-structure.md) | Repository file structure organization rules | N/A |

> **⚠️ CRITICAL: All agents MUST follow [agent-bash.md](.github/agents/agent-bash.md) policies when writing any Bash script, including the strict prohibition of HEREDOC.**

**Usage Pattern:**
- Read `AGENTS.md` (this file) for overview and quick reference
- Consult specific `.github/agents/agent-*.md` for detailed policies
- **ALWAYS consult [agent-bash.md](.github/agents/agent-bash.md) before writing any Bash script**
- Use OpenCode commands (defined in `opencode.json`) to invoke agents

### **OpenCode Agent Configuration**

Each agent in `opencode.json` is configured with:
- **description**: Brief one-line description (1-2 lines max)
- **reference**: Path to detailed policy file in `.github/agents/`
- **prompt**: Executive summary (10 lines max) + reference to .md file
- **mode**: `primary` or `subagent`

**Key principle:** `opencode.json` contains configuration, not documentation.  
For policies and rules, always refer to the `.md` files.

## Usage Examples

### OpenCode Commands

Commands are defined in `opencode.json` under the `command` section and can be invoked via OpenCode:

```bash
# Governance cycle for workflow independence
opencode /gov/pending  # Register independence issues
opencode /gov/plan     # Plan improvements
opencode /gov/conclude # Document achievements

# AI agent CLI workflow guidance
opencode /copilot/workflow  # Guide through explore → plan → review → implement → verify → commit workflow

# Workflow validation
opencode /workflow/check  # Validate workflow independence
opencode /fixture/isolate # Create isolated fixture workarounds

# Engineering compliance reviews
opencode /actions/review  # Review GitHub Actions workflows
opencode /bash/review     # Review Bash scripts
opencode /docker/review   # Review Docker structures
opencode /yaml/review     # Review YAML files
opencode /error/review    # Review error handling and observability
```

### Manual Workflow Testing

```bash
# Test with multiple fixtures (for independence validation)
act -W .github/workflows/sonarq.yml --input-path fixtures/ui
act -W .github/workflows/sonarq.yml --input-path fixtures/api
act -W .github/workflows/sonarq.yml --input-path fixtures/db
```

## Key Differences from Traditional Governance

### **Traditional Approach**
- Focus on standardizing specific projects
- Hard-coded configurations and paths
- Assumed project structure and dependencies

### **New Approach**
- Focus on workflow genericity and independence
- Dynamic detection and adaptation
- Project-agnostic implementation

## Documentation Hierarchy

This repository follows a clear documentation hierarchy to avoid duplication and maintain consistency:

```
AGENTS.md (This File)
├── Overview and quick reference
├── Repository principles
├── Available agents with links to detailed policies
└── Usage examples

.github/agents/*.md
├── Complete technical policies (source of truth)
├── Validation commands
├── Examples
└── Checklists

opencode.json
├── Executable configuration
├── Agent definitions (brief description + reference)
└── Command definitions
```

**Cross-Reference Pattern:**
1. **Start here (AGENTS.md)** for overview and agent catalog
2. **Consult .github/agents/*.md** for detailed policies and rules
3. **Use opencode.json commands** to invoke agents via CLI
4. **Refer back to .md files** when policies need clarification

---

**Remember**: This repository's primary purpose is **workflow solutions testing**, not ensuring specific projects work perfectly. The fixtures are **mocks for testing workflow genericity**.
