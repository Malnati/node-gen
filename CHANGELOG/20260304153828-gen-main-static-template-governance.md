<!-- CHANGELOG/20260304153828-gen-main-static-template-governance.md -->
# Implementação 2026-03-04 15:38:28 UTC - `gen/src/main.ts` estáticos + regras de design

## Referências cruzadas (planos recentes consultados)
- `CHANGELOG/20260302204638-sspa-full-card-entity-coverage-plan.md`
- `CHANGELOG/20260302174555-sspa-card-by-card-validation-plan.md`
- `CHANGELOG/20260302150253-sspa-test-coverage-traceability-plan.md`

## Arquivos alterados
- `gen/src/main.ts`
- `gen/src/mfe-parcel-paging-generator.ts`
- `gen/src/interfaces.ts`
- `gen/templates/mfe-parcel-paging-client.ejs`
- `gen/templates/mfe-parcel-paging-data-provider.ejs`
- `gen/templates/mfe-parcel-paging-vite-config.ejs`
- `gen/templates/mfe-parcel-paging-dockerfile.ejs`
- `AGENTS.md`
- `opencode.json`

## Regras e requisitos atendidos
- Adicionada função `copyStaticParcelPagingFiles` em `gen/src/main.ts`, com cópia de `gen/static/mfe-parcel-paging` para o diretório de saída da geração.
- Ajustada resolução de caminhos estáticos em `gen/src/main.ts` para suportar `templateDir=./static` sem perder fallback para `gen/static` e `gen/static-api`.
- Mantido `main.ts` como orquestrador de geração (cópia estática + execução de geradores) sem adicionar responsabilidades de empacotamento/execução/teste.
- Removidos blocos hardcoded multiline de `mfe-parcel-paging-generator.ts` para arquivos com interpolação, migrando para templates EJS dedicados.
- Interfaces de paginação do `mfe-parcel-paging` movidas para `gen/src/interfaces.ts`, reduzindo acoplamento no gerador.
- Regras de design para estáticos, templates EJS e limite de strings em geradores registradas em `AGENTS.md` e `opencode.json`.

## Comandos executados
- `ls -la`
- `rg --files .github | head -n 50`
- `rg --files gen/src`
- `rg --files CHANGELOG | tail -n 20`
- `rg --files .github/instructions`
- `sed -n '1,260p' .github/copilot-instructions.md`
- `sed -n '1,260p' opencode.json`
- `sed -n '1,260p' .github/instructions/task-implementation.instructions.md`
- `sed -n '1,260p' .github/instructions/instructions.codebase-changes.md`
- `sed -n '1,260p' .github/instructions/governance.instructions.md`
- `sed -n '1,260p' gen/src/main.ts`
- `ls -la gen/static && find gen/static -maxdepth 3 -type d | sort`
- `find gen -maxdepth 3 -type d | sort | rg 'static|template|ejs'`
- `rg -n "copyStaticApiFiles|static-api|mfe-parcel-paging|clientContent|dataProviderContent|generateViteConfig|const content" gen/src/main.ts gen/src/*.ts`
- `sed -n '1,560p' gen/src/mfe-parcel-paging-generator.ts`
- `ls -la gen/templates && rg -n "mfe-parcel|vite|dataProvider|client" gen/templates -S`
- `sed -n '1,260p' gen/src/interfaces.ts`
- `sed -n '1,240p' CHANGELOG/20260302190041-sspa-skip-auth-regression-fix.md`
- `sed -n '1,240p' CHANGELOG/20260302204638-sspa-full-card-entity-coverage-audit.md`
- `date -u +%Y%m%d%H%M%S`
- `git status --short`
- `node -e "JSON.parse(require('fs').readFileSync('opencode.json','utf8'));console.log('opencode.json OK')"`
- `git diff -- ...`
- `npm run build`
- `make e2e-addresses-pg-parcel-paging`

## Resultado resumido
- **PASSOU (validação estática):**
  - `main.ts` agora inclui cópia estática para `mfe-parcel-paging`.
  - Conteúdos interpolados do gerador foram externalizados para templates EJS.
  - Regras de design adicionadas em `AGENTS.md` e `opencode.json`.
  - `opencode.json` validado como JSON válido.
- **NÃO EXECUTADO neste ciclo:**
  - Nenhum.
- **Resultado da validação solicitada (1 projeto):**
  - Geração (`addresses`) **PASSOU** para API e MFE Parcel Paging, incluindo cópia estática de API e `mfe-parcel-paging`.
  - E2E paging (`addresses`) **PASSOU** no bloco de aferição de artefatos obrigatórios (10/10).
  - Playwright SSPA **FALHOU** com 3 testes em `test/sspa.spec.ts` por HTTP `404` em rotas de entidades de `addresses`, além de mismatch de contagem de cards (`Expected 1`, `Received 26`), indicando falha de ambiente/roteamento da stack SSPA e não erro de geração estática.

## Definição de pronto
- [x] Existe função `copyStaticParcelPagingFiles` em `gen/src/main.ts`.
- [x] A cópia usa `gen/static/mfe-parcel-paging/` para o diretório destino de geração.
- [x] Regra de arquivos estáticos foi definida com abrangência em `AGENTS.md`.
- [x] Regra de arquivos estáticos foi definida em `opencode.json`.
- [x] Regra de papel do `gen/src/main.ts` foi definida em `AGENTS.md`.
- [x] Regra de papel do `gen/src/main.ts` foi definida em `opencode.json`.
- [x] Blocos hardcoded com interpolação citados (`clientContent`, `dataProviderContent`, `generateViteConfig`) foram migrados para templates EJS.
- [x] Regra de proibição de strings longas/multiline em geradores foi registrada em `AGENTS.md` e `opencode.json`.
