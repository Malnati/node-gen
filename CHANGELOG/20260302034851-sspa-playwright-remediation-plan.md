<!-- CHANGELOG/20260302034851-sspa-playwright-remediation-plan.md -->
# Plano 2026-03-02 04:53:40 UTC - Remediação SSPA + Playwright (Revisão 2)

## 1. Arquivos existentes relevantes
- `/root/w/node-gen/Makefile`
- `/root/w/node-gen/playwright.config.ts`
- `/root/w/node-gen/test/sspa.spec.ts`
- `/root/w/node-gen/.docker/Dockerfile.sspa`
- `/root/w/node-gen/.docker/docker-compose.projects.postgres.yml`
- `/root/w/node-gen/CHANGELOG/20260302023157-sspa-orchestrator-plan.md`
- `/root/w/node-gen/CHANGELOG/20260302030248-sspa-dashboard-plan.md`
- `/root/w/node-gen/CHANGELOG/20260302030713-playwright-sspa-plan.md`
- `/root/w/node-gen/CHANGELOG/20260302030713-playwright-sspa-impl.md`
- `/root/w/node-gen/CHANGELOG/20260302034851-sspa-playwright-remediation-impl.md`
- `/root/w/node-gen/CHANGELOG/20260302035000-sspa-validate-impl.md`

## 2. Arquivos que serão alterados
- `/root/w/node-gen/Makefile`
- `/root/w/node-gen/playwright.config.ts`
- `/root/w/node-gen/test/sspa.spec.ts`
- `/root/w/node-gen/.docker/Dockerfile.sspa`
- `/root/w/node-gen/.docker/docker-compose.projects.postgres.yml`
- `/root/w/node-gen/CHANGELOG/20260302034851-sspa-playwright-remediation-audit.md`
- `/root/w/node-gen/CHANGELOG/20260302034851-sspa-playwright-remediation-impl.md`

## 3. Requisitos combinados da mudança e globais
- Ler os planos/changelogs mais recentes do SSPA e aplicar a conformidade do dashboard planejado (menu + cards + navegação).
- Executar os testes Playwright via Makefile contra o orquestrador real iniciado por `make projects-up`.
- Coletar e manter logs de execução dos testes Playwright e logs de containers utilizados no fluxo.
- Corrigir falhas encontradas, incluindo `404` nos links principais (`/accounts/` e similares) e ausência de cards/menu.
- Validar o fluxo completo com `make projects-up` seguido de testes Playwright por Makefile.
- Manter a restrição explícita da tarefa: não criar e não excluir arquivos; apenas alterar arquivos existentes.
- Registrar evidências de execução, falhas e correções no changelog de implementação já existente.

## 4. Requisitos não atendidos que o plano resolve
- O orquestrador atualmente apresenta HTML simples com lista de links, sem o dashboard planejado com cards e menu.
- A navegação dos links principais retorna `404` no NGINX e há erros de recurso não carregado no navegador.
- Os cards esperados não estão sendo renderizados e o menu não está em conformidade com o plano mais recente.
- Falta evidência consolidada de logs Playwright e logs dos serviços no mesmo ciclo de execução do `projects-up`.

## 5. Regras combinadas da mudança e globais
- Escopo cirúrgico: apenas arquivos necessários.
- Sem criar novos arquivos e sem excluir arquivos existentes.
- Sem novas dependências além do que já está declarado, salvo necessidade estritamente bloqueante comprovada na execução.
- Sem criação de scripts shell novos.
- Cabeçalhos de caminho preservados.
- Evidências obrigatórias em CHANGELOG com comandos e resultado.
- Executar a validação com comandos já padronizados no Makefile (`projects-up`, `playwright-test`, `projects-down`).

## 6. Regras não atendidas que motivam ajustes
- Entrega validada anteriormente como "funcionando" não refletiu o comportamento real esperado do dashboard do orquestrador.
- Cobertura de testes atual não protege adequadamente contra regressão de roteamento/serving do SSPA em ambiente real do `projects-up`.

## 7. Plano de auditoria
- Executar `make projects-down` para iniciar com ambiente limpo.
- Executar `make projects-up` e validar disponibilidade do orquestrador em `http://localhost:9000`.
- Executar `make playwright-test` focado no fluxo SSPA do orquestrador.
- Coletar logs em disco:
  - `playwright-report/index.html`
  - `playwright-results/results.json`
  - `playwright-results/playwright-run.log`
  - `docker compose -f .docker/docker-compose.projects.postgres.yml logs --tail=400 sspa apis`
- Confirmar no teste automatizado e na validação manual:
  - dashboard com menu e cards conforme plano;
  - links principais sem `404`;
  - carregamento mínimo das rotas críticas (ex.: accounts, addresses, auth).
- Registrar resultado final (passou/falhou) e motivo objetivo no changelog de implementação.

## 8. Checklists aplicáveis
- `docs/checklists/`: não encontrado no estado atual do repositório.
- Checklist obrigatório aplicado nesta entrega: validação manual + validação automática com Playwright + registro de evidências em CHANGELOG + conferência explícita da restrição "sem criar/excluir arquivos".

## Referências cruzadas
- Auditoria: `/root/w/node-gen/CHANGELOG/20260302034851-sspa-playwright-remediation-audit.md`
- Implementação: `/root/w/node-gen/CHANGELOG/20260302034851-sspa-playwright-remediation-impl.md`
