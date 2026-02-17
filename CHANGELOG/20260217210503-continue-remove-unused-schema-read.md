<!-- CHANGELOG/20260217210503-continue-remove-unused-schema-read.md -->

# 2026-02-17 21:05:03 UTC — Continuidade: remover leitura de schema não utilizada em geradores

## Arquivos modificados
- `src/env-generator.ts`
- `src/package-json-generator.ts`
- `src/main-generator.ts`
- `CHANGELOG/20260217210503-continue-remove-unused-schema-read.md`

## Regras e requisitos atendidos
- Continuidade com escopo restrito em correções pontuais já identificadas.
- Remoção de comportamento sem uso efetivo (leitura de arquivo de schema descartada no construtor).
- Registro em novo arquivo `CHANGELOG/` com timestamp único.

## Correção implementada
- Removida a leitura de `schemaPath` nos construtores de:
  - `EnvGenerator`
  - `PackageJsonGenerator`
  - `MainFileGenerator`
- Os construtores passam a apenas armazenar `config`, eliminando side effect desnecessário.

## Evidências e comandos executados
- `list_mcp_resources` → sem recursos MCP GitHub disponíveis na sessão.
- `npm run build` → falha conhecida de ambiente (`TS2688: Cannot find type definition file for 'node'`).

## Resultado resumido
- Menor acoplamento e menor I/O desnecessário durante inicialização desses geradores.
- Validação automática completa ainda bloqueada por limitação do ambiente.

## Pendências
- Reexecutar build/testes em ambiente com tipagens Node disponíveis.
