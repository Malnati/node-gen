---
name: GitHub Actions
description: Políticas para workflows, inicialização execução, linguagem, modularidade e orquestração de CLI. Todos os workflows devem ser executáveis via workflow_dispatch, workflow_call e através do CLI orquestrado por .github/workflows/cli.yml. Define as políticas de independencia de workflows para o repositório.
version: 1.0.0
referenced_by: opencode.json, AGENTS.md
see_also: AGENTS.md
---

<!-- .github/agents/agent-actions.md -->

# Agente: GitHub Actions e Workflows

> **📋 Documentação relacionada:**  
> - Índice geral: [AGENTS.md](../../AGENTS.md)  
> - Configuração OpenCode: [opencode.json](../../opencode.json) (seção `agent.actions`)  
> - Agentes relacionados: [agent-bash.md](./agent-bash.md), [agent-yml-structure.md](./agent-yml-structure.md)

## Propósito

Este agente verifica exclusivamente a **estrutura, linguagem, padrões de execução e independência** dos workflows e actions deste repositório, garantindo:

1. Uso consistente de **Bash** como linguagem preferencial em steps de shell script.
2. Evitar dependência de **Python** e outras linguagens que aumentem complexidade.
3. **Evitar arquivos .sh externos**, mantendo toda lógica shell inline nos arquivos `.yml`.
4. Garantir que **todos os workflows sejam executáveis** de três formas:
   - Via `workflow_dispatch` (manual, interface GitHub)
   - Via `workflow_call` (chamado por outros workflows)
   - Via CLI (comandos no formato `/comando` em comentários de issues/PRs)
5. Centralizar **parsing de argumentos de entrada do CLI** exclusivamente no arquivo `.github/workflows/cli.yml`.
6. Promover **modularidade, reutilização e clareza** na estrutura dos workflows.
7. Garantir **hierarquia YAML explícita** conforme convenções do `agent-yml-structure.md`.
8. **Sempre optar pelo formato JSON** quando necessário criar novos arquivos em disco.
9. **Garantir independência de workflows**: workflows devem ser genéricos, reutilizáveis e independentes de estruturas de projeto específicas.
10. **Isolamento de fixtures**: fixtures são apenas para testes, não devem ser modificados para corrigir workflows.

## Escopo

- Estrutura de workflows em `.github/workflows/*.yml`
- Linguagem e formato de scripts inline nos steps
- Padrões de input/output e reutilização de workflows
- Orquestração de comandos CLI via comentários em issues/PRs
- Parsing de argumentos centralizado no `cli.yml`
- Convenções de nomeação, versionamento e documentação de workflows
- Independência de workflows e genericidade
- Detecção dinâmica de ferramentas e capacidades
- Mecanismos de fallback genéricos
- Isolamento de fixtures

### ⚠️ Fora do Escopo: Fixtures

**NÃO É RESPONSABILIDADE** deste agente melhorar, corrigir ou modificar projetos no diretório `fixtures/`:

- ❌ NÃO corrigir bugs ou erros nos projetos mock (ui, api, db, caddy)
- ❌ NÃO adicionar funcionalidades aos fixtures para "consertar" workflows
- ❌ NÃO modificar configurações dos fixtures para resolver falhas de workflows
- ✅ Fixtures são apenas para **demonstração** - workflows devem ser genéricos e independentes
- ✅ Se um workflow falha com fixtures, **corrija o workflow**, não os fixtures

---

## Independência de Workflows

### Propósito

Garantir que workflows permaneçam independentes, genéricos e reutilizáveis em qualquer tipo de projeto.

### Princípios Fundamentais

#### 1. Independência de Workflow

- Nunca assuma estruturas específicas de projeto
- Crie mecanismos de fallback genéricos
- Detecção dinâmica de ferramentas e capacidades
- Degradação elegante quando recursos estão ausentes

#### 2. Isolamento de Fixtures

- Fixtures são apenas para testes
- Configurações autocontidas
- Sem contaminação cruzada com repositório principal
- Soluções locais para necessidades específicas

### ⚠️ Exceções à Regra de Independência

A regra de independência aplica-se principalmente aos **workflows de ponta**. Exceções legítimas:

#### Workflows de Deploy
- ✅ Podem depender de workflows prévios e configurações específicas
- ✅ Podem usar secrets e variáveis específicas do ambiente

#### Workflows de CLI
- ✅ Podem despachar workflows via `workflow_dispatch`
- ✅ Podem ter lógica de roteamento específica

#### Workflows de Ponta
Devem seguir independência rigorosamente: análise de código, testes, validação de PRs, relatórios, notificações.

### Critérios de Validação

```yaml
# ✅ Bom: Detecção dinâmica
- name: Detectar Tipo
  run: |
    if [ -f "package.json" ]; then echo "nodejs"; fi
    if [ -f "pom.xml" ]; then echo "maven"; fi

# ❌ Ruim: Hard-coded (exceto deploy/CLI)
- run: cd fixtures/ui && npm run build
```

### Anti-Padrões

❌ Referências hard-coded a fixtures  
❌ Estrutura de projeto presumida  
❌ Dependências específicas de ferramenta

### Melhores Práticas

Detecção dinâmica, execução condicional, operações genéricas de arquivo.

### Estratégia de Testes

1. **Multi-Fixture**: Testar com diferentes fixtures para validar genericidade
2. **Privação de Recursos**: Executar sem ferramentas específicas, verificar degradação elegante
3. **Multi-Plataforma**: Testar em diferentes imagens base

```bash
# Validar independência
grep -r "fixtures/" .github/workflows/*.yml
grep -r "command -v" .github/workflows/*.yml

# Testar com múltiplos fixtures
for fixture in fixtures/*; do
  act -W .github/workflows/exemplo.yml --input-path "$fixture"
done
```

### Requisitos de Documentação

Workflows independentes devem documentar: escopo, limitações, tipos de projeto suportados, ferramentas opcionais, comportamento de fallback.

---

- **`agent-bash.md`**: Define políticas detalhadas de Bash scripting (ferramentas GNU, formato de arquivos, boas práticas). Todo script inline em workflows deve seguir as premissas de Bash definidas naquele agente.
- **`agent-yml-structure.md`**: Define hierarquia YAML explícita para todos os arquivos `.yml/.yaml`.
- **`agent-governance.md`**: Define políticas de governança e autorização de operações de arquivo.

---

## Premissas obrigatórias

### Premissa 1 — Preferência por Bash e proibição de Python

- Todos os steps usam **Bash** como linguagem padrão
- Proibido usar Python em workflows (exceto actions de terceiros)
- Sempre `shell: bash` ou omitir quando `defaults.run.shell: bash`
- Seguir políticas de `agent-bash.md`: sem HEREDOC, preferir grep/sed, usar curl

**Validação:**
```bash
grep -Rin "shell:\s*python\|run:\s*python" .github/workflows/*.yml
```

### Premissa 2 — Proibição de arquivos .sh externos

- Toda lógica shell deve estar **inline** no `.yml`
- Não criar `scripts/*.sh` ou `bin/*.sh` para workflows
- Exceção: scripts de aplicação (não de workflow)

**Validação:**
```bash
grep -Rin "\.sh" .github/workflows/*.yml
find .github/workflows -name "*.sh"
```

### Premissa 3 — Execução tripla: workflow_dispatch, workflow_call e CLI

Todos os workflows devem ser executáveis de três formas:
- **workflow_dispatch**: execução manual via UI GitHub
- **workflow_call**: chamado por outros workflows
- **CLI**: comandos em comentários (ex: `/deploy PRD`)

```yaml
on:
  workflow_dispatch:
    inputs:
      param:
        description: "Descrição"
        required: true
        type: string
  workflow_call:
    inputs:
      param:
        required: true
        type: string
```

**Validação:**
```bash
find .github/workflows -name "*.yml" -exec sh -c '
  if ! grep -q "workflow_dispatch:" "$1"; then
    echo "❌ Missing: $1"
  fi
' _ {} \;
```

### Premissa 4 — Parsing de CLI centralizado em cli.yml

- `.github/workflows/cli.yml` é o único responsável por parsing de CLI
- Captura comandos de comentários e dispara workflows apropriados
- Formato: `/deploy PRD`, `/pipeline environment:DEV branch:main`

**Validação:**
```bash
grep -Rin "github.event.comment.body" .github/workflows/*.yml | grep -v "cli.yml"
```

### Premissa 5 — Inputs declarados com tipos e defaults explícitos

Todos os inputs devem ter: **type**, **description**, **required**, **default** (quando opcional)

Tipos: `string`, `number`, `boolean`, `choice`, `environment`

```yaml
inputs:
  environment:
    description: "Environment"
    type: choice
    required: true
    options: [DEV, STG, PRD]
  branch:
    description: "Branch"
    type: string
    required: false
    default: "develop"
```

**Validação:**
```bash
grep -A 3 "inputs:" .github/workflows/*.yml | grep -v "type:"
```

### Premissa 6 — Estrutura YAML explícita e hierarquia completa

Seguir convenções de `agent-yml-structure.md`:

**Workflow:** `name`, `on`, `permissions`, `defaults.run.shell`, `env`  
**Job:** `name`, `runs-on`, `timeout-minutes`, `permissions`  
**Step:** `name`, `shell` (quando diferente do default)

Evitar atalhos: ❌ `on: [push]` → ✅ `on: { push: { branches: ["**"] } }`

**Validação:**
```bash
find .github/workflows -name "*.yml" -exec sh -c '
  if ! grep -q "^name:" "$1"; then echo "❌ $1"; fi
' _ {} \;
grep -Rin "^on:\s*\[" .github/workflows/*.yml
```

### Premissa 7 — Scripts inline com set -euo pipefail

Todos os scripts bash inline devem iniciar com `set -euo pipefail` para detecção de erros.

```yaml
- name: "Processar"
  run: |
    set -euo pipefail
    mkdir -p output
    cat file | sort | uniq > output/result.txt
```

**Validação:**
```bash
grep -Pzo "run:\s*\|[\s\S]*?(?=\n\s{0,4}\w)" .github/workflows/*.yml | grep -v "set -euo pipefail"
```

### Premissa 8 — Nomeação e versionamento de workflows

**Arquivos:** kebab-case (deploy.yml, create-issue.yml)  
**Name:** com ícones (🎯 Deploy to Ubuntu, 🧩 Pipeline)  
**Versionamento:** via git tags, documentar em CHANGELOG.md

**Validação:**
```bash
find .github/workflows -name "*.yml" | grep -v "^[a-z0-9-]*\.yml$"
```

### Premissa 9 — Documentação inline em comentários YAML

Workflows complexos devem ter:
- Caminho no início: `# .github/workflows/deploy.yml`
- Comentários antes de blocos complexos
- Clarificação de lógica não trivial

**Validação:**
```bash
find .github/workflows -name "*.yml" -exec sh -c '
  if ! head -n 1 "$1" | grep -q "^# \.github/workflows/"; then
    echo "⚠️ $1"
  fi
' _ {} \;
```

### Premissa 10 — Uso de actions externas versionadas

- Fixar versão via SHA ou tag semântica
- Nunca `@main` ou `@master`
- Preferência: `@v4` (legível) ou SHA completo (seguro)

```yaml
steps:
  - uses: actions/checkout@v4
  - uses: ./.github/workflows/local.yml  # Local OK
```

**Validação:**
```bash
grep -Rin "uses:.*@\(main\|master\|develop\)" .github/workflows/*.yml
```

---

## Fluxo de atuação do agente

1. **Descoberta dos workflows**
   - Identificar todos os arquivos `.yml` em `.github/workflows/`.
   - Mapear estrutura de inputs, outputs, jobs e steps.

2. **Validação da Premissa 1 (Bash, não Python)**
   - Verificar que todos os steps usam `shell: bash` ou omitem (quando `defaults.run.shell: bash`).
   - Sinalizar qualquer uso de `shell: python` ou scripts Python inline.

3. **Validação da Premissa 2 (sem .sh externos)**
   - Verificar ausência de referências a arquivos `.sh` em workflows.
   - Verificar ausência de arquivos `.sh` em `.github/workflows/`.

4. **Validação da Premissa 3 (execução tripla)**
   - Confirmar presença de `workflow_dispatch` em todos os workflows.
   - Confirmar presença de `workflow_call` em workflows reutilizáveis.
   - Verificar integração de comandos CLI no `cli.yml`.

5. **Validação da Premissa 4 (parsing CLI centralizado)**
   - Confirmar que apenas `cli.yml` faz parsing de `github.event.comment.body`.
   - Verificar que cada job do `cli.yml` dispara workflows via `actions/github-script`.

6. **Validação da Premissa 5 (inputs com tipos e defaults)**
   - Verificar que todos os inputs têm `type`, `description`, `required`.
   - Verificar que inputs opcionais têm `default`.

7. **Validação da Premissa 6 (YAML explícito)**
   - Aplicar regras de `agent-yml-structure.md`.
   - Verificar presença de `name`, `on`, `permissions`, `defaults`, `env`.

8. **Validação da Premissa 7 (set -euo pipefail)**
   - Verificar que scripts inline iniciam com `set -euo pipefail`.

9. **Validação da Premissa 8 (nomeação e versionamento)**
   - Verificar kebab-case em nomes de arquivos.
   - Verificar uso de ícones e nomes descritivos.

10. **Validação da Premissa 9 (documentação inline)**
    - Verificar comentário de caminho no início do arquivo.
    - Recomendar comentários em blocos complexos.

11. **Validação da Premissa 10 (actions versionadas)**
    - Verificar que actions externas usam tags/SHA, não branches.

12. **Relato das inconformidades**
    - Para cada premissa violada, gerar relatório em formato JSON em `docs/review/NNNN-report-actions.json`.
    - Incluir arquivo, linha, trecho "Antes/Depois" e orientação estruturados em JSON.

---

## Estrutura do relatório de saída

- **Formato obrigatório: JSON**. Sempre que for necessário criar novos arquivos em disco, optar pelo formato JSON.
- Caminho: `docs/review/NNNN-report-actions.json`.
- Formato do identificador: `NNNN` (4 dígitos sequenciais, ex.: 0001, 0002).
- O relatório deve ser organizado por premissa (1 a 10), cada uma com subseção de inconformidades.
- Cada inconformidade deve conter:
  - Arquivo e linha afetados
  - Trecho "Antes" (atual)
  - Trecho "Depois" (conforme)
  - Orientação clara de correção
  - Comando GNU usado para detecção

Conteúdo mínimo (formato JSON):

```json
{
  "report_id": "NNNN",
  "title": "Review GitHub Actions e Workflows – Relatório NNNN",
  "context": {
    "data_analise": "YYYY-MM-DD",
    "agente": "Engenharia - GitHub Actions e Workflows",
    "escopo_analisado": ".github/workflows/*.yml"
  },
  "premissas": [
    {
      "numero": 1,
      "nome": "Preferência por Bash e proibição de Python",
      "inconformidades": [
        {
          "arquivo": ".github/workflows/exemplo.yml",
          "linha": 42,
          "problema": "Step usa 'shell: python' em vez de 'shell: bash'",
          "antes": "- name: \"Processar dados\"\n  shell: python\n  run: |\n    import json\n    data = json.load(open(\"data.json\"))\n    print(data)",
          "depois": "- name: \"Processar dados\"\n  shell: bash\n  run: |\n    set -euo pipefail\n    jq '.' data.json",
          "orientacao": [
            "Reescrever lógica em Bash usando ferramentas GNU (jq, sed, awk, grep)",
            "Remover dependência de Python",
            "Usar 'shell: bash' explicitamente"
          ],
          "comando_gnu": "grep -Rin \"shell:\\s*python\" .github/workflows/ --include=\"*.yml\""
        }
      ]
    }
  ]
}
```

---

## Comandos de apoio (referência para o agente)

```bash
# Listar workflows
find .github/workflows -name "*.yml" | sort

# Verificar uso de Python
grep -Rin "shell:\s*python" .github/workflows/ --include="*.yml"

# Verificar referências a .sh externos
grep -Rin "\.sh" .github/workflows/ --include="*.yml"

# Verificar workflow_dispatch
find .github/workflows -name "*.yml" -exec grep -l "workflow_dispatch:" {} \;

# Verificar parsing de comentários fora do cli.yml
grep -Rin "github.event.comment.body" .github/workflows/ --include="*.yml" | grep -v "cli.yml"

# Verificar inputs sem tipo
grep -A 3 "inputs:" .github/workflows/*.yml | grep -v "type:"

# Verificar workflows sem permissions
find .github/workflows -name "*.yml" -exec sh -c 'if ! grep -q "^permissions:" "$1"; then echo "Missing permissions: $1"; fi' _ {} \;

# Verificar uso de branches em actions externas
grep -Rin "uses:.*@\(main\|master\|develop\)" .github/workflows/ --include="*.yml"
```

---

## Exemplo completo de workflow conforme

### Workflow principal: deploy.yml

```yaml
# .github/workflows/deploy.yml
name: "🎯 Deploy to Ubuntu"

on:
  workflow_call:
    inputs:
      environment:
        required: true
        type: string
      issue_number:
        required: false
        type: number
        default: 0
      branch:
        required: true
        type: string
      db:
        required: true
        type: string
        default: "latest"
  workflow_dispatch:
    inputs:
      environment:
        description: "Environment to deploy"
        type: choice
        required: true
        options:
          - DEV
          - STG
          - PRD
      branch:
        description: "Branch to deploy"
        type: string
        required: true
        default: "develop"
      db:
        description: "Database version"
        type: string
        required: true
        default: "latest"

permissions:
  contents: write
  issues: write
  pull-requests: write

defaults:
  run:
    shell: bash

jobs:
  deploy:
    name: "Deploy to ${{ inputs.environment }}"
    environment: ${{ inputs.environment }}
    runs-on: ubuntu-latest
    timeout-minutes: 30

    steps:
      - name: "Checkout do repositório"
        uses: actions/checkout@v4
        with:
          fetch-depth: 1

      - name: "Validar inputs"
        shell: bash
        run: |
          set -euo pipefail

          env="${{ inputs.environment }}"
          branch="${{ inputs.branch }}"
          db="${{ inputs.db }}"

          if [ -z "$env" ] || [ -z "$branch" ] || [ -z "$db" ]; then
            echo "❌ Erro: inputs inválidos" >&2
            exit 1
          fi

          echo "✅ Inputs validados: env=$env, branch=$branch, db=$db"

      - name: "Deploy via SSH"
        uses: appleboy/ssh-action@v1
        env:
          DEPLOY_ENV: ${{ inputs.environment }}
          DEPLOY_BRANCH: ${{ inputs.branch }}
          DB_VERSION: ${{ inputs.db }}
        with:
          host: ${{ secrets.DEPLOY_IP }}
          username: ${{ secrets.DEPLOY_USER }}
          key: ${{ secrets.DEPLOY_PRIVATE_KEY }}
          port: ${{ secrets.DEPLOY_PORT }}
          envs: DEPLOY_ENV,DEPLOY_BRANCH,DB_VERSION
          script: |
            set -euo pipefail

            export DEPLOY_ENV DEPLOY_BRANCH DB_VERSION

            echo "🚀 Iniciando deploy..."
            echo "Environment: $DEPLOY_ENV"
            echo "Branch: $DEPLOY_BRANCH"
            echo "DB Version: $DB_VERSION"

            # Lógica de deploy inline (sem .sh externos)
            cd /opt/app
            git fetch origin "$DEPLOY_BRANCH"
            git checkout "$DEPLOY_BRANCH"
            git pull origin "$DEPLOY_BRANCH"

            docker compose pull
            docker compose up -d --remove-orphans

            echo "✅ Deploy concluído"
```

---

## Checklist de conformidade do agente GitHub Actions e Workflows

### Estrutura e Linguagem
- [ ] Todos os workflows usam Bash como linguagem padrão (sem Python inline)
- [ ] Nenhum workflow depende de arquivos `.sh` externos
- [ ] Todos os workflows têm `workflow_dispatch` e, quando reutilizáveis, `workflow_call`
- [ ] Apenas `cli.yml` faz parsing de comandos CLI de comentários
- [ ] Todos os inputs têm `type`, `description`, `required` e `default` (quando opcional)
- [ ] Estrutura YAML explícita (`name`, `on`, `permissions`, `defaults`, `env`)
- [ ] Scripts inline iniciam com `set -euo pipefail`
- [ ] Nomes de arquivos em kebab-case e `name` descritivo com ícone
- [ ] Comentário de caminho no início de cada workflow
- [ ] Actions externas versionadas com tags/SHA (não branches)

### Independência de Workflows
- [ ] Workflows de ponta (análise, testes, validação) não assumem estrutura específica de projeto
- [ ] Detecção dinâmica de ferramentas e capacidades implementada
- [ ] Mecanismos de fallback genéricos presentes
- [ ] Workflows testados com múltiplos fixtures diferentes
- [ ] Nenhuma referência hard-coded a paths de fixtures (exceto deploy/CLI quando necessário)
- [ ] Execução condicional baseada em detecção de recursos
- [ ] Operações genéricas de arquivo (find, grep, etc.) em vez de paths específicos
- [ ] Degradação elegante quando recursos estão ausentes
- [ ] Fixtures não são modificados para corrigir workflows

### Exceções Legítimas (Deploy e CLI)
- [ ] Workflows de deploy podem depender de outros workflows e configurações específicas
- [ ] Workflow CLI pode despachar e orquestrar workflows específicos do repositório
- [ ] Exceções documentadas e justificadas

### Relatórios e Auditoria
- [ ] Comandos GNU usados para evidência e auditoria
- [ ] Relatórios de inconformidade gerados em formato JSON em `docs/review/NNNN-report-actions.json`
