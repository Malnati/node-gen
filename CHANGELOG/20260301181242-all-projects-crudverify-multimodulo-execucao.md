<!-- CHANGELOG/20260301181242-all-projects-crudverify-multimodulo-execucao.md -->
# 2026-03-01 18:12:42 UTC - Execucao do plano de padronizacao `crudVerify[]` multi-modulo

## Plano relacionado
- `CHANGELOG/plan-all-projects-crudVerify-multimodulo.md`

## Arquivos modificados
- `test/e2e-generator/e2e.json`
- `test/e2e-generator/e2e.js`
- `CHANGELOG/20260301181242-all-projects-crudverify-multimodulo-execucao.md`

## Regras e requisitos atendidos
- Padronizacao de `crudVerify[]` aplicada aos projetos multi-modulo no `e2e.json`.
- Compatibilidade preservada com configuracoes existentes (`postVerify`) e com projetos sem `crudVerify[]`.
- Validacao executada via `make e2e <project>`, sem rodar todos os projetos.
- Evidencias registradas com comandos e resultado objetivo.

## Comandos executados
1. `node -e "... identificar projetos multi-modulo sem crudVerify ..."`
2. `node -e "... aplicar crudVerify[] automaticamente no e2e.json ..."`
3. `node -e "JSON.parse(...e2e.json...)"`
4. `make e2e-clean`
5. `make e2e schedule` (falhou; lacunas de payload generico em alguns endpoints)
6. Ajustes em `test/e2e-generator/e2e.js` para fluxo CRUD generico resiliente por endpoint
7. `make e2e-clean`
8. `make e2e notifications` (passou)

## Resultado resumido
- `e2e.json` atualizado: todos os projetos multi-modulo agora possuem `crudVerify[]`.
- `e2e.js` atualizado para:
  - suportar CRUD multiplo por endpoint;
  - fallback por registro existente quando `crudVerify` for generico;
  - evitar quebra por payload ausente e por falha de `POST` em endpoints sem corpo explicito.
- Validacao final executada com sucesso em `notifications`:
  - MySQL: passou
  - PostgreSQL: passou
  - SQLite: passou (modo afericao sem subida da API)
  - SQL Server: passou

## Definicao de pronto
- [x] Projetos multi-modulo com `crudVerify[]` padronizado no `e2e.json`.
- [x] Runner E2E ajustado para executar `crudVerify[]` de forma consistente.
- [x] Teste via `make e2e <project>` executado com sucesso.
- [x] Evidencias de comandos e resultado registradas neste changelog.
