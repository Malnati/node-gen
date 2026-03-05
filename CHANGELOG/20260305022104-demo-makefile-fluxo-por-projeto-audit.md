<!-- CHANGELOG/20260305022104-demo-makefile-fluxo-por-projeto-audit.md -->
# Auditoria - plano de fluxo Makefile por projeto para API + MFE com publicacao no demo

## Data/Hora UTC
2026-03-05T02:21:04Z

## Plano relacionado
- `CHANGELOG/20260305022104-demo-makefile-fluxo-por-projeto-plan.md`

## Escopo auditado
- Revisao dos planos anteriores sobre demo dinamico, compose demo e alvos `demo-*`.
- Identificacao do ponto exato onde ja existe solicitacao para criar alvos por projeto no `Makefile`.
- Consolidacao das pendencias tecnicas e de governanca que bloqueiam o fluxo completo.
- Validacao de aderencia do novo plano ao padrao 1..8 e rastreabilidade em `CHANGELOG/`.

## Onde ja existe "prompt" para criacao dos alvos solicitados
- `CHANGELOG/20260304201444-demo-compose-dynamic-apps-plan.md` (Secao 3):
- "Adicionar entradas por projeto/banco no `Makefile`: `demo-pg-<project>`, `demo-sqlite-<project>`, `demo-sqlserver-<project>` e `demo-mysql-<project>`."
- "Cada entrada `demo-*` deve gerar API em `demo/projects/<db>/<project>/api`."
- "Cada entrada `demo-*` deve gerar MFE application em `demo/projects/<db>/<project>/app`."
- "Cada entrada `demo-*` deve executar `demo/demo-start-apps.sh`."
- `CHANGELOG/20260304201444-demo-compose-dynamic-apps-audit.md`:
- confirma que esse requisito foi planejado e permaneceu pendente de implementacao tecnica.

## Matriz de criterios do planejamento atual
- [x] Novo plano criado com secoes obrigatorias 1..8. **PASSOU**
- [x] Auditoria irma criada com mesmo prefixo de timestamp. **PASSOU**
- [x] Pendencias dos planos anteriores registradas explicitamente no novo plano. **PASSOU**
- [x] Requisito de "um alvo por projeto no Makefile" implementado para `demo-pg-<project>`. **PASSOU**
- [x] Alvos globais `demo-up`, `demo-down` e `demo-logs` implementados no `Makefile`. **PASSOU**
- [x] Encadeamento por projeto para gerar API + MFE application e subir demo. **PASSOU**
- [x] Escopo restrito ao fluxo solicitado (Makefile + compose/demo). **PASSOU**
- [x] Riscos tecnicos relevantes (conflito de porta 3015) registrados. **PASSOU**
- [x] Conflito de governanca (novo `.sh` vs politica de automacao) registrado. **PASSOU**

## Arquivos criados/alterados no ciclo
- `Makefile`
- `.docker/Dockerfile.service-discovery`
- `.docker/Dockerfile.demo`
- `.docker/docker-compose.demo.yml`
- `CHANGELOG/20260305022104-demo-makefile-fluxo-por-projeto-plan.md`
- `CHANGELOG/20260305022104-demo-makefile-fluxo-por-projeto-audit.md`

## Comandos executados
1. `ls -1 CHANGELOG | sort`
2. `rg -n "plan|audit|sspa|service-discovery|Makefile|api \\+ mfe|mfe|publicar|publish|demo/sspa|demo/service-discovery" CHANGELOG -S`
3. `cat .github/copilot-instructions.md`
4. `cat opencode.json`
5. `sed -n '1,260p' CHANGELOG/20260304201444-demo-compose-dynamic-apps-plan.md`
6. `sed -n '1,260p' CHANGELOG/20260304201444-demo-compose-dynamic-apps-audit.md`
7. `sed -n '1,260p' CHANGELOG/20260304180439-demo-sspa-discovery-dinamico-plan.md`
8. `sed -n '1,260p' CHANGELOG/20260304190932-service-discovery-manifesto-dir-plan.md`
9. `sed -n '1,260p' CHANGELOG/20260304115247-makefile-gen-project-pg-plan.md`
10. `date -u +%Y%m%d%H%M%S`
11. `rg -n "^demo-(up|down|logs):|^demo-pg-[a-z0-9-]+:|^gen-[a-z0-9-]+-pg-mfe-app:" Makefile -S`
12. `make -pn | rg -n "^demo-pg-[a-z0-9-]+:" -S`
13. `sed -n 's/^E2E_PROJECTS_LIST := //p' Makefile | wc -w`
14. `make -pn | rg '^demo-pg-[a-z0-9-]+:' -c`
15. `make -n demo-pg-addresses`
16. `rg --files .docker | rg "Dockerfile\\.service-discovery|Dockerfile\\.demo|docker-compose\\.demo\\.yml"`
17. `rg -n "define compose_demo|docker-compose\\.demo\\.yml|^demo-(up|down|logs):" Makefile -S`
18. `make -n demo-up`

## Resultado resumido dos comandos
- Revisao de planos/auditorias relacionada ao demo e Makefile: **PASSOU**.
- Identificacao do prompt previo para alvos por projeto: **PASSOU**.
- Criacao do novo plano consolidado com pendencias: **PASSOU**.
- Implementacao dos alvos `demo-up`, `demo-down`, `demo-logs` e `demo-pg-<project>` no `Makefile`: **PASSOU**.
- Validacao de cobertura dos alvos por projeto (`E2E_PROJECTS_LIST=26`, `demo-pg-*=26`): **PASSOU**.
- Dry-run do fluxo (`make -n demo-pg-addresses`) exibindo encadeamento API + MFE + demo: **PASSOU**.
- Criacao do compose demo dedicado e Dockerfiles de build (`.docker/docker-compose.demo.yml`, `.docker/Dockerfile.service-discovery`, `.docker/Dockerfile.demo`): **PASSOU**.
- Dry-run de `demo-up` apontando para compose dedicado: **PASSOU**.

## Pendencias objetivas para o proximo ciclo de implementacao
- Definir estrategia sem novo script `.sh` para start dinamico de apps (conformidade com politica vigente).
- Resolver explicitamente a estrategia de portas para evitar conflito com `3015` quando coexistirem stacks.

## Referencias cruzadas
- Plano atual: `CHANGELOG/20260305022104-demo-makefile-fluxo-por-projeto-plan.md`
- Plano anterior com requisito dos alvos demo por projeto: `CHANGELOG/20260304201444-demo-compose-dynamic-apps-plan.md`
- Auditoria anterior com pendencia de implementacao: `CHANGELOG/20260304201444-demo-compose-dynamic-apps-audit.md`
