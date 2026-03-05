<!-- CHANGELOG/20260305105059-service-discovery-mfe-dir-plan.md -->
# Plano - Integração automática service-discovery ← MFEs + URLs dinâmicas por ambiente

## Arquivos existentes relevantes
- `demo/service-discovery/src/main.ts` - service-discovery atual (lê DISCOVERY_APPS_JSON)
- `demo/service-discovery/src/contracts.ts` - tipos DiscoveryApplication
- `gen/src/microfrontend-generator.ts` - gerador de MFEs
- `gen/templates/mfe-vite-config.ejs` - template vite config do MFE
- `gen/templates/mfe-api-client.ejs` - template API client (usa VITE_API_URL)
- `gen/templates/mfe-docker-compose.ejs` - template compose (usa localhost)
- `gen/templates/app-shell-import-map.ejs` - import-map estático (hardcoded localhost)
- `gen/templates/app-shell-index-html-dynamic.ejs` - index.html dinâmico (hardcoded localhost:3015)
- `gen/templates/app-shell-vite-config.ejs` - template vite config do app-shell
- `.docker/docker-compose.projects.postgres.yml` - compose de produção
- `.docker/docker-compose.demo.yml` - compose demo
- `Makefile` - alvos demo-mfe-up, demo-pg-up

## Arquivos a alterar
1. `demo/service-discovery/src/main.ts` - adicionar suporte a DISCOVERY_APPS_DIR
2. `gen/src/microfrontend-generator.ts` - gerar manifest.json em cada MFE
3. `gen/templates/mfe-vite-config.ejs` - adicionar VITE_MFE_BASE_URL
4. `gen/templates/mfe-api-client.ejs` - já usa VITE_API_URL (manter)
5. `gen/templates/app-shell-import-map.ejs` - usar variável para URL base
6. `gen/templates/app-shell-index-html-dynamic.ejs` - usar variável para service-discovery URL
7. `gen/templates/app-shell-vite-config.ejs` - adicionar variáveis de ambiente
8. `.docker/docker-compose.projects.postgres.yml` - montar volume de manifestos + configurar env vars
9. `Makefile` - ajustar alvos para gerar manifestos e passar variáveis

## Requisitos da mudança + Requisitos globais
### Requisitos específicos
- REQ-SD-001: Service-discovery deve descobrir MFEs via arquivos de manifesto em diretório configurável
- REQ-SD-002: Cada MFE gerado deve ter manifest.json com metadados (name, module, route, title, description, importUrl)
- REQ-SD-003: URLs (importUrl, service-discovery URL, app-shell URL) devem ser interpoladas via variáveis de ambiente Vite
- REQ-SD-004: Se VITE_PUBLIC_URL não definido, auto-detectar IP público do host
- REQ-SD-005: Suportar IP direto, domínio CloudFlare, e diferentes servidores sem recompilação

### Requisitos globais (do projeto)
- Manter compatibilidade com gen-mfe-internal e gen-mfe-paging
- Não quebrar demo-pg-up existente
- Seguir convenções de AGENTS.md (caminhos, imports, sem código morto)

## Requisitos não atendidos atualmente
- Service-discovery não escaneia diretório, só lê JSON de env
- MFEs não geram manifest.json
- URLs hardcoded em templates (localhost)
- Sem interpolação dinâmica de IP/domínio

## Regras da mudança + Regras globais
### Regras específicas
- REG-SD-001: DISCOVERY_APPS_DIR tem prioridade sobre DISCOVERY_APPS_JSON
- REG-SD-002: Arquivos de manifesto em DISCOVERY_APPS_DIR/*.json são parseados como DiscoveryApplication[]
- REG-SD-003: VITE_PUBLIC_URL, VITE_SERVICE_DISCOVERY_URL, VITE_MFE_BASE_URL são obrigatórias no build
- REG-SD-004: Fallback: detectar IP público via service discovery (ipify ou similar) se não informado
- REG-SD-005: Template de importUrl no manifest deve usar VITE_MFE_BASE_URL (não hardcoded)

### Regras globais (do projeto)
- Usar placeholders ${VAR:-default} em docker-compose
- Gerar changelog a cada entrega
- Código limpo: remover código morto após refactor

## Plano de auditoria
### Verificações manuais
1. Gerar MFE: `make gen-mfe GEN_PROJECT=projects/addresses GEN_OUTPUT=output/addresses/postgres`
2. Verificar manifest.json gerado em output/addresses/postgres/frontend/*-mfe/manifest.json
3. Subir demo com IP: `VITE_PUBLIC_URL=http://192.168.1.100 make demo-pg-up`
4. Verificar URLs nos bundles: bundle deve conter IP/domínio, não localhost
5. Testar service-discovery: curl http://localhost:3015/api/discovery/applications deve listar MFEs do diretório
6. Testar access external: curl http://<IP>:9000/ deve carregar app-shell

### Verificações automáticas
- `make gen-mfe` executa sem erro
- `make demo-pg-up` executa sem erro
- `curl -s http://localhost:3015/api/discovery/applications | jq .` retorna array não-vazio
- Manifesto gerado contém campos: name, module, route, title, description, importUrl

## Checklists obrigatórios
- [ ] Demo e E2E: executar make demo-pg-up e validar endpoints
- [ ] Geração: executar make gen-mfe e validar saída
- [ ] URL dinâmica: verificar que bundle contém IP/domínio configurado
- [ ] Service discovery: validar que MFEs são descobertos via diretório

## Auditoria relacionada
- `CHANGELOG/20260305105059-service-discovery-mfe-dir-audit.md` (auditoria irma deste plano)
- `CHANGELOG/20260305031427-demo-sspa-acesso-remoto-fix.md` (corrigido acesso remoto)
- `CHANGELOG/20260304190932-service-discovery-manifesto-dir-plan.md` (plano original de manifesto)
