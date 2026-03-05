<!-- CHANGELOG/20260305180000-mfe-browser-fix-plan.md -->
# Plano - Correção de MFEs no navegador (TypeError: Load failed)

## Problema reportado
```
[Error] [demo/sspa] failed to setup dynamic applications – TypeError: Load failed
Error loading http://157.173.125.230:7100/spa.js (SystemJS Error#3)
Error loading http://157.173.125.230:7101/spa.js (SystemJS Error#3)
Error loading http://157.173.125.230:7102/spa.js (SystemJS Error#3)
```

## Causa raiz identificada
1. **URLs externas inacessíveis**: service-discovery substitui `host.docker.internal` por IP público `157.173.125.230`, mas containers MFEs não estão acessíveis nessaaquele IP
2. **Inconsistência de arquivo**: docker-compose usa `main.js`, mas manifest gera `spa.js`
3. **Containers não iniciados**: portas 7100-7102 não respondem

## Pendências do plano anterior
- `CHANGELOG/20260305170000-service-discovery-mfe-browser-fix-plan.md` foi criado mas nunca implementado

## Lista de arquivos relevantes
- `.docker/docker-compose.projects.postgres.yml` - define DISCOVERY_APPS_JSON com URLs
- `gen/src/microfrontend-generator.ts:204` - gera manifest.json com spa.js
- `gen/templates/mfe-docker-compose.ejs` - template compose com portas
- `demo/service-discovery/src/main.ts:214-236` - rewriteImportUrlForRequest substitui host

## Lista de arquivos a alterar
1. `.docker/docker-compose.projects.postgres.yml` - corrigir importUrl de main.js para spa.js
2. `demo/service-discovery/src/main.ts` - opção para desabilitar reescrita de IP externo

## Requisitos da mudança
- MFEs devem carregar no navegador sem erros de conexão
- URLs devem ser acessíveis do navegador (localhost ou IP reachable)

## Requisitos não atendidos
- REG-SD-005: importUrl deve ser válido no contexto do navegador

## Regras do projeto
- Usar placeholders `${VAR:-default}` para variáveis de ambiente
- Manter consistência entre main.js vs spa.js

## Plano de auditoria
### Verificações manuais
1. Verificar se `curl localhost:7100/spa.js` retorna conteúdo
2. Testar acesso via navegador em http://localhost:9000
3. Verificar console do navegador para erros

### Verificações automáticas
- `curl localhost:7100/spa.js` retorna HTTP 200
- `curl localhost:3015/api/discovery/applications` retorna JSON válido

## Checklists aplicáveis
- Checklist de validação de MFEs (gen/src/*)
- Checklist de service-discovery

---

## Execução (a ser feito em ciclo separado)

### Passo 1: Corrigir inconsistência main.js vs spa.js
Editar `.docker/docker-compose.projects.postgres.yml`:
```
- Trocar "main.js" por "spa.js" em todos os importUrl
```

### Passo 2: Opção para desabilitar reescrita de IP (ou usar localhost)
Editar `demo/service-discovery/src/main.ts`:
```
- Adicionar variável DISCOVERY_USE_LOCALHOST=true
- Se setada, usar localhost:7100 em vez de IP público
```

### Passo 3: Regenerar e subir serviços
```bash
make demo-pg-up
```

### Passo 4: Validar
```bash
curl localhost:7100/spa.js
curl localhost:3015/api/discovery/applications
```
