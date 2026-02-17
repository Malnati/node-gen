<!-- .github/instructions/governance.instructions.md -->

---

name: Governance Instructions
description: Instruções de governança e autorização de arquivos para agentes de IA
version: 1.0.0
applies_to: file_operations, workflow_independence, fixture_isolation

---

# Governance Instructions

## ⚠️ REGRA CRÍTICA: Autorização Obrigatória

**NENHUM ARQUIVO pode ser criado ou modificado sem autorização prévia explícita.**

### Validação OBRIGATÓRIA Antes de Criar/Modificar Arquivos

Execute SEMPRE este checklist:

```
[ ] Identifiquei o arquivo: _______________
[ ] Verificar CHANGELOG/*-plan.md: autorizado? ___
[ ] Verificar issues abertas: existe solicitação? ___
[ ] Verificar prompt do usuário: solicitação explícita? ___
[ ] Validar estrutura (agent-files-structure.md): diretório permitido? ___
[ ] RESULTADO: Ao menos UM critério atendido? Se NÃO: PARAR
```

### Critérios de Autorização

Um arquivo PODE ser criado/modificado SE ao menos UM dos critérios:

1. ✅ **Plano de Governança**: Listado em `CHANGELOG/*-plan.md`
2. ✅ **Issue Aprovada**: Descrito em issue aberta e aprovada
3. ✅ **Solicitação Explícita**: Usuário solicitou explicitamente no prompt

### Se NENHUM Critério Atendido

1. ❌ **NÃO** criar/modificar o arquivo
2. ⏸️ **PARAR** execução imediatamente
3. 💬 **INFORMAR** ao usuário:
   - Qual arquivo seria necessário
   - Por que seria necessário
   - Qual autorização é necessária
4. ⏰ **AGUARDAR** aprovação explícita

### Comandos de Validação

```bash
# Verificar se arquivo está em plano de governança
grep -r "caminho/arquivo.ext" CHANGELOG/*-plan.md

# Buscar issues relacionadas
gh issue list --state open --search "arquivo.ext"

# Listar arquivos criados na branch
git diff --name-status origin/main | grep "^A"

# Listar arquivos modificados na branch
git diff --name-status origin/main | grep "^M"
```

## Workflow Independence (Independência de Workflows)

### Princípios Fundamentais

1. **Workflows devem ser genéricos e project-agnostic**
   - Não assumir estruturas específicas de projeto
   - Implementar detecção dinâmica de ferramentas
   - Criar fallback mechanisms genéricos

2. **Fixtures são para teste APENAS**
   - Fixtures são mock projects isolados
   - NÃO corrigir fixtures para fazer workflows funcionarem
   - Criar workarounds dentro dos fixtures quando necessário

3. **Detecção Dinâmica e Graceful Degradation**
   ```yaml
   - id: detect-node
     run: echo "has_node=$(command -v node && echo true || echo false)" >> $GITHUB_OUTPUT
   
   - if: steps.detect-node.outputs.has_node == 'true'
     run: npm test
   ```

### Validação de Independência

Antes de aprovar workflow, verificar:

- [ ] Não há hard-coded paths específicos de projeto
- [ ] Ferramentas são detectadas dinamicamente
- [ ] Existe fallback para ferramentas ausentes
- [ ] Workflow funciona com múltiplos tipos de projeto
- [ ] Documentação clara de dependências e escopo

### Exceções Legítimas

Workflows de **deploy** e **CLI** podem ter dependências específicas de repositório, mas devem documentar claramente suas limitações.

## Estrutura de Diretórios Aprovada

Arquivos SOMENTE podem ser criados em:

- `.github/` - Configurações GitHub (workflows, agents, actions)
- `docs/` - Documentação do projeto
- `fixtures/` - Mock projects para teste de workflows
- `/` (raiz) - APENAS arquivos de configuração global (README, LICENSE, etc.)

**Qualquer outro diretório requer autorização via issue ou plano.**

## Referências

- **Documentação completa**: `.github/agents/agent-governance.md`
- **Estrutura de arquivos**: `.github/agents/agent-files-structure.md`
- **Índice geral**: `AGENTS.md`
- **Configuração**: `opencode.json`

## Mensagem de Erro Padrão

Quando operação não autorizada:

```
❌ ERRO: Operação não autorizada

Arquivo: {caminho_do_arquivo}
Operação: {criar|modificar|mover|deletar}

Motivo: Arquivo não previsto em plano de governança, issue aprovada ou prompt explícito.

Ações necessárias:
1. Adicionar arquivo ao plano (CHANGELOG/*-plan.md), OU
2. Criar issue descrevendo a necessidade, OU
3. Solicitar explicitamente: "criar arquivo {caminho}"

Referências:
- .github/agents/agent-governance.md
- .github/agents/agent-files-structure.md
```
