<!-- .github/copilot-instructions.md -->

---

name: AI Agent Instructions
description: Instruções para agentes de código baseados em IA
version: 2.0.0

---

# AI Agent Instructions

## Visão Geral do Repositório

Este repositório é dedicado **exclusivamente à automação via GitHub Actions**. Aqui são mantidos workflows, utilitários e padrões para CI/CD, automação de checagens, notificações, lint, testes e governança de repositórios do ecossistema MBRA.

Não há mais scripts ou arquivos de deploy, gerenciamento de infraestrutura, banco de dados, Caddy, OAuth2, ou Docker Compose neste repositório.

## Estrutura do Projeto

- **`.github/workflows/`**: Fluxos automatizados do GitHub Actions (CI, CD, lint, notificações, utilidades)
- **`.github/agents/`**: Agentes customizados de conformidade, governança e padrões para workflows
- **`docs/`**: Documentação interna sobre fluxos, automação, padrões e agentes

## Stack Tecnológico

- **Automação**: GitHub Actions (principal)
- **Linguagem dos scripts**: YAML (workflows) e Bash/Node.js (quando necessário como utilitário de steps)
- **Governança/Conformidade**: Definida no diretório `.github/agents/`
- **Notificações**: Actions customizadas para integrar bots/chatops (ex: Slack, Teams, Discord)

## Padrões de Workflow

- Workflows devem ser modulares, reutilizáveis e de fácil manutenção
- Sempre documentar as entradas, outputs e objetivos do workflow
- Usar naming consistente definido em `.github/agents/agent-engineering-docker-stack.md` e `.github/agents/agent-engineering-hardcoded.md`
- Seguir padrões de cabeçalho de caminho definidos em `.github/agents/agent-engineering-cabecalho-caminho.md`
- Utilizar secrets do GitHub para credenciais e tokens necessários
- Utilizar Matrix para jobs quando aplicável
- Adicionar checagens de sintaxe/linter sempre que possível
- Descrever claramente em comentários as dependências, responsabilidades e triggers do workflow

## Boas Práticas

1. **Mudanças Cirúrgicas**: Sempre que ajustar um workflow, faça mudanças pontuais e totalmente documentadas.
2. **Segurança**: Nunca vaze secrets, e priorize uso de GitHub Environments/Secrets.
3. **Testabilidade**: Automatize validações para garantir robustez nos fluxos antes de promover para uso geral.
4. **Documentação**: Atualize `docs/` e o cabeçalho do workflow/arquivo sempre ao efetuar mudanças relevantes.

## AI Agent CLI - Workflow Recomendado

### Fluxo: Explore → Plan → Review → Implement → Verify → Commit

Para tarefas complexas, siga este fluxo estruturado:

#### **1. Explore** (Exploração sem modificação)
```bash
# Entenda o código antes de modificar
"Read the authentication files but don't write code yet"
"How is logging configured in this project?"
"What's the pattern for adding a new API endpoint?"
```

**Adaptação para ambiente headless:**
- Use comandos diretos de leitura (view, grep, glob)
- Evite navegação interativa
- Capture contexto completo antes de prosseguir

#### **2. Plan** (Planejamento estruturado)
```bash
# Crie um plano antes de implementar
/plan Implement password reset flow
/plan Add OAuth2 authentication with Google providers
```

**Comportamento:**
- O agente faz perguntas de esclarecimento
- Cria plano estruturado com checkboxes
- Salva em `~/.copilot/session-state/{session-id}/plan.md` ou equivalente
- **Aguarda aprovação antes de implementar**

**Validação em ambiente headless:**
```bash
# Inspecione o plano gerado
cat ~/.copilot/session-state/*/plan.md
# Valide conformidade com governança antes de prosseguir
```

#### **3. Review** (Revisão do plano)
```bash
# Revise e ajuste o plano
"Check the plan, suggest modifications"
/session plan  # Visualizar plano atual
```

**⚠️ Validação de Governança (OBRIGATÓRIA):**
Antes de aprovar o plano, verifique:
- [ ] Arquivos planejados estão em `CHANGELOG/*-plan.md`?
- [ ] Existe issue aprovada descrevendo mudanças?
- [ ] Há solicitação explícita do usuário?
- [ ] Estrutura de diretórios está conforme `agent-files-structure.md`?

**Se NENHUM critério atendido: PARAR e solicitar aprovação**

#### **4. Implement** (Implementação controlada)
```bash
# Execute o plano aprovado
"Proceed with the plan"
"Implement this plan"
```

**⚠️ Governança:** Implementação só prossegue se autorização validada na fase Review

#### **5. Verify** (Verificação)
```bash
# Valide as mudanças
"Run the tests and fix any failures"
"npm run lint:fix && npm test"
```

**Em ambiente headless:**
```bash
# Execute testes em modo batch
npm run lint:fix && npm test || exit 1
```

#### **6. Commit** (Finalização)
```bash
# Consolide mudanças
"Commit these changes with a descriptive message"
"Create a PR for this branch with detailed description"
```

**Padrões de commit:**
- Use Conventional Commits (`feat:`, `fix:`, `docs:`, etc.)
- Referencie issues: `Refs #123`
- Referencie planos: `Plan: CHANGELOG/2026-02-04-plan.md`

### Comandos Úteis

```bash
# Contexto e sessão
/context              # Uso de contexto
/session              # Info da sessão
/session plan         # Ver plano atual
/session checkpoints  # Ver checkpoints

# Controle
/clear                # Limpar contexto
/new                  # Nova sessão
/reset-allowed-tools  # Resetar permissões

# Modelos
/model                # Trocar modelo (Opus/Sonnet/Codex)
```

### Integração com Governança

**TODAS as fases do workflow devem respeitar agent-governance.md:**

1. **Planning**: Validar autorização de arquivos planejados
2. **Review**: Confirmar conformidade com estrutura e permissões
3. **Implement**: PARAR se autorização não validada
4. **Commit**: Verificar apenas arquivos autorizados foram modificados

**Comandos de validação:**
```bash
# Verificar arquivos autorizados
grep -r "caminho/arquivo.ext" CHANGELOG/*-plan.md

# Listar issues relacionadas
gh issue list --state open --search "arquivo.ext"

# Verificar estrutura
# Consulte .github/agents/agent-files-structure.md
```

## Convenções para Cabeçalhos de Caminho

- Todo arquivo YAML de workflow deve iniciar com seu caminho relativo em comentário, exemplo:
  - `# .github/workflows/validacao.yml`
- Veja detalhes e obrigatoriedade em `.github/agents/agent-engineering-cabecalho-caminho.md`

## Recomendações de Implementação

- Use preferencialmente Node.js ou Bash para scripts utilitários embutidos em passos dos workflows
- Referencie agentes de governança e utilidades via `.github/agents/`
- Mantenha workflows enxutos e focados em uma só responsabilidade
- Priorize documentação em português (projeto brasileiro)

## Fora de Escopo

✗ NÃO gerencie código de aplicação, deploy, bancos, Caddy, OAuth2, Docker Compose neste repositório  
✗ NÃO armazene segredos, chaves ou configurações sensíveis fora do GitHub Secrets

## Notas para Assistência de IA

- Sempre consulte e siga as convenções de `.github/agents/` antes de recomendar mudanças
- Sugestões devem focar: melhoria de workflows, automação CI/CD, boas práticas de YAML Actions e governança
- Considere impacto na orquestração de notificações e padronização de rotinas de checagem

## Referências

- `.github/agents/` — agentes de conformidade e governança
- `docs/` — documentação técnica sobre os workflows
- `README.md` — visão geral dos objetivos dos fluxos
