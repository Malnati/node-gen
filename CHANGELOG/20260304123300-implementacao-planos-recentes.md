<!-- CHANGELOG/20260304123300-implementacao-planos-recentes.md -->
# 2026-03-04 12:33:00 UTC — Implementação dos planos mais recentes do CHANGELOG

## Planos executados
- `CHANGELOG/20260304115247-makefile-gen-project-pg-plan.md`
- Referência de pendência: `CHANGELOG/20260304122745-makefile-exclusive-execution-policy.md`

## Arquivos modificados
- `Makefile`
- `CHANGELOG/20260304123300-implementacao-planos-recentes.md`

## Comandos executados
1. `rg --files CHANGELOG | sort`
2. `sed -n '1,260p' CHANGELOG/20260304115247-makefile-gen-project-pg-plan.md`
3. `sed -n '1,260p' CHANGELOG/20260304115247-makefile-gen-project-pg-audit.md`
4. `sed -n '1,260p' CHANGELOG/20260304122745-makefile-exclusive-execution-policy.md`
5. `sed -n '1,560p' Makefile`
6. `make -n gen-addresses-pg-api`
7. `make -n gen-addresses-pg-parcel-paging`
8. `make -n e2e-addresses-pg-api`
9. `make -n e2e-addresses-pg-parcel-paging`
10. `make gen-addresses-pg-api`
11. `make gen-addresses-pg-parcel-paging`

## Resultado resumido
- Implementação dos alvos dinâmicos `e2e-<project>-pg-api`: **PASSOU**.
- Implementação dos alvos dinâmicos `e2e-<project>-pg-parcel-paging`: **PASSOU**.
- Expansão dos novos alvos (`make -n`) para `addresses`: **PASSOU**.
- Execução funcional completa de geração (`make gen-addresses-pg-api` e `make gen-addresses-pg-parcel-paging`): **FALHOU** por pré-condições externas já existentes no ambiente (sem conexão ativa em `127.0.0.1:5432` e ausência de `db.reader.postgres.json` após falha de leitura do banco).

## Definição de pronto (plano 20260304115247), item a item
- [x] Criar alvo `gen-<project>-pg-api` por projeto.
- [x] Criar alvo `gen-<project>-pg-parcel-paging` por projeto.
- [x] Criar alvo `e2e-<project>-pg-api` por projeto.
- [x] Criar alvo `e2e-<project>-pg-parcel-paging` por projeto.
- [x] Encapsular execução via entradas `Makefile`.
- [x] Validar expansão de alvos com `make -n` para `addresses`.
- [ ] Validar execução ponta a ponta dos novos alvos em ambiente com banco acessível e stack completa de containers.

## Pendências relevantes
- `make gen-addresses-pg-api` falha com `connect EPERM 127.0.0.1:5432` no ambiente atual.
- `make gen-addresses-pg-parcel-paging` falha pelo mesmo bloqueio de conexão, impedindo a geração de `db.reader.postgres.json`.
- Fluxo completo com containers (`e2e-...-pg-*`) permanece dependente de ambiente com Docker e banco disponíveis.
