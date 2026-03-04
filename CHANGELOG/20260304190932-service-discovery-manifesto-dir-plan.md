<!-- CHANGELOG/20260304190932-service-discovery-manifesto-dir-plan.md -->
# Plano - service discovery por manifesto em diretorio e fechamento de pendencias

## Data/Hora UTC
2026-03-04T19:09:32Z

## 1. Lista de arquivos existentes relevantes para o escopo
- `demo/service-discovery/src/main.ts`
- `demo/service-discovery/src/contracts.ts`
- `demo/service-discovery/package.json`
- `.docker/docker-compose.projects.postgres.yml`
- `gen/src/main.ts`
- `gen/src/microfrontend-generator.ts`
- `gen/src/appshell-generator.ts`
- `gen/src/mfe-parcel-paging-generator.ts`
- `gen/src/sspa-static-assets-generator.ts`
- `gen/templates/*.ejs` (templates recentemente introduzidos para interpolacao)
- `Makefile`
- `CHANGELOG/20260304182202-service-discovery-runtime-discovery-404.md`
- `CHANGELOG/20260304182546-compose-service-discovery-env-example.md`
- `CHANGELOG/20260304185131-review-interpolacao-static-template-plan.md`
- `CHANGELOG/20260304185131-review-interpolacao-static-template-audit.md`
- `CHANGELOG/20260304190638-implementacao-interpolacao-static-template.md`

## 2. Lista de arquivos que serao alterados
- `CHANGELOG/20260304190932-service-discovery-manifesto-dir-plan.md`
- `CHANGELOG/20260304190932-service-discovery-manifesto-dir-audit.md`

## 3. Lista combinada de requisitos da mudanca especifica e requisitos globais
- Registrar plano para resolver pendencias abertas dos ciclos anteriores (validacao de geracao/execucao via alvos existentes do `Makefile`).
- Definir arquitetura alvo do discovery baseada em manifesto de disco, com diretorio parametrizado por variavel de ambiente (exemplo: `output/mfe/apps`).
- Formalizar que o serviço deve descobrir apps por configuracoes explicitas em arquivos (manifestos JSON), sem varredura de rede nem busca de processos.
- Definir comportamento esperado quando nao houver manifesto/app valido: lista vazia para colecoes, `404` para busca pontual por app.
- Definir caminho evolutivo para padrao push (API de registro/import-map deployer) para ambientes de producao, mantendo compatibilidade com pull por disco em ambiente local.
- Manter `gen/src/main.ts` como orquestrador, sem adicionar responsabilidades indevidas.
- Manter escopo restrito, sem adicionar pipelines/jobs/dependencias sem solicitacao explicita.
- Registrar rastreabilidade integral em `CHANGELOG/`.

## Formalizacao objetiva deste ciclo
- Estrategia principal aprovada: leitura de manifestos em diretorio configuravel por variavel de ambiente (`DISCOVERY_APPS_DIR`, exemplo `output/mfe/apps`).
- Estrategia proibida: varredura de rede, portas, containers ou processos para inferir aplicacoes.
- Fechamento do ciclo anterior: pendencias de diretriz arquitetural de discovery ficam encerradas com este plano e sua auditoria irma.
- Evolucao futura prevista: modo push por API de registro (estilo import-map deployer) para producao, mantendo compatibilidade com pull por manifesto em ambiente local.

## 4. Lista de requisitos atualmente nao atendidos que o plano busca resolver
- Nao existe ainda observacao de diretorio de manifesto no `demo/service-discovery`; o fluxo atual depende de JSON em variavel de ambiente.
- Nao ha especificacao fechada de contrato de manifesto em disco (campos obrigatorios, validacao e erros).
- Nao ha implementacao do modo push (registro via API) documentada como etapa posterior controlada.
- Pendencias de validacao final por alvos do `Makefile` permanecem em aberto no ciclo de interpolacao (`CHANGELOG/20260304190638-implementacao-interpolacao-static-template.md`).

## 5. Lista combinada de regras da mudanca especifica e regras globais do projeto
- Discovery deve priorizar configuracao explicita por manifesto em disco (`.env` -> compose -> aplicacao), com diretorio via variavel de ambiente.
- E proibido adotar varredura de processos/rede como mecanismo primario de descoberta.
- Em ausencia de app/manifesto valido: retornar resposta deterministica (`[]` nas colecoes, `404` em endpoint por nome).
- Alteracoes devem permanecer em arquivos necessarios (service-discovery, compose/env, templates/geradores se exigido).
- Nao incluir segredos, nao expandir arquitetura fora do escopo, nao adicionar scripts shell.
- Manter evidencias de comandos/resultados e criterios no arquivo de auditoria.

## 6. Lista de regras atualmente nao atendidas que motivam os ajustes
- A cadeia de configuracao para discovery por diretorio (`.env` -> compose -> app) ainda nao esta implementada.
- Nao existe politica consolidada de prioridade de fontes de discovery (manifesto de disco vs fallback controlado).
- Nao existe auditoria de execucao por `Makefile` para fechar o ciclo anterior de migracao de interpolacoes.

## 7. Plano de auditoria descrevendo verificacoes manuais e automaticas previstas
1. Verificar configuracao de diretorio por env em compose/servico (`DISCOVERY_APPS_DIR` ou equivalente) e consumo no codigo.
2. Validar leitura de manifestos JSON em diretorio configurado, com filtro de arquivos invalidos.
3. Validar contratos:
- `GET /api/discovery/applications` retorna lista agregada dos manifestos validos;
- `GET /api/discovery/import-map` reflete somente apps validas;
- `GET /api/discovery/applications/:name` retorna `404` se nao encontrada.
4. Validar ausencia de qualquer logica de varredura de rede/processos no discovery.
5. Validar pendencias anteriores com comandos via `Makefile` aplicaveis ao fluxo de geracao/execucao.
6. Registrar matriz PASSOU/FALHOU por criterio no arquivo `-audit`.
7. Registrar pendencias remanescentes e proximo ciclo (especialmente modo push por API/import-map-deployer).

## 8. Selecao dos checklists em `docs/checklists/` aplicaveis ao contexto
- Nao foram encontrados arquivos em `docs/checklists/` no estado atual.
- Checklist transversal obrigatorio aplicado:
- plano e auditoria irmaos com prefixo unico em `CHANGELOG/`;
- secoes 1..8 completas;
- escopo limitado e rastreabilidade com referencias cruzadas;
- definicao explicita de estrategia recomendada (manifesto em disco) e estrategia desencorajada (scan de rede/processos).

## Decisao arquitetural deste plano
- Abordagem principal aprovada: discovery por manifesto de disco em diretorio configuravel por variavel de ambiente.
- Abordagem explicitamente desencorajada: descoberta por varredura de rede ou busca de processos.
- Evolucao recomendada para producao: modo push por API de registro (estilo import-map deployer), mantendo consistencia de contratos.

## Referencias cruzadas
- Auditoria irma: `CHANGELOG/20260304190932-service-discovery-manifesto-dir-audit.md`
- Pendencias de validacao: `CHANGELOG/20260304190638-implementacao-interpolacao-static-template.md`
- Descoberta atual por env JSON: `CHANGELOG/20260304182202-service-discovery-runtime-discovery-404.md`
- Compose de exemplo atual: `CHANGELOG/20260304182546-compose-service-discovery-env-example.md`
