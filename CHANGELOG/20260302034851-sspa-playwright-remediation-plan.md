<!-- CHANGELOG/20260302034851-sspa-playwright-remediation-plan.md -->
# Plano 2026-03-02 03:48:51 UTC - Remediação SSPA + Playwright

## 1. Arquivos existentes relevantes
- `/root/w/node-gen/Makefile`
- `/root/w/node-gen/playwright.config.ts`
- `/root/w/node-gen/test/sspa.spec.ts`
- `/root/w/node-gen/.docker/Dockerfile.sspa`
- `/root/w/node-gen/CHANGELOG/20260302023157-sspa-orchestrator-plan.md`
- `/root/w/node-gen/CHANGELOG/20260302030713-playwright-sspa-plan.md`
- `/root/w/node-gen/CHANGELOG/20260302030713-playwright-sspa-impl.md`

## 2. Arquivos que serão alterados
- `/root/w/node-gen/Makefile`
- `/root/w/node-gen/playwright.config.ts`
- `/root/w/node-gen/test/sspa.spec.ts`
- `/root/w/node-gen/.docker/Dockerfile.sspa`
- `/root/w/node-gen/CHANGELOG/20260302034851-sspa-playwright-remediation-audit.md`
- `/root/w/node-gen/CHANGELOG/20260302034851-sspa-playwright-remediation-impl.md`

## 3. Requisitos combinados da mudança e globais
- Executar Playwright via Makefile contra o SSPA do `projects-up`.
- Persistir logs e relatórios de testes em disco.
- Cobrir dashboard com menu e cards, e fluxo de navegação principal.
- Corrigir regressão onde a página inicial mostra lista simples com links quebrados (`404`).
- Ler planos/changelogs recentes para conformidade com o dashboard esperado.
- Registrar trilha em CHANGELOG com rastreabilidade.

## 4. Requisitos não atendidos que o plano resolve
- `make playwright-test` falha por ausência de `@playwright/test` no ambiente local.
- Container SSPA servido sem dashboard planejado (menu/cards).
- Navegação principal observada com erro `404` no NGINX.
- Ausência de log textual consolidado da execução Playwright.

## 5. Regras combinadas da mudança e globais
- Escopo cirúrgico: apenas arquivos necessários.
- Sem novas dependências além do que já está declarado.
- Sem criação de scripts shell novos.
- Cabeçalhos de caminho preservados.
- Evidências obrigatórias em CHANGELOG com comandos e resultado.

## 6. Regras não atendidas que motivam ajustes
- Cobertura Playwright não estava validando de forma determinística o fluxo real do orquestrador.
- Fluxo de teste não garantia rebuild da imagem SSPA, permitindo imagem desatualizada.

## 7. Plano de auditoria
- Executar `make playwright-clean`.
- Executar `make projects-down`.
- Executar `make playwright-test`.
- Verificar artefatos `playwright-report/index.html`, `playwright-results/results.json`, `playwright-results/playwright-run.log`.
- Validar endpoint raiz `http://localhost:9000` e ausência de 404 no fluxo principal validado pelos testes.
- Registrar evidências e status no arquivo de auditoria irmão.

## 8. Checklists aplicáveis
- `docs/checklists/`: não encontrado no estado atual do repositório.
- Checklist obrigatório aplicado nesta entrega: validação manual + validação automática com Playwright + registro de evidências em CHANGELOG.

## Referências cruzadas
- Auditoria: `/root/w/node-gen/CHANGELOG/20260302034851-sspa-playwright-remediation-audit.md`
- Implementação: `/root/w/node-gen/CHANGELOG/20260302034851-sspa-playwright-remediation-impl.md`
