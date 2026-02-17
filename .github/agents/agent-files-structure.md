---
name: Files Structure
description: Garante a estrutura de arquivos do repositório
version: 1.0.0
referenced_by: opencode.json, AGENTS.md
see_also: AGENTS.md
---

<!-- .github/agents/agent-files-structure.md -->

# Agente: GitHub Actions e Workflows

> **📋 Documentação relacionada:**  
> - Índice geral: [AGENTS.md](../../AGENTS.md)  
> - Configuração OpenCode: [opencode.json](../../opencode.json) (seção `agent.actions`)  
> - Agentes relacionados: [agent-bash.md](./agent-bash.md), [agent-yml-structure.md](./agent-yml-structure.md)

## Propósito

Este documento define as regras para a organização de arquivos neste repositório, garantindo consistência e facilitando a navegação e manutenção do código.

# Estrutura de Arquivos do Repositório

> **📋 Documentação relacionada:**  
> - Índice geral: [AGENTS.md](../../AGENTS.md)
> - **⚠️ Autorização obrigatória:** [agent-governance.md](./agent-governance.md)

## ⚠️ ATENÇÃO: Validação de Autorização Obrigatória

**Antes de criar qualquer arquivo neste repositório, você DEVE:**
1. ✅ Verificar autorização conforme [agent-governance.md](./agent-governance.md)
2. ✅ Validar que o diretório está na estrutura aprovada abaixo
3. ❌ Se qualquer um dos critérios não for atendido: PARAR e solicitar aprovação

## Regras Gerais

### 1. Estrutura de Diretórios Principal

| Diretório | Propósito |
|-----------|-----------|
| `.github/` | Arquivos relacionados ao GitHub (workflows, agentes, configurações) |
| `CHANGELOG/` | Registros de mudanças e ciclos de governança (formato `YYYYMMDDHHMMSS.md`) |
| `docs/` | Toda a documentação do repositório |
| `fixtures/` | Dados de teste e mock projects |
| `/` (raiz) | Arquivos de configuração global e README |

### 2. Diretório .github

| Subdiretório | Propósito |
|--------------|-----------|
| `.github/agents/` | Documentação e configuração de agentes (todos os arquivos como `agent-*.md`) |
| `.github/workflows/` | Definições de GitHub Actions workflows (arquivos YAML) |
| `.github/workflows/assets/` | Recursos estáticos usados pelos workflows (scripts, configs, etc.) |

### 3. Diretório docs

| Conteúdo | Propósito |
|----------|-----------|
| Documentação técnica | Guias, tutoriais e especificações técnicas |
| Documentação de features | Descrição detalhada de funcionalidades |
| Documentação de arquitetura | Explicação da arquitetura e padrões de design |
| Documentação de processos | Descrição de processos e fluxos de trabalho |

### 4. Diretório fixtures

| Conteúdo | Propósito |
|----------|-----------|
| Projetos mock | Projetos de exemplo para testar workflows |
| Dados de teste | Conjuntos de dados para testes |
| Configurações de teste | Configurações específicas para testes |

**⚠️ IMPORTANTE: Fixtures são FORA DO ESCOPO de modificações**

Conforme definido em `AGENTS.md` e `.github/agents/agent-actions.md`:
- **NÃO é responsabilidade deste repositório** melhorar ou corrigir projetos no diretório `fixtures/`
- **Se workflows falharem com fixtures**: corrija o workflow para ser mais genérico, NÃO os fixtures
- **Fixtures são mock projects** para teste de workflows APENAS
- **Qualquer modificação em fixtures** deve ser minimamente invasiva e focada exclusivamente em tornar o workflow testável

## Convenções de Nomenclatura

### Agentes

- Todos os arquivos de configuração de agentes devem seguir o padrão: `agent-*.md`
- Exemplo: `agent-actions.md`, `agent-files-structure.md`

### Workflows

- Todos os workflows devem estar em `.github/workflows/` com extensão `.yml`
- Assets de workflows devem estar organizados por workflow em `.github/workflows/assets/<workflow-name>/`

### Documentação

- Documentação técnica: `docs/<feature>-<type>.md`
- Exemplos: `docs/sonarqube-workflow.md`, `docs/update-labels-workflow.md`

### Changelog e Governança

- Todos os registros de governança devem estar em `CHANGELOG/` (raiz do repositório)
- Formato: `YYYYMMDDHHMMSS.md` (timestamp UTC)
- Cada arquivo deve iniciar com comentário de caminho: `<!-- CHANGELOG/<arquivo>.md -->`
- Exemplo: `CHANGELOG/20260210164104.md`

## Ciclo de Governança

A documentação do ciclo de governança deve seguir o seguinte fluxo:

1. **Planejamento**: Documentado em `CHANGELOG/YYYYMMDDHHMMSS-plan.md`
2. **Implementação**: Código e recursos implementados nos diretórios apropriados
3. **Conclusão**: Documentada em `CHANGELOG/YYYYMMDDHHMMSS-conclusion.md`

**Importante**: Conforme `AGENTS.md`, deve haver **exatamente um arquivo novo em `CHANGELOG/`** por entrega.

## Responsabilidades

- **Desenvolvedores**: Seguir a estrutura definida para novos arquivos e diretórios
- **Governança**: Verificar conformidade com a estrutura durante revisões
- **Agentes de IA**: Identificar e corrigir estruturas inadequadas

## O Que NÃO Fazer

### ❌ Proibições Estritas

1. **NÃO** criar diretórios fora da estrutura definida sem autorização prévia
2. **NÃO** colocar documentação fora do diretório `docs/`
3. **NÃO** colocar arquivos de governança na raiz do repositório
4. **NÃO** misturar arquivos de configuração com código de aplicação
5. **NÃO** criar arquivos temporários na raiz do repositório
6. **NÃO** modificar fixtures para fazer workflows funcionarem (torne o workflow genérico)
7. **NÃO** criar scripts auxiliares fora de `.github/workflows/assets/`
8. **NÃO** adicionar arquivos sem validar autorização em `agent-governance.md`

**Violações destas regras devem resultar em PARADA imediata e solicitação de aprovação explícita.**

## Correção de Problemas

Se você encontrar arquivos ou diretórios que não seguem essa estrutura:

1. Identifique o local correto de acordo com este documento
2. Mova os arquivos para o local apropriado
3. Atualize todas as referências aos arquivos movidos
4. Documente a mudança em um commit claro

## Exemplos de Estruturas Corretas

### Workflow e sua documentação

```
.github/workflows/example.yml
.github/workflows/assets/example/
docs/example-workflow.md
```

### Ciclo de governança completo

```
CHANGELOG/20260201120000-plan.md
CHANGELOG/20260210120000-conclusion.md
docs/feature-documentation.md
```

### Configuração de agente

```
.github/agents/agent-example.md
```
