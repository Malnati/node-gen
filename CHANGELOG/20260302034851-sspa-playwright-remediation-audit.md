<!-- CHANGELOG/20260302034851-sspa-playwright-remediation-audit.md -->
# Auditoria 2026-03-02 03:48:51 UTC - Remediação SSPA + Playwright

## Escopo auditado
- Fluxo `make playwright-test` com rebuild do SSPA.
- Geração de `projects.json` no SSPA.
- Cobertura Playwright para dashboard/menu/cards e fluxo principal sem `404` no orquestrador.

## Verificações manuais previstas
- `http://localhost:9000` exibe dashboard com menu lateral e cards.
- Interação de menu/card leva à tela de entidade.

## Verificações automáticas previstas
- `make playwright-test` conclui.
- Geração de artefatos de teste em disco.
- Falha explícita caso o orquestrador responda `404` no fluxo principal.

## Comandos de auditoria
- `make playwright-clean`
- `make projects-down`
- `make playwright-test`
- `docker compose -f .docker/docker-compose.projects.postgres.yml logs --tail=200 sspa apis`

## Critérios de aceite
- Passa: testes Playwright sem erro, sem `404` no fluxo principal do orquestrador e artefatos gerados.
- Falha: qualquer quebra do fluxo acima, com motivo objetivo registrado no changelog de implementação.

## Referências cruzadas
- Plano: `/root/w/node-gen/CHANGELOG/20260302034851-sspa-playwright-remediation-plan.md`
- Implementação: `/root/w/node-gen/CHANGELOG/20260302034851-sspa-playwright-remediation-impl.md`
