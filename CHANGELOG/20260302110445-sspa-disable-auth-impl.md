<!-- CHANGELOG/20260302110445-sspa-disable-auth-impl.md -->
# Implementação 2026-03-02 11:04:45 UTC - Desabilitar Autenticação JWT no SSPA

## Arquivos alterados
- `.docker/docker-compose.projects.postgres.yml`
- `.docker/entrypoint.projects.postgres.sh`

## Mudanças implementadas
- Adicionado `E2E_SKIP_JWT: "true"` no docker-compose.yml (serviço apis)
- Adicionado `E2E_SKIP_JWT=true` no entrypoint.sh (variáveis .env.local e linha de comando)

## Comandos executados
- `make projects-down`
- `make projects-up`

## Resultado resumido
- **PASSOU**: APIs respondem sem autenticação
- Testado: `curl http://localhost:3001/account` retorna dados JSON corretamente
- Testado: `curl http://localhost:3002/country` retorna países
- Testado: `curl http://localhost:3025/users` retorna usuários

## Definição de pronto
- [x] Variável E2E_SKIP_JWT configurada em docker-compose.yml
- [x] Variável E2E_SKIP_JWT configurada em entrypoint.sh
- [x] Containers reiniciados com nova configuração
- [x] APIs respondem sem autenticação (verificado via curl)
