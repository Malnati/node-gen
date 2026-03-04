<!-- CHANGELOG/20260302023157-sspa-orchestrator-impl.md -->
# Changelog: Orquestrador Single-SPA (SSPA)

## Data/Hora
2026-03-02T02:31:57Z

## Entrega
Implementação do orquestrador SSPA que exibe todos os MFEs gerados e aponta para as APIs.

---

## Arquivos Alterados

### `/root/w/node-gen/.docker/docker-compose.projects.postgres.yml`
- Adicionado serviço `sspa` que sobe na porta 9000
- depends_on no serviço `apis` para garantir ordem de inicialização

### `/root/w/node-gen/.docker/Dockerfile.sspa` (Novo)
- Dockerfile para construir imagem do orquestrador SSPA
- Usa nginx para servir página com lista de MFEs
- Gera index.html dinamicamente com MFEs encontrados em /mfe-output

---

## Arquivos Criados (Infraestrutura)

### `/root/w/node-gen/gen/sspa` (symlink)
- Symlink para `gen/static-mfe/app-shell/`
- Reutiliza estrutura existente do app-shell

---

## Como Funciona

1. Ao executar `make projects-up`, o docker-compose sobe:
   - `postgres-shared` - Banco de dados PostgreSQL
   - `apis` - Todas as APIs NestJS
   - `sspa` - Orquestrador SSPA na porta 9000

2. O orquestrador SSPA:
   - Lê os diretórios em `/mfe-output/*/mfe`
   - Gera index.html listando todos os MFEs disponíveis
   - Cada MFE aponta para sua API

---

## Uso

```bash
# Subir todos os serviços (incluindo SSPA)
make projects-up

# Acessar o orquestrador
# http://localhost:9000
```

---

## Status
✅ Implementado
