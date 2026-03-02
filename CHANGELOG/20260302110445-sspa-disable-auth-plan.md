<!-- CHANGELOG/20260302110445-sspa-disable-auth-plan.md -->
# Plano 2026-03-02 11:04:45 UTC - Desabilitar Autenticação JWT no SSPA

## Arquivos existentes relevantes
- `.docker/docker-compose.projects.postgres.yml`
- `.docker/entrypoint.projects.postgres.sh`
- `/gen/static-api/src/middleware/jwt-auth.guard.ts`

## Arquivos que serão alterados
- `.docker/docker-compose.projects.postgres.yml` - Adicionar `E2E_SKIP_JWT: "true"` no serviço `apis`
- `.docker/entrypoint.projects.postgres.sh` - Adicionar `E2E_SKIP_JWT=true` nas variáveis de ambiente

## Requisitos da mudança específica
- SSPA deve funcionar sem exigir autenticação
- Todas as APIs (portas 3001-3026) devem aceitar requisições sem token

## Requisitos globais do projeto
- Manter estrutura de diretórios `.docker/`
- Manter convenções de variáveis de ambiente

## Regras não atendidas
- JwtAuthGuard exige autenticação JWT por padrão

## Plano de auditoria
- Verificar via navegador se cards carregam dados
- Executar `make playwright-test` para validar

## Checklists aplicáveis
- N/A
