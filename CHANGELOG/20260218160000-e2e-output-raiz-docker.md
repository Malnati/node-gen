<!-- CHANGELOG/20260218160000-e2e-output-raiz-docker.md -->

# 2026-02-18 16:00:00 UTC — E2E: output na raiz, Via Docker, build obrigatório

## Objetivo

- Disponibilizar a aplicação gerada pelo E2E em `output/` na raiz do repositório.
- Garantir que a aplicação gerada compila com sucesso (ajustes apenas em templates se necessário; estrutura estática intacta).
- Validar fluxo Via Docker: `make e2e`, `make e2e-build`, `make e2e-run`.

## Alterações

### Saída do gerador no E2E

- **`test/e2e-generator/run.js`:** `OUT_DIR` alterado de `test/e2e-generator/out` para `path.join(REPO_ROOT, 'output')`. Limpeza do diretório de saída passou a esvaziar o conteúdo em vez de remover o diretório (compatível com volume Docker `./output:/app/output`).
- **`.gitignore`:** adicionado `output/`.
- **`.dockerignore`:** `test/e2e-generator/out` substituído por `output`.
- **`docker-compose.e2e.yml`:** volume `./output:/app/output` para que a aplicação gerada fique em `output/` na raiz do repo após `make e2e-run`.
- **`.docker/entrypoint.e2e.sh`:** correção do caminho do script de criação do mock para `test/e2e-generator/create-db.js`.

### Documentação

- **`test/README.md`:** saída do E2E descrita como `output/` na raiz; seção "Via Docker" atualizada com menção ao volume e à validação de build.
- **`test/e2e-generator/README.md`:** saída em `output/` na raiz.
- **`docs/issues/plan-test-project-generator-vs-mock.md`:** diretório de output como `output/` na raiz.

## Resultado dos testes

- `make e2e-build` — sucesso.
- `make e2e-run` — sucesso (obrigatórios 9/9; `npm run build` no output OK).
- Aplicação gerada disponível em `output/` na raiz após execução com volume montado.

## Critério atendido

A aplicação gerada compila com sucesso; nenhuma alteração em templates foi necessária (estrutura estática mantida).
