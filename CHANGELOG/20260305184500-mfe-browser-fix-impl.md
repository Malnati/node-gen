<!-- CHANGELOG/20260305184500-mfe-browser-fix-impl.md -->
# 2026-03-05 18:45:00 UTC - Implementação do plano de correção de MFE no navegador

## Referências de plano
- CHANGELOG/20260305170000-service-discovery-mfe-browser-fix-plan.md
- CHANGELOG/20260305180000-mfe-browser-fix-plan.md

## Arquivos alterados
- .docker/docker-compose.projects.postgres.yml
- demo/service-discovery/src/main.ts

## Implementação executada
- Corrigida a inconsistência de bundle no `DISCOVERY_APPS_JSON` em `.docker/docker-compose.projects.postgres.yml`, trocando `main.js` por `spa.js` para addresses, contacts e orders.
- Adicionada a variável `DISCOVERY_USE_LOCALHOST` no serviço `service-discovery` do compose, com padrão `${DISCOVERY_USE_LOCALHOST:-true}`.
- Implementada no `demo/service-discovery/src/main.ts` a leitura de `DISCOVERY_USE_LOCALHOST` e bypass da função `rewriteImportUrlForRequest` quando a flag estiver ativa, evitando reescrita para IP público no contexto do navegador.

## Comandos executados
- `ls -la CHANGELOG`
- `sed -n '1,220p' CHANGELOG/20260305170000-service-discovery-mfe-browser-fix-plan.md`
- `sed -n '1,240p' CHANGELOG/20260305180000-mfe-browser-fix-plan.md`
- `git status --short`
- `rg -n "main\\.js|spa\\.js|DISCOVERY_APPS_JSON" .docker/docker-compose.projects.postgres.yml`
- `rg -n "rewriteImportUrlForRequest|DISCOVERY_USE_LOCALHOST|host\\.docker\\.internal|importUrl" demo/service-discovery/src/main.ts`
- `sed -n '1,220p' .docker/docker-compose.projects.postgres.yml`
- `sed -n '1,320p' demo/service-discovery/src/main.ts`
- `sed -n '320,420p' demo/service-discovery/src/main.ts`
- `make demo-pg-up`
- `git diff -- .docker/docker-compose.projects.postgres.yml demo/service-discovery/src/main.ts`

## Resultado resumido
- Implementação: **passou** (alterações aplicadas conforme plano).
- Validação automatizada completa (`make demo-pg-up`): **falhou parcialmente** por motivo objetivo não introduzido neste ajuste: build do `contact-mfe` interrompido com `Could not resolve entry module "src/spa.ts"` durante `npm run build` do Dockerfile gerado.

## Definição de pronto (planos)
- [x] Diagnosticar causa raiz do erro de carregamento no navegador (mantida conforme plano 20260305180000).
- [x] Corrigir inconsistência `main.js` vs `spa.js` no compose.
- [x] Adicionar opção para impedir reescrita para IP público (`DISCOVERY_USE_LOCALHOST`).
- [ ] Validar ciclo completo de subida e carga no navegador (bloqueado por falha pré-existente de build em `contact-mfe`).

## Pendências
- Investigar e corrigir a ausência de `src/spa.ts` no `contact-mfe` para restabelecer a validação fim a fim do cenário de navegador.
