<!-- CHANGELOG/20260305153000-service-discovery-mfe-correcoes-plan.md -->
# Plano - Correções pós-implementação service-discovery MFE

## Arquivos existentes relevantes
- `CHANGELOG/20260305105059-service-discovery-mfe-dir-plan.md` - plano original
- `CHANGELOG/20260305105059-service-discovery-mfe-dir-audit.md` - auditoria do plano
- `CHANGELOG/20260305123000-service-discovery-mfe-dir-impl.md` - implementação realizada

## Pendências identificadas na auditoria
1. `gen/templates/mfe-docker-compose.ejs` - ainda usa URL fixa para VITE_API_URL
2. `gen/templates/app-shell-vite-config.ejs` - fallback localhost ainda presente (menor prioridade)
3. Erros TS6133 (código morto) em Bootstrap.tsx e ErrorBoundary.tsx gerados

## Arquivos a alterar
1. `gen/templates/mfe-docker-compose.ejs` - usar `${VITE_API_URL:-http://api:3000}`
2. `gen/src/appshell-generator.ts` - revisar se há código morto em Bootstrap.tsx e ErrorBoundary.tsx

## Requisitos da mudança
- Garantir que todos os templates usem variáveis de ambiente com fallbacks seguros
- Remover código morto que causa erros TS6133 nos artefatos gerados

## Regras
- Usar placeholders `${VAR:-default}` em docker-compose
- Código limpo: remover código morto após qualquer refatoração

## Plano de auditoria
### Verificações manuais
1. Verificar que `mfe-docker-compose.ejs` usa VITE_API_URL com placeholder
2. Verificar se há código morto em `gen/templates/app-shell-app-dynamic.ejs` ou `gen/src/appshell-generator.ts`
3. Executar `make gen-mfe GEN_PROJECT=projects/addresses GEN_OUTPUT=output/addresses/postgres`
4. Verificar se build dos MFEs gerados concluí sem erros TS6133

### Verificações automáticas
- `make gen-mfe` executa sem erro
- `npm run build` executa sem erro
- `grep -r "TS6133" output/` retorna vazio

## Checklists obrigatórios
- [ ] Templates: verificar placeholders de variáveis de ambiente
- [ ] Código morto: auditar e remover
- [ ] Build: validar geração sem erros TypeScript

## Testes com 3 projetos diferentes (via Makefile)
Executar geração completa de 3 projetos diferentes (que não addresses) para validar discovery:
1. `make gen-mfe GEN_PROJECT=projects/accounts GEN_OUTPUT=output/accounts/postgres`
2. `make gen-mfe GEN_PROJECT=projects/contacts GEN_OUTPUT=output/contacts/postgres`
3. `make gen-mfe GEN_PROJECT=projects/orders GEN_OUTPUT=output/orders/postgres`

Validar que cada projeto gerou:
- manifest.json em cada MFE
- build sem erros TS6133

## Verificação de conformidade com AGENTS.md e opencode.json
Verificado que as seguintes regras estão presentes:
- AGENTS.md linhas 262-271: execução exclusiva via Makefile
- opencode.json: reforço da política de execução via Makefile
- Nenhum desvio detectado - correções serão executadas via Makefile conforme exigido
