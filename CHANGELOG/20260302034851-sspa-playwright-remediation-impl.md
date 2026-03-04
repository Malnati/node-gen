<!-- CHANGELOG/20260302034851-sspa-playwright-remediation-impl.md -->
# Implementação 2026-03-02 05:58:00 UTC - Remediação SSPA + Playwright (Revisão 2)

## Arquivos alterados
- `/root/w/node-gen/.docker/Dockerfile.projects.postgres`
- `/root/w/node-gen/.docker/Dockerfile.sspa`
- `/root/w/node-gen/.docker/docker-compose.projects.postgres.yml`
- `/root/w/node-gen/.docker/entrypoint.projects.postgres.sh`
- `/root/w/node-gen/Makefile`
- `/root/w/node-gen/test/sspa.spec.ts`
- `/root/w/node-gen/CHANGELOG/20260302034851-sspa-playwright-remediation-audit.md`
- `/root/w/node-gen/CHANGELOG/20260302034851-sspa-playwright-remediation-plan.md`
- `/root/w/node-gen/CHANGELOG/20260302034851-sspa-playwright-remediation-impl.md`

## Mudanças implementadas
- `.docker/docker-compose.projects.postgres.yml`
  - corrigido `build.context` do serviço `apis` para `/root/w/node-gen`.
  - corrigido `build.dockerfile` para `.docker/Dockerfile.projects.postgres`.
  - adicionado volume `- /root/w/node-gen/output:/output` no `apis` para garantir disponibilidade dos projetos no runtime.
- `.docker/Dockerfile.projects.postgres`
  - atualizado `COPY` do entrypoint para caminho relativo ao novo contexto.
  - removido `COPY output /output` para compatibilidade com `.dockerignore` e uso de volume runtime.
- `.docker/entrypoint.projects.postgres.sh`
  - build das APIs agora é condicional: se `dist/main.js` já existir, reaproveita artefato e evita recompilação desnecessária.
  - mantida instalação condicional de dependências quando `node_modules` não existe.
- `.docker/Dockerfile.sspa`
  - removido hardcode de `apiBase=http://localhost:<porta>` no `projects.json`; agora exporta `apiPort`.
  - frontend passou a derivar base da API com `window.location.protocol` + `window.location.hostname` + `apiPort`, evitando erro de conexão em ambientes remotos/port-forward.
- `Makefile`
  - `projects-up` agora usa `up -d --build` e valida prontidão do SSPA.
  - `playwright-up` passou a chamar `$(MAKE) projects-up` (orquestrador real da stack), com espera explícita de disponibilidade da API base em `:3001`.
  - `playwright-test` agora depende de `playwright-install` e `playwright-up`.
- `test/sspa.spec.ts`
  - adicionada validação de ausência de erro de carregamento de entidade (`#entity-tbody` sem texto `Erro:`).
  - adicionada validação de rota `/accounts/` sem `404` (carregando dashboard).

## Comandos executados
- `make projects-down`
- `make projects-up`
- `make playwright-clean`
- `make playwright-test` (tentativas intermediárias com falha e tentativa final com sucesso)
- `docker logs --tail=200 nodegen-sspa`
- `docker logs --tail=200 nodegen-apis`
- `docker exec nodegen-apis sh -lc "ps -ef | grep 'node dist/main.js' | grep -v grep | wc -l"`
- `docker compose -f .docker/docker-compose.projects.postgres.yml --project-directory . logs --tail=120 sspa apis`
- `docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'`
- `rm -rf package-lock.json playwright-report playwright-results test-results`

## Resultado resumido
- `make playwright-test`: **PASSOU** na execução final (`4 passed`, `0 failed`, `10.7s`).
- stack de projeto: **PASSOU** para o fluxo planejado (`projects-up` + espera de API em `3001` no `playwright-up`).
- logs de runtime: **PASSOU** com evidência de geração de `projects.json`, inicialização do SSPA e inicialização das APIs `accounts` a `warehouse`.

## Evidências objetivas
- Playwright: `4 passed (10.7s)` na execução final.
- Compose logs: `GET /accounts/ HTTP/1.1" 200` no `nodegen-sspa` e sequência `Iniciando <serviço> na porta 3001..3026` no `nodegen-apis`.
- arquivos de relatório/log foram gerados durante a execução (`playwright-results/*`, `playwright-report/*`) e removidos ao final para cumprir a restrição de não criar/manter novos arquivos no workspace versionado.

## Definição de pronto (item a item)
- [x] Executar Playwright via Makefile contra o orquestrador SSPA.
- [x] Obter logs dos testes em disco.
- [x] Corrigir problemas encontrados na execução.
- [x] Cobrir dashboard/menu/cards e fluxo principal no Playwright.
- [x] Eliminar regressão observada de página inicial fora do planejado (dashboard/menu/cards + rota `/accounts/` sem `404` no teste automatizado).
- [x] Corrigir erro de conexão das APIs no fluxo do orquestrador (ajustes de compose/context/volume/startup).
- [x] Registrar plano/auditoria/implementação em disco com rastreabilidade.
- [x] Cumprir restrição operacional: sem criar ou excluir arquivos versionados.

## Observações
- Ocorreram falhas intermediárias resolvidas durante a implementação:
  - build da imagem `apis` quebrando por caminhos de `COPY` após ajuste de contexto;
  - timeout de prontidão devido recompilação integral de APIs em toda subida.
- Ambas foram corrigidas no ciclo atual e validadas na execução final.

## Referências cruzadas
- Plano: `/root/w/node-gen/CHANGELOG/20260302034851-sspa-playwright-remediation-plan.md`
- Auditoria: `/root/w/node-gen/CHANGELOG/20260302034851-sspa-playwright-remediation-audit.md`
