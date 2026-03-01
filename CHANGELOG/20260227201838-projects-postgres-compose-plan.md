<!-- CHANGELOG/20260227201838-projects-postgres-compose-plan.md -->
# Plano - Docker Compose Projects PostgreSQL

**Data/Hora UTC:** 2026-02-27 20:18:38  
**Responsável:** Agent  
**Tipo:** Plano de Implementação

---

## Objetivo

Criar infraestrutura Docker para subir todas as 26 APIs geradas para PostgreSQL com um único servidor de banco de dados.

---

## Arquivos a Criar

| Arquivo | Descrição |
|---------|-----------|
| `.docker/docker-compose.projects.postgres.yml` | Compose com PostgreSQL + serviço de APIs |
| `.docker/Dockerfile.projects.postgres` | Dockerfile base Node.js |
| `.docker/entrypoint.projects.postgres.sh` | Script de entrada (descoberta dinâmica) |

---

## Especificações do Entrypoint

### 1. Descoberta de Bancos (DDL + SQL)

- Diretório: `test/e2e-generator/projects/*/db/`
- Ordem: Alfabética
- Para cada projeto:
  - Ler `database.postgres.ddl` (se existir)
  - Criar banco de dados (se não existir)
  - Executar DDL
  - Executar `database.postgres.sql` (se existir)

### 2. Descoberta de APIs NestJS

- Diretório: `output/*/postgres/`
- Ordem: Alfabética
- Para cada projeto:
  - `npm install --legacy-peer-deps`
  - `npm run build`
  - Executar `node dist/main.js &` com porta sequencial

### 3. Portas (3001-3026)

accounts→3001, addresses→3002, auth→3003, communications→3004, config→3005, consents→3006, contacts→3007, gmail→3008, google-calendar→3009, google-drive→3010, llm→3011, logistics→3012, maps→3013, notifications→3014, orders→3015, payments→3016, products→3017, reports→3018, roles→3019, schedule→3020, selling→3021, tenant→3022, todo→3023, transactions→3024, users→3025, warehouse→3026

---

## Regras Aplicadas

- Não modifica arquivos existentes
- Segue padrão de Dockerfiles em `.docker/`
- Reutiliza DDls/SQLs de `test/e2e-generator/projects/`
- Reutiliza projetos gerados em `output/*/postgres/`

---

## Auditoria Prevista

- [ ] Executar `make projects-up` e verificar 26 bancos criados
- [ ] Verificar logs das 26 APIs
- [ ] Testar health check em cada porta (3001-3026)

---

## Comandos Resultantes

```bash
make projects-up      # Sobe PostgreSQL + todas as APIs
make projects-down    # Desce todos os serviços
make projects-logs    # Logs de todos os serviços
```

---

## Resultado

**Status:** ✅ Implementado

---

## Auditoria

### Verificações Realizadas
- ✅ Sintaxe Makefile: `make -n projects-up` executa corretamente
- ✅ Estrutura de arquivos criada conforme especificação
- ✅ Correção de bug no caminho do SQL (linha 34 do entrypoint)
- ✅ Porta 5432 para PostgreSQL
- ✅ Portas 3001-3026 para APIs

### Pendente
- Execução completa: `make projects-up`
- Verificação de 26 bancos criados no PostgreSQL
- Teste de health check em cada porta
