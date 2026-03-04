<!-- CHANGELOG/20260304201444-demo-compose-dynamic-apps-plan.md -->
# Plano - demo service-discovery + demo sspa + inicializacao dinamica de apps

## Data/Hora UTC
2026-03-04T20:14:44Z

## 1. Arquivos existentes relevantes para o escopo
- `.docker/Dockerfile.sspa`
- `.docker/docker-compose.projects.postgres.yml`
- `test/e2e-generator/projects/*`
- `demo/service-discovery/package.json`
- `demo/service-discovery/tsconfig.json`
- `demo/service-discovery/src/main.ts`
- `demo/service-discovery/src/contracts.ts`
- `demo/sspa/package.json`
- `demo/sspa/vite.config.ts`
- `demo/sspa/index.html`
- `demo/sspa/src/root-config.ts`
- `demo/sspa/src/dashboard.tsx`
- `demo/sspa/src/main.tsx`
- `Makefile`
- `CHANGELOG/20260304180439-demo-sspa-discovery-dinamico-plan.md`
- `CHANGELOG/20260304180439-demo-sspa-discovery-dinamico-audit.md`
- `CHANGELOG/20260304190932-service-discovery-manifesto-dir-plan.md`
- `CHANGELOG/20260304190932-service-discovery-manifesto-dir-audit.md`

## 2. Arquivos que serao alterados
- `.docker/Dockerfile.service-discovery` (novo)
- `.docker/Dockerfile.demo` (novo)
- `.docker/docker-compose.demo.yml` (novo)
- `demo/demo-start-apps.sh` (novo)
- `Makefile`
- `CHANGELOG/20260304201444-demo-compose-dynamic-apps-plan.md`
- `CHANGELOG/20260304201444-demo-compose-dynamic-apps-audit.md`

## 3. Lista combinada de requisitos (especificos + globais)
- Criar `.docker/Dockerfile.service-discovery` para construir o app `demo/service-discovery`.
- Criar `.docker/Dockerfile.demo` para construir o app `demo/sspa`.
- Criar `.docker/docker-compose.demo.yml` para subir `service-discovery` e `sspa` juntos.
- Disponibilizar fluxo de inicializacao dinamica de apps gerados em `<target>`, com descoberta por diretorios que contenham `Dockerfile`.
- Suportar prefixos distintos para apps NestJS e React em `<target>/<prefix><name>`.
- Definir portas de exposicao unicas por app descoberto (incrementais a partir de porta inicial configuravel).
- Criar o script Shell (Bash) em `demo/demo-start-apps.sh` para varredura do `<target>`, build e start dinamico dos apps descobertos.
- Orientar migracao de referencias de origem de projetos de `test/e2e-generator/projects` para `projects/` na raiz.
- Adicionar entrada `demo-start-apps` no `Makefile` para executar a inicializacao dinamica.
- Adicionar entradas de `Makefile` para subir/parar/logs da stack demo (`service-discovery` + `sspa`) via compose demo.
- Adicionar entradas por projeto/banco no `Makefile`: `demo-pg-<project>`, `demo-sqlite-<project>`, `demo-sqlserver-<project>` e `demo-mysql-<project>`.
- Cada entrada `demo-*` deve executar o fluxo:
- subir somente o banco referente ao tipo informado;
- carregar somente o projeto informado, validando antes se ja esta em execucao e se a carga ja foi aplicada;
- gerar API em `demo/projects/<db>/<project>/api`;
- gerar MFE application em `demo/projects/<db>/<project>/app`;
- executar `demo/demo-start-apps.sh`;
- executar `.docker/docker-compose.demo.yml` somente se ainda nao estiver em execucao.
- Manter escopo cirurgico: sem criar jobs/pipelines/servicos fora do pedido.
- Preservar rastreabilidade completa em `CHANGELOG/` com plano e auditoria irmaos.

## 4. Requisitos nao atendidos no inicio do ciclo
- Nao existe `.docker/Dockerfile.service-discovery`.
- Nao existe `.docker/Dockerfile.demo`.
- Nao existe `.docker/docker-compose.demo.yml`.
- Nao existe entrada `demo-start-apps` no `Makefile`.
- Nao existe o script `demo/demo-start-apps.sh`.
- Nao existe fluxo versionado para descoberta automatica de apps em diretorio configuravel por variavel de ambiente.
- Nao existe padrao de targets `demo-<db>-<project>` no `Makefile`.
- Referencias ainda apontam para `test/e2e-generator/projects` em vez de `projects/`.

## 5. Lista combinada de regras (especificas + globais)
- Implementar somente os artefatos do escopo solicitado (dockerfiles demo, compose demo e targets no `Makefile`).
- Respeitar o padrao de comentarios de caminho no topo dos novos arquivos.
- Manter compose sem atributo `version`.
- Parametrizar configuracoes por variaveis de ambiente no formato `${VAR:-default}` no compose.
- Executar fluxos operacionais do projeto por alvos do `Makefile`.
- O fluxo dinamico deve ser implementado no script `demo/demo-start-apps.sh` e invocado via alvo `demo-start-apps` no `Makefile`.
- Atualizar referencias de origem de projetos para `projects/` na raiz e eliminar dependencia de `test/e2e-generator/projects` no fluxo demo.
- Seguir exatamente o fluxo operacional definido para targets `demo-<db>-<project>`, incluindo checks idempotentes de banco/carga/compose.
- Nao expor segredos/tokens/chaves.
- Registrar evidencias (arquivos, comandos, status) no arquivo de auditoria irmao.

## 6. Regras nao atendidas que motivam os ajustes
- Ausencia dos Dockerfiles e do compose demo impede subir `service-discovery` e `sspa` em stack propria.
- Ausencia de alvo `demo-start-apps` impede operacionalizar descoberta dinamica de apps gerados no fluxo padrao do repositorio.
- Nao ha hoje fluxo formal para alocacao automatica de portas por aplicacao descoberta em `<target>`.
- Nao existem targets padronizados para execucao da demo por projeto e banco.
- Caminho de origem dos projetos no fluxo atual nao segue a diretriz de uso de `projects/` na raiz.

## 7. Plano de auditoria (manual + automatico)
1. Validar criacao dos arquivos: `rg --files .docker | rg "Dockerfile\\.service-discovery|Dockerfile\\.demo|docker-compose\\.demo\\.yml"`.
2. Validar sintaxe e servicos do compose demo: `rg -n "services:|service-discovery|sspa|ports:|build:" .docker/docker-compose.demo.yml -S`.
3. Validar targets no `Makefile`: `rg -n "demo-start-apps|demo-up|demo-down|demo-logs|docker-compose\\.demo\\.yml" Makefile -S`.
4. Validar existencia do script: `test -f demo/demo-start-apps.sh`.
5. Validar parametros esperados do fluxo dinamico no script: `rg -n "TARGET_DIR|START_PORT|NEST_PREFIX|REACT_PREFIX|CURRENT_PORT" demo/demo-start-apps.sh -S`.
6. Validar que `demo-start-apps` chama o script: `rg -n "demo-start-apps|demo/demo-start-apps\\.sh" Makefile -S`.
7. Validar targets por banco/projeto no `Makefile`: `rg -n "demo-pg-|demo-sqlite-|demo-sqlserver-|demo-mysql-" Makefile -S`.
8. Validar atualizacao de referencias para raiz `projects/`: `rg -n "test/e2e-generator/projects|projects/" Makefile demo -S`.
9. Validar destinos de geracao do fluxo demo: `rg -n "demo/projects/.*/.*/api|demo/projects/.*/.*/app|demo/projects/" Makefile -S`.
10. Registrar no `-audit`:
- arquivos alterados;
- comandos executados;
- resultado por criterio (PASSOU/FALHOU);
- pendencias objetivas, se houver.

## 8. Selecao de checklists aplicaveis
- `docs/checklists/` nao possui arquivos no estado atual.
- Checklist obrigatorio transversal aplicado:
- plano + auditoria em `CHANGELOG/` com mesmo prefixo de timestamp;
- rastreabilidade por secoes 1..8;
- escopo restrito aos artefatos solicitados no pedido.

## Referencias cruzadas
- Auditoria irma: `CHANGELOG/20260304201444-demo-compose-dynamic-apps-audit.md`
- Plano relacionado anterior: `CHANGELOG/20260304180439-demo-sspa-discovery-dinamico-plan.md`
- Evolucao relacionada: `CHANGELOG/20260304190932-service-discovery-manifesto-dir-plan.md`
