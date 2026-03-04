# Plano: Testes Playwright para SSPA

## Data/Hora
2026-03-02T03:07:13Z

## Escopo
Criar testes Microsoft Playwright para o container SSPA que sobe o orquestrador. Cobrir exibição do dashboard e acesso de cada item e sub-item de menu, tanto pelo menu lateral quanto pelos cards do dashboard. Reports e logs devem ser registrados em disco a cada execução.

---

## Requisitos do Usuário

1. **Container SSPA**: Subir o orquestrador
2. **Dashboard**: Testar exibição dos cards de projetos
3. **Menu**: Testar itens principais e sub-itens
4. **Cards**: Testar expansão e navegação
5. **Reports/Logs**: Salvar em disco a cada execução

---

## 1. Arquivos Existentes Relevantes

- `/root/w/node-gen/.docker/Dockerfile.sspa` — Dockerfile do orquestrador
- `/root/w/node-gen/.docker/docker-compose.projects.postgres.yml` — Compose
- `/root/w/node-gen/output/` — Projetos gerados

---

## 2. Arquivos a Criar

- `playwright.config.ts` — Configuração Playwright
- `test/sspa.spec.ts` — Testes principais
- `package.json` — Dependências (se necessário)

---

## 3. Estrutura dos Testes

### 3.1 Testes Principais

```typescript
// Testes:
// 1. Dashboard loads with projects
// 2. Menu displays all project items
// 3. Card expansion shows entities
// 4. Menu sub-items navigate correctly
// 5. Entity page loads with table
// 6. CRUD buttons are present
```

### 3.2 Relatórios

- `playwright-report/` — HTML report
- `playwright-results/` — JSON results  
- Screenshots em `test-results/`

---

## 4. Checklist

- [ ] playwright.config.ts configurado
- [ ] Teste: Dashboard exibe projetos
- [ ] Teste: Menu lateral funciona
- [ ] Teste: Cards expandem
- [ ] Teste: Navegação por menu
- [ ] Teste: Navegação por cards
- [ ] Teste: Página de entidade carrega
- [ ] Teste: Botões CRUD presentes
- [ ] Reports salvos em disco

---

## Referências

- Dockerfile: `/root/w/node-gen/.docker/Dockerfile.sspa`
- Compose: `/root/w/node-gen/.docker/docker-compose.projects.postgres.yml`
