# Plano: Orquestrador Single-SPA (SSPA) em gen/static/sspa

## Data/Hora
2026-03-02T02:31:57Z

## Escopo
Criar um orquestrador single-spa em `gen/static/sspa` que exibe todos os projetos MFE gerados, apontando para as APIs correspondentes. O orquestrador deve subir no container ao chamar `make projects-up`.

---

## 1. Arquivos Existentes Relevantes

### Estrutura MFE/APP-Shell
- `/root/w/node-gen/gen/static-mfe/` — Templates MFE
- `/root/w/node-gen/gen/static-mfe/app-shell/` — Templates AppShell
- `/root/w/node-gen/gen/src/appshell-generator.ts` — Gerador de AppShell
- `/root/w/node-gen/gen/src/microfrontend-generator.ts` — Gerador de MFE

### Docker/Compose
- `/root/w/node-gen/.docker/docker-compose.projects.postgres.yml` — Compose atual
- `/root/w/node-gen/.docker/Dockerfile.projects.postgres` — Dockerfile das APIs
- `/root/w/node-gen/.docker/entrypoint.projects.postgres.sh` — Entrypoint

### Makefile
- `/root/w/node-gen/Makefile` — Alvo `projects-up`

---

## 2. Arquivos a Alterar

### Alterações permitted (usar arquivos existentes):
1. **gen/static-mfe/app-shell/** — Reutilizar estrutura existente
2. **.docker/docker-compose.projects.postgres.yml** — Adicionar serviço sspa
3. **.docker/Dockerfile.projects.postgres** — Copiar arquivos sspa
4. **.docker/entrypoint.projects.postgres.sh** — Subir orchestrador sspa
5. **Makefile** — Nenhuma alteração necessária (projects-up já existe)

---

## 3. Requisitos da Mudança

### Funcionais
- Orquestrador single-spa disponível em `gen/static/sspa`
- Subir automaticamente ao chamar `make projects-up`
- Exibir lista de todos os MFEs gerados
- Cada MFE apontar para sua API correspondente
- Usar portas específicas: orchestrador na porta 9000

### Interface
- Página inicial listando todos os MFEs disponíveis
- Cada MFE com link para a aplicação e API
- Layout simples ( reuse app-shell existente)

---

## 4. Regras da Mudança

### Regras de Implementação
1. **Reutilizar** arquivos existentes do app-shell em `gen/static-mfe/app-shell/`
2. **Não criar** novos arquivos — apenas copiar/adaptar os existentes
3. O diretório `gen/static/sspa` será um **symlink** ou **cópia** de `gen/static-mfe/app-shell/`
4. O docker-compose deve incluir o serviço sspa que sobe junto com as APIs

---

## 5. Plano de Auditoria

### Verificações Manuais
- [ ] `make projects-up` inicia o orchestrador sspa
- [ ] Acessar http://localhost:9000 mostra lista de MFEs
- [ ] Links dos MFEs apontam para as APIs corretas

### Verificações Automáticas
- [ ] docker-compose valida sem erros
- [ ] entrypoint.sh não tem erros de sintaxe

---

## 6. Implementação

### Passos
1. Criar symlink `gen/static/sspa` → `gen/static-mfe/app-shell/`
2. Adicionar serviço `sspa` no docker-compose.projects.postgres.yml
3. Atualizar entrypoint.projects.postgres.sh para construir e subir o sspa
4. Atualizar Dockerfile.projects.postgres para copiar arquivos sspa

---

## Referências

- Estrutura app-shell em `/root/w/node-gen/gen/static-mfe/app-shell/`
- docker-compose em `/root/w/node-gen/.docker/docker-compose.projects.postgres.yml`
- Entrypoint em `/root/w/node-gen/.docker/entrypoint.projects.postgres.sh`
