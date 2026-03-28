<!-- CHANGELOG/20260305022104-demo-makefile-fluxo-por-projeto-plan.md -->
# Plano - fluxo Makefile por projeto para API + MFE com publicacao no demo (sspa + service-discovery)

## Data/Hora UTC
2026-03-05T02:21:04Z

## 1. Lista de arquivos existentes relevantes para o escopo
- `Makefile`
- `demo/sspa/package.json`
- `demo/service-discovery/package.json`
- `demo/service-discovery/src/main.ts`
- `.docker/docker-compose.projects.postgres.yml`
- `CHANGELOG/20260304201444-demo-compose-dynamic-apps-plan.md`
- `CHANGELOG/20260304201444-demo-compose-dynamic-apps-audit.md`
- `CHANGELOG/20260304180439-demo-sspa-discovery-dinamico-plan.md`
- `CHANGELOG/20260304190932-service-discovery-manifesto-dir-plan.md`
- `CHANGELOG/20260304204111-makefile-e2e-project-path-fix.md`

## 2. Lista de arquivos que serao alterados
- `Makefile`
- `.docker/docker-compose.demo.yml` (novo)
- `.docker/Dockerfile.service-discovery` (novo)
- `.docker/Dockerfile.demo` (novo)
- `CHANGELOG/20260305022104-demo-makefile-fluxo-por-projeto-plan.md`
- `CHANGELOG/20260305022104-demo-makefile-fluxo-por-projeto-audit.md`

## 3. Lista combinada de requisitos da mudanca especifica e requisitos globais
- Criar fluxo operacional exclusivamente por `Makefile` para gerar API + MFE application por projeto e publicar no `demo/sspa` com `demo/service-discovery`.
- Garantir um alvo por projeto no `Makefile`, no padrao `demo-pg-<project>`, para todos os itens de `E2E_PROJECTS_LIST`.
- Encadear no alvo por projeto: geracao API PostgreSQL + geracao MFE application + publicacao no ambiente demo.
- Criar alvos globais de stack demo no `Makefile` (`demo-up`, `demo-down`, `demo-logs`) usando compose dedicado.
- Manter a regra de execucao operacional somente por `Makefile` (sem execucao direta de `npm`, `docker`, `docker compose` fora de alvo).
- Preservar escopo cirurgico sem refatoracoes amplas e sem dependencias novas.
- Registrar rastreabilidade integral em `CHANGELOG/` com plano e auditoria irmaos.

## 4. Lista de requisitos atualmente nao atendidos que o plano busca resolver
- Nao existe alvo no `Makefile` para subir/operar o servidor demo real (`demo/sspa` + `demo/service-discovery`).
- Nao existe alvo por projeto no `Makefile` para o fluxo demo completo (gerar API + gerar MFE application + publicar no demo).
- O fluxo atual de `projects-up` publica apenas o orquestrador dockerizado em `.docker/sspa`, nao o app em `demo/sspa`.
- Nao existe compose dedicado para o demo real em `demo/`.
- Nao existe rastreabilidade de execucao do plano `20260304201444` (permanece apenas planejado/auditado, sem implementacao tecnica).

## 5. Lista combinada de regras da mudanca especifica e regras globais do projeto
- Implementar apenas arquivos estritamente necessarios para o fluxo solicitado.
- Nao criar scripts `.sh` novos para automacao de fluxo (politica global do repositorio).
- Manter comentarios de caminho no topo dos novos arquivos.
- Manter compose sem atributo `version`.
- Parametrizar configuracoes via `${VAR:-default}`.
- Preservar a regra obrigatoria do SSPA (`SSPA_SKIP_AUTH=true`) e do backend (`E2E_SKIP_JWT=true`) quando aplicavel.
- Nao alterar banco/API fora do escopo de orquestracao do fluxo solicitado.

## 6. Lista de regras atualmente nao atendidas que motivam os ajustes
- Plano anterior (`20260304201444`) preve `demo/demo-start-apps.sh`, em conflito com a politica vigente que proibe novos scripts shell para automacoes do projeto.
- Nao ha alvos `demo-*` implementados no `Makefile` apesar de ja existirem como requisito em plano anterior.
- Nao ha composicao formalizada para o demo real em `demo/` sob controle de `Makefile`.
- Ha risco conhecido de conflito de portas na stack postgres (`3015`) registrado em `20260304204111`, exigindo definicao explicita no compose demo.

## 7. Plano de auditoria descrevendo verificacoes manuais e automaticas previstas
1. Validar criacao de compose demo e Dockerfiles: `rg --files .docker | rg "docker-compose\\.demo\\.yml|Dockerfile\\.service-discovery|Dockerfile\\.demo"`.
2. Validar alvos demo no `Makefile`: `rg -n "^demo-(up|down|logs):|^demo-pg-" Makefile -S`.
3. Validar um alvo por projeto (todos de `E2E_PROJECTS_LIST`): `for p in $$(sed -n 's/^E2E_PROJECTS_LIST := //p' Makefile); do rg -n "^demo-pg-$$p:" Makefile -S || exit 1; done`.
4. Validar encadeamento do alvo por projeto para API + MFE application + publish demo: `rg -n "gen-.*-pg-api|gen-.*-pg-(mfe|app)|demo-up|service-discovery|demo/sspa" Makefile -S`.
5. Validar ausencia de novos scripts shell fora de entrypoints Docker: `rg --files | rg "\\.sh$"`.
6. Validar que a operacao do fluxo ocorre apenas via alvos `make` (sem instrucoes operacionais diretas fora de alvo).
7. Registrar em `-audit`: arquivos alterados, comandos executados, matriz PASSOU/FALHOU por criterio e pendencias remanescentes.

## 8. Selecao dos checklists em `docs/checklists/` aplicaveis ao contexto
- Nao foram encontrados arquivos em `docs/checklists/` no estado atual.
- Checklist transversal obrigatorio aplicado: plano + auditoria irmaos com mesmo prefixo de timestamp.
- Checklist transversal obrigatorio aplicado: secoes 1..8 completas e rastreabilidade por referencias cruzadas.
- Checklist transversal obrigatorio aplicado: escopo restrito a Makefile/orquestracao demo sem expansao arquitetural indevida.

## Pendencias identificadas na revisao dos planos anteriores
- `CHANGELOG/20260304201444-demo-compose-dynamic-apps-plan.md`: implementacao tecnica pendente (o proprio `-audit` registrou esta pendencia).
- `CHANGELOG/20260304201444-demo-compose-dynamic-apps-plan.md`: requisito de `demo/demo-start-apps.sh` conflita com a politica atual de proibicao de novos scripts shell.
- `CHANGELOG/20260304204111-makefile-e2e-project-path-fix.md`: conflito de porta `3015` entre `apis` e `service-discovery` precisa ser tratado no desenho final do compose demo.
- Ausencia de alvo por projeto no `Makefile` para publicar no demo real (`demo/sspa` + `demo/service-discovery`), embora ja exista diretriz de implementacao em ciclos anteriores.

## Referencias cruzadas
- Auditoria irma: `CHANGELOG/20260305022104-demo-makefile-fluxo-por-projeto-audit.md`
- Plano relacionado: `CHANGELOG/20260304201444-demo-compose-dynamic-apps-plan.md`
- Auditoria relacionada: `CHANGELOG/20260304201444-demo-compose-dynamic-apps-audit.md`
- Plano relacionado: `CHANGELOG/20260304180439-demo-sspa-discovery-dinamico-plan.md`
- Plano relacionado: `CHANGELOG/20260304190932-service-discovery-manifesto-dir-plan.md`
- Evidencia de risco: `CHANGELOG/20260304204111-makefile-e2e-project-path-fix.md`
