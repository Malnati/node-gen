<!-- .github/instructions/copilot-workflow.instructions.md -->

---

name: AI Agent CLI Workflow
description: Fluxo de trabalho recomendado para agentes de IA via CLI (explore → plan → review → implement → verify → commit)
version: 1.0.0
applies_to: complex_tasks, planning, implementation

---

# AI Agent CLI Workflow

## Fluxo: Explore → Plan → Review → Implement → Verify → Commit

Para **tarefas complexas**, siga este fluxo estruturado baseado nas melhores práticas de agentes de IA via CLI, adaptado para ambiente **headless** (Ubuntu não-interativo).

---

## 1. Explore (Exploração)

**Objetivo:** Entender o contexto ANTES de escrever código.

### Comandos de Exemplo

```bash
# Entender configurações
"Read the authentication files but don't write code yet"
"How is logging configured in this project?"

# Identificar padrões
"What's the pattern for adding a new API endpoint?"
"Where are the database migrations?"
"Explain the authentication flow"
```

### Adaptação Headless

- Use comandos diretos: `view`, `grep`, `glob`
- Evite navegação interativa
- Capture contexto completo em uma única execução
- Use `grep` com context flags (`-A`, `-B`, `-C`) para contexto adicional

### Exemplo Prático

```bash
# Buscar padrões de autenticação
grep -r "authentication" --include="*.ts" -n

# Listar arquivos de configuração
find . -name "*.config.js" -o -name "*.config.ts"

# Ver estrutura de diretório
tree -L 3 -I 'node_modules|dist'
```

---

## 2. Plan (Planejamento)

**Objetivo:** Criar plano estruturado ANTES da implementação.

### Comandos de Exemplo

```bash
/plan Implement password reset flow
/plan Add OAuth2 authentication with Google and GitHub providers
/plan Migrate all class components to functional components with hooks
```

### O Que Acontece

1. O agente analisa a solicitação e o codebase
2. Faz **perguntas de esclarecimento** para alinhar requisitos
3. Cria **plano estruturado com checkboxes**
4. Salva em `~/.copilot/session-state/{session-id}/plan.md` ou diretório equivalente
5. **AGUARDA aprovação** antes de implementar

### Adaptação Headless

```bash
# Inspecionar plano gerado
cat ~/.copilot/session-state/*/plan.md

# Visualizar plano via comando
/session plan

# Salvar plano para revisão
cp ~/.copilot/session-state/*/plan.md /tmp/review-plan.md
```

### Exemplo de Plano Gerado

```markdown
# Implementation Plan: OAuth2 Authentication

## Overview
Add social authentication using OAuth2 with Google and GitHub providers.

## Tasks
- [ ] Install dependencies (passport, passport-google-oauth20, passport-github2)
- [ ] Create authentication routes in `/api/auth`
- [ ] Implement passport strategies for each provider
- [ ] Add session management middleware
- [ ] Create login/logout UI components
- [ ] Add environment variables for OAuth credentials
- [ ] Write integration tests

## Detailed Steps
1. **Dependencies**: Add to package.json...
2. **Routes**: Create `/api/auth/google` and `/api/auth/github`...
```

---

## 3. Review (Revisão do Plano)

**Objetivo:** Validar e ajustar o plano ANTES da implementação.

### Comandos de Exemplo

```bash
"Check the plan, suggest modifications"
"Review the plan for security concerns"
/session plan
```

### ⚠️ Validação de Governança (OBRIGATÓRIA)

**Antes de aprovar o plano**, execute este checklist:

```
[ ] Arquivos planejados estão em CHANGELOG/*-plan.md?
[ ] Existe issue aprovada descrevendo as mudanças?
[ ] Há solicitação explícita do usuário no prompt?
[ ] Estrutura de diretórios conforme agent-files-structure.md?
```

**Se NENHUM critério atendido: PARAR e solicitar aprovação**

### Comandos de Validação

```bash
# Verificar se arquivos estão autorizados
for file in $(grep "^\- \[ \]" plan.md | sed 's/.*`\(.*\)`.*/\1/'); do
  grep -q "$file" CHANGELOG/*-plan.md && echo "✅ $file" || echo "❌ $file NOT AUTHORIZED"
done

# Buscar issues relacionadas
gh issue list --state open --json number,title,body | jq '.[] | select(.body | contains("OAuth"))'
```

### Ajustes no Plano

```bash
# Solicitar modificações
"Add error handling to the OAuth flow"
"Include rate limiting for authentication endpoints"
"Add comprehensive logging for debugging"
```

---

## 4. Implement (Implementação)

**Objetivo:** Executar o plano VALIDADO.

### Comandos de Exemplo

```bash
"Proceed with the plan"
"Implement this plan"
"Execute steps 1-3 of the plan"
```

### ⚠️ Governança Durante Implementação

A implementação **SOMENTE prossegue** se autorização foi validada na fase Review.

**Se durante implementação identificar necessidade de arquivo não previsto:**

1. ❌ PARAR implementação
2. 💬 INFORMAR necessidade ao usuário
3. ⏰ AGUARDAR aprovação explícita
4. ✅ Retomar após autorização

### Monitoramento da Implementação

```bash
# Visualizar progresso
/session plan  # Ver checkboxes atualizados

# Listar arquivos modificados
git status --short

# Ver diff das mudanças
git diff
```

---

## 5. Verify (Verificação)

**Objetivo:** Validar mudanças e corrigir falhas.

### Comandos de Exemplo

```bash
"Run the tests and fix any failures"
"Run linting and fix issues"
"npm run lint:fix && npm test"
"Validate the OAuth flow end-to-end"
```

### Adaptação Headless

```bash
# Executar testes em modo batch com logs completos
npm run lint:fix && npm test 2>&1 | tee /tmp/test-results.log

# Validar exit codes
npm run lint:fix && npm test || (echo "❌ Tests failed" && exit 1)

# Executar validações específicas
npm run test:auth -- --coverage
npm run test:e2e -- --headless
```

### Checklist de Verificação

```
[ ] Testes unitários passando
[ ] Testes de integração passando
[ ] Linting sem erros
[ ] Build sem erros
[ ] Nenhum secret commitado
[ ] Apenas arquivos autorizados modificados
[ ] Conformidade com agent-bash.md (se scripts Bash)
[ ] Conformidade com agent-actions.md (se workflows)
```

---

## 6. Commit (Finalização)

**Objetivo:** Consolidar mudanças com mensagem descritiva.

### Comandos de Exemplo

```bash
"Commit these changes with a descriptive message"
"Create a PR for this branch with detailed description"
"Commit with message: feat: implement OAuth2 authentication"
```

### Padrões de Commit (Conventional Commits)

```bash
feat: add OAuth2 authentication with Google and GitHub
fix: resolve session timeout in authentication flow
docs: update authentication documentation
refactor: simplify passport strategy initialization
test: add comprehensive OAuth2 integration tests
```

### Inclusão de Referências

```bash
# Referenciar issue
"feat: implement OAuth2 authentication

Implements social login with Google and GitHub providers.

Refs #123"

# Referenciar plano de governança
"feat: add new workflows

Implements workflows as planned in governance documentation.

Plan: CHANGELOG/YYYY-MM-DD-HHMM-plan.md
Refs #456"
```

### Validação Final Antes do Commit

```bash
# Listar arquivos staged
git diff --cached --name-only

# Validar arquivos autorizados
git diff --cached --name-only | while read file; do
  grep -q "$file" CHANGELOG/*-plan.md || echo "⚠️ $file not in governance plan"
done

# Verificar que não há secrets
git diff --cached | grep -iE '(password|secret|key|token).*=.*[^x]' && echo "⚠️ Possible secret detected"
```

---

## Comandos Úteis do AI Agent CLI

### Gestão de Contexto

```bash
/context              # Visualizar uso de contexto atual
/session              # Informações da sessão atual
/session plan         # Ver plano da sessão
/session checkpoints  # Ver checkpoints de compactação
/session files        # Ver arquivos temporários da sessão
```

### Controle de Permissões

```bash
/reset-allowed-tools  # Resetar ferramentas previamente aprovadas
--allow-tool 'shell(git:*)'      # Permitir todos comandos git
--deny-tool 'shell(git push)'    # Negar git push especificamente
```

### Seleção de Modelo

```bash
/model                # Trocar modelo disponível
```

**Recomendações:**
- **Modelos avançados**: Tarefas complexas, debugging difícil, refactoring sutil
- **Modelos balanceados**: Tarefas do dia-a-dia, rápido e eficiente
- **Modelos especializados**: Geração de código, code review

### Limpeza e Reset

```bash
/clear                # Limpar contexto entre tarefas não relacionadas
/new                  # Iniciar nova sessão
/compact              # Forçar compactação de contexto (raramente necessário)
```

---

## Integração com Governança

**TODAS as fases do workflow devem respeitar `.github/agents/agent-governance.md`:**

| Fase | Validação de Governança |
|------|-------------------------|
| **Explore** | Apenas leitura - sem validação necessária |
| **Plan** | Identificar arquivos que serão criados/modificados |
| **Review** | **VALIDAR autorização de TODOS os arquivos** |
| **Implement** | PARAR se autorização não validada |
| **Verify** | Confirmar apenas arquivos autorizados foram modificados |
| **Commit** | Validação final antes do commit |

### Fluxo de Autorização

```
Plan → Review → Validar Autorização → Approved? → Implement
                                          ↓ No
                                     STOP → Solicitar Aprovação
```

---

## Quando Usar Este Workflow

| Cenário | Usar Workflow? | Justificativa |
|---------|----------------|---------------|
| Implementação de nova feature complexa | ✅ SIM | Requer planejamento estruturado |
| Refactoring multi-arquivo | ✅ SIM | Alto impacto, precisa de plano |
| Migração de padrões (ex: class → functional) | ✅ SIM | Mudanças extensivas |
| Bug fix simples | ❌ NÃO | Overhead desnecessário |
| Mudança de uma linha | ❌ NÃO | Muito simples para workflow completo |
| Documentação isolada | ❌ NÃO | Baixo risco |

---

## Referências

- **Boas práticas de agentes de IA via CLI**: Documentação específica do agente utilizado
- **Governança**: `.github/agents/agent-governance.md`
- **Índice geral**: `AGENTS.md`
- **Configuração**: `opencode.json`
