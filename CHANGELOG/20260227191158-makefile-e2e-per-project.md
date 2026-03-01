<!-- CHANGELOG/20260227191158-makefile-e2e-per-project.md -->
# Changelog - Alvos E2E por Projeto no Makefile

**Data/Hora UTC:** 2026-02-27 19:11:58  
**Responsável:** Agent  
**Tipo:** Adição de Funcionalidade

---

## Arquivos Modificados

- `Makefile` — adicionados alvos dinâmicos `e2e-<projeto>`

---

## Requisitos Atendidos

- ✅ `make e2e-auth` — executa E2E apenas para projeto auth
- ✅ `make e2e-accounts` — executa E2E apenas para projeto accounts
- ✅ `make e2e-todo` — executa E2E apenas para projeto todo
- ✅ Todos os 26 projetos disponíveis

---

## Lista de Comandos Disponíveis

```
make e2e-accounts
make e2e-addresses
make e2e-auth
make e2e-communications
make e2e-config
make e2e-consents
make e2e-contacts
make e2e-gmail
make e2e-google-calendar
make e2e-google-drive
make e2e-llm
make e2e-logistics
make e2e-maps
make e2e-notifications
make e2e-orders
make e2e-payments
make e2e-products
make e2e-reports
make e2e-roles
make e2e-schedule
make e2e-selling
make e2e-tenant
make e2e-todo
make e2e-transactions
make e2e-users
make e2e-warehouse
```

---

## Auditoria

### Verificações Realizadas
- Sintaxe Makefile: ✅ (`make -n e2e-auth` executa corretamente)

---

## Resultado

**Status:** ✅ Implementado e validado
