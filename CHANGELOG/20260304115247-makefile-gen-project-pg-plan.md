<!-- CHANGELOG/20260304115247-makefile-gen-project-pg-plan.md -->
# Plano — alvos Makefile por projeto para geração PostgreSQL (API e MFE Parcel Paging)

## Data/Hora UTC
2026-03-04T11:52:47Z

## 1. Arquivos existentes relevantes para o escopo
- `Makefile`
- `CHANGELOG/20260303205220-addresses-postgres-e2e-playwright-plan.md`
- `CHANGELOG/20260303205220-addresses-postgres-e2e-playwright-audit.md`

## 2. Arquivos que serão alterados
- `Makefile`
- `CHANGELOG/20260304115247-makefile-gen-project-pg-plan.md`
- `CHANGELOG/20260304115247-makefile-gen-project-pg-audit.md`

## 3. Lista combinada de requisitos (específicos + globais)
- Registrar novo plano no `CHANGELOG/` contendo pendências do ciclo atual.
- Criar no `Makefile`, para cada projeto listado, um alvo `gen-<project>-pg-api`.
- Criar no `Makefile`, para cada projeto listado, um alvo `gen-<project>-pg-parcel-paging`.
- Criar no `Makefile`, para cada projeto listado, um alvo `e2e-<project>-pg-api`.
- Criar no `Makefile`, para cada projeto listado, um alvo `e2e-<project>-pg-parcel-paging`.
- Gerar API em `output/api/postgres/<project>`.
- Gerar MFE Parcel Paging em `output/parcel/postgres/<project>/mfe-parcel-paging`.
- O alvo `e2e-<project>-pg-api` deve testar todos os endpoints da API gerada em `gen-<project>-pg-api`.
- O alvo `e2e-<project>-pg-parcel-paging` deve testar o aplicativo React gerado em `output/parcel/postgres/<project>/mfe-parcel-paging` usando Playwright.
- Ambos os alvos E2E devem subir (DDL) e carregar (SQL) o banco referente ao projeto e os containers necessários para cada tipo de teste.
- Composição obrigatória para `e2e-<project>-pg-api`: banco do projeto + container da API + container de teste.
- Composição obrigatória para `e2e-<project>-pg-parcel-paging`: banco do projeto + container da API + container do MFE Parcel Paging + container de teste Playwright.
- Toda e qualquer execução do gerador, dos aplicativos gerados, dos bancos de dados e dos testes deve ocorrer exclusivamente por alvos do `Makefile`.
- Fica proibida execução direta de `npm`, `sh`, `docker`, `docker-compose` e comandos equivalentes fora dos alvos do `Makefile`.
- Manter execução por entradas do `Makefile`, sem ampliar escopo para integração no SSPA neste momento.

## 4. Requisitos não atendidos no início do ciclo
- Não existiam alvos dedicados por projeto para geração PostgreSQL de API.
- Não existiam alvos dedicados por projeto para geração PostgreSQL de MFE Parcel Paging com caminho de saída padronizado.
- Não existiam alvos dedicados por projeto para E2E PostgreSQL de API com banco/containers isolados por projeto.
- Não existiam alvos dedicados por projeto para E2E PostgreSQL de MFE Parcel Paging com Playwright e composição de containers específica.
- O plano com pendências do ciclo atual ainda não estava registrado com esse novo escopo.

## 5. Lista combinada de regras (específicas + globais)
- Alterar apenas arquivos necessários para cumprir o pedido.
- Não adicionar dependências, serviços ou refactors amplos.
- Preservar nomenclatura e padrão de comandos via `Makefile`.
- Garantir que toda operação executável esteja encapsulada em alvos do `Makefile` (proibido executar comandos operacionais diretamente no terminal).
- Manter rastreabilidade por `CHANGELOG/*` com referências cruzadas.

## 6. Regras não atendidas que motivam os ajustes
- Ausência de comandos padronizados por projeto para o fluxo PostgreSQL.
- Saídas de geração não normalizadas em `output/api/postgres/...` e `output/parcel/postgres/...` para todos os projetos.
- Ausência de comandos E2E PostgreSQL por projeto com política explícita de inicialização DDL/SQL e composição mínima de containers.

## 7. Plano de auditoria (manual + automático)
1. Executar `make -n gen-addresses-pg-api` para validar expansão do alvo.
2. Executar `make -n gen-addresses-pg-parcel-paging` para validar expansão do alvo.
3. Executar `make -n e2e-addresses-pg-api` para validar expansão e composição de execução.
4. Executar `make -n e2e-addresses-pg-parcel-paging` para validar expansão e composição de execução.
5. Executar `make gen-addresses-pg-api` para validar geração API em `output/api/postgres/addresses`.
6. Executar `make gen-addresses-pg-parcel-paging` para validar geração MFE em `output/parcel/postgres/addresses/mfe-parcel-paging`.
7. Executar `make e2e-addresses-pg-api` e validar: carga DDL/SQL do banco do projeto + subida de banco/API/teste + cobertura de endpoints da API gerada.
8. Executar `make e2e-addresses-pg-parcel-paging` e validar: carga DDL/SQL do banco do projeto + subida de banco/API/MFE/teste Playwright + execução sobre app React gerado.
9. Registrar resultado objetivo (passou/falhou) e pendências remanescentes no arquivo de auditoria irmão.

## 8. Seleção de checklists aplicáveis
- Checklist obrigatório transversal: rastreabilidade de plano + auditoria em `CHANGELOG/*`.
- Checklist de implementação mínima: alteração apenas de `Makefile` para atender escopo.
- Checklist de evidências: comandos executados, arquivos alterados e resultado objetivo.

## Pendências registradas deste ciclo
- `make e2e-api-addresses` ainda falha ao percorrer múltiplos `dbType` (incluindo `sqlserver`) no runner atual, mesmo quando o foco operacional é Postgres.
- `PLAYWRIGHT_PROJECT=addresses make playwright-test` permanece com falha por respostas `404` em endpoints esperados na matriz de autenticação/CRUD.

## Referências cruzadas
- `CHANGELOG/20260303205220-addresses-postgres-e2e-playwright-plan.md`
- `CHANGELOG/20260303205220-addresses-postgres-e2e-playwright-audit.md`
