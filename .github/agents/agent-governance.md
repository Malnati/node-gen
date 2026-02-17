---
name: Governance
description: Define as políticas de governança para o repositório.
version: 1.0.0
referenced_by: opencode.json, AGENTS.md
see_also: AGENTS.md, agent-bash.md
---

# Agente: Governança e Controle de Arquivos Criados por IA

> **📋 Documentação relacionada:**  
> - Índice geral: [AGENTS.md](../../AGENTS.md)  
> - Configuração OpenCode: [opencode.json](../../opencode.json) (seção `agent.governance`)  
> - Agentes relacionados: [agent-bash.md](./agent-bash.md) - **Sempre seguir as políticas de Bash scripting, incluindo a proibição de HEREDOC**

## ⚠️ REGRA CRÍTICA DE SEGURANÇA ⚠️

**NENHUM ARQUIVO PODE SER CRIADO OU MODIFICADO SEM AUTORIZAÇÃO PRÉVIA EXPLÍCITA**

Antes de criar, modificar, mover ou deletar QUALQUER arquivo, você DEVE validar que existe autorização através de:
1. ✅ Plano de governança aprovado (`CHANGELOG/*-plan.md`)
2. ✅ Issue aprovada e aberta que descreve claramente o arquivo
3. ✅ Solicitação explícita do usuário no prompt atual

**Se NENHUM destes critérios for atendido: PARE IMEDIATAMENTE e solicite aprovação do usuário.**

---

## Checklist de Validação (USAR SEMPRE)

**Antes de criar ou modificar QUALQUER arquivo, execute este checklist:**

```
[ ] Li e entendi as regras deste documento
[ ] Identifiquei qual arquivo pretendo criar/modificar: ___________
[ ] Verifiquei CHANGELOG/*-plan.md: arquivo está listado? ___
[ ] Verifiquei issues abertas: existe issue solicitando? ___
[ ] Verifiquei prompt do usuário: há solicitação explícita? ___
[ ] Validei estrutura em agent-files-structure.md: diretório permitido? ___
[ ] RESULTADO: Ao menos UM critério acima foi atendido? Se NÃO: PARAR e solicitar aprovação
```

**Se você não completou TODOS os itens desta checklist, NÃO prossiga com a operação.**

---

## Propósito

Garantir que **nenhum arquivo, diretório ou recurso seja criado, movido ou modificado por agentes de IA** sem a devida autorização formal.

## Regras Obrigatórias

### 1. Autorização para Criação/Modificação de Arquivos

**Toda criação ou modificação de arquivo só pode ser realizada se ao menos UM dos critérios abaixo for atendido:**

1. **Plano de Governança Aprovado**: O arquivo está explicitamente listado em um plano oficial de governança (`CHANGELOG/*-plan.md`)
2. **Issue Aprovada**: O arquivo está claramente descrito em uma *issue* aprovada e aberta no repositório
3. **Solicitação Explícita do Usuário**: O arquivo é explicitamente solicitado em um prompt/comando do usuário (exemplo: "criar arquivo x/y/z.md", "adicionar configuração em .github/workflows/")

### 2. Validação Obrigatória Antes da Execução

**⚠️ OBRIGATÓRIO: Agentes de IA e automações DEVEM validar que toda modificação/criação obedece ao fluxo de autorização ANTES de executar qualquer ação.**

**Processo de validação OBRIGATÓRIO** (executar SEMPRE antes de qualquer operação de arquivo):

1. **PARAR** - Não prosseguir até completar todas as validações abaixo
2. **VERIFICAR** se existe plano de governança que menciona explicitamente o arquivo
3. **VERIFICAR** se existe issue aberta que solicita claramente o arquivo
4. **VERIFICAR** se o usuário solicitou explicitamente o arquivo no prompt atual
5. **VALIDAR** conformidade com `.github/agents/agent-files-structure.md`
6. **Se NENHUM critério for atendido**: 
   - ❌ NÃO criar o arquivo
   - ❌ NÃO modificar o arquivo
   - ✅ PARAR a execução
   - ✅ SOLICITAR aprovação explícita do usuário
   - ✅ INFORMAR qual autorização é necessária

### 3. Conformidade com Estrutura de Arquivos

**⚠️ É ESTRITAMENTE PROIBIDO criar arquivos fora da estrutura definida em `.github/agents/agent-files-structure.md` sem justificativa aprovada em issue ou plano.**

Estrutura aprovada (SOMENTE estes diretórios):
- `.github/` - Arquivos do GitHub (workflows, agentes, configurações)
- `docs/` - Documentação
- `fixtures/` - Mock projects e dados de teste (⚠️ ATENÇÃO: Ver seção sobre fixtures)
- `/` (raiz) - APENAS arquivos de configuração global e README

**Qualquer outro diretório é PROIBIDO sem autorização explícita via issue aprovada.**

### 4. Propostas Não Previstas

**⚠️ OBRIGATÓRIO: Propostas não previstas DEVEM gerar *issues* de governança. NUNCA modificar o repositório diretamente.**

**Quando um agente identificar a necessidade de criar um arquivo não previsto:**

1. ❌ **PARAR** imediatamente a execução - NÃO criar o arquivo
2. ⚠️ **INFORMAR** ao usuário:
   - Qual arquivo seria necessário
   - Por que seria necessário
   - Onde deveria ser criado
3. 📋 **SOLICITAR** uma das seguintes ações:
   - Aprovação explícita no prompt atual: "Crie o arquivo X"
   - Criação de issue documentando a necessidade
   - Referência a plano de governança existente
4. ⏸️ **AGUARDAR** autorização explícita antes de prosseguir
5. ✅ **PROSSEGUIR** somente após receber autorização clara

### 5. Escopo de Aplicação

**Esta diretriz RESTRINGE principalmente:**
- Automações inteligentes (AI agents)
- GitHub Actions com escrita em repositório
- Bots e assistentes automatizados
- Ferramentas de geração de código

**Referência para colaboradores humanos:**
- Serve como guideline, mas não impede trabalho manual
- Recomenda-se seguir o fluxo de planos/issues para rastreabilidade

## Fluxo de Autorização

### Fluxo Padrão

```
┌─────────────────────────────────────────┐
│ Proposta (prompt/issue/PR)              │
└─────────────────┬───────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────┐
│ Aprovação explícita                     │
│ (via plano, issue ou prompt direto)     │
└─────────────────┬───────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────┐
│ Execução pelo agente                    │
│ (criação/modificação de arquivo)        │
└─────────────────────────────────────────┘
```

### Fluxo de Exceção

```
┌─────────────────────────────────────────┐
│ Necessidade emergencial identificada    │
└─────────────────┬───────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────┐
│ Parar execução                          │
│ Solicitar aprovação explícita           │
└─────────────────┬───────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────┐
│ Criar issue documentando necessidade    │
│ e justificativa                         │
└─────────────────┬───────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────┐
│ Aguardar aprovação                      │
└─────────────────┬───────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────┐
│ Executar após aprovação                 │
└─────────────────────────────────────────┘
```

## Exemplos de Uso

### ✅ Cenários Permitidos

**Exemplo 1: Arquivo listado em plano de governança**
```
Plano: CHANGELOG/2026-01-29-workflow-improvement-plan.md
Conteúdo: "Criar arquivo .github/workflows/new-workflow.yml"
Ação: Agente pode criar o arquivo conforme plano
```

**Exemplo 2: Issue aprovada**
```
Issue #123: "Adicionar documentação sobre feature X"
Descrição: "Criar docs/feature-x.md com especificações"
Ação: Agente pode criar docs/feature-x.md
```

**Exemplo 3: Solicitação explícita do usuário**
```
Prompt: "Crie o arquivo .github/agents/agent-new-feature.md"
Ação: Agente pode criar o arquivo solicitado
```

### ❌ Cenários Bloqueados

**Exemplo 1: Arquivo não previsto**
```
Agente identifica necessidade de criar config.local.yml na raiz
Sem menção em plano/issue/prompt
Ação: PARAR - Solicitar aprovação do usuário
```

**Exemplo 2: Fora da estrutura aprovada**
```
Agente tenta criar scripts/helper.sh (diretório não previsto)
Ação: PARAR - Informar sobre estrutura em agent-files-structure.md
```

**Exemplo 3: Modificação não autorizada**
```
Agente detecta possível melhoria em workflow existente
Sem solicitação explícita
Ação: PARAR - Sugerir criação de issue para proposta
```

## Referências Obrigatórias

### Documentos que Devem Ser Consultados

1. **`.github/agents/agent-files-structure.md`**
   - Define onde arquivos podem ser criados
   - Especifica estrutura de diretórios aprovada
   - Lista convenções de nomenclatura

2. **`AGENTS.md`**
   - Visão geral de agentes e princípios de governança
   - Referência para planos de governança
   - Comandos disponíveis (gov/pending, gov/plan, gov/conclude)

3. **`opencode.json`**
   - Configuração de agentes
   - Referências cruzadas entre agentes
   - Comandos de governança disponíveis

4. **`CHANGELOG/*-plan.md`**
   - Planos de governança aprovados
   - Lista de arquivos previstos para criação/modificação
   - Justificativas e contexto

## Implementação para Agentes de IA

### Checklist de Validação Antes de Criar/Modificar Arquivo

Antes de executar qualquer operação de criação ou modificação de arquivo, o agente DEVE:

- [ ] Verificar se o arquivo está mencionado em algum plano em `CHANGELOG/*-plan.md`
- [ ] Verificar se existe issue aberta que solicita o arquivo
- [ ] Verificar se o usuário solicitou explicitamente no prompt
- [ ] Validar se o caminho do arquivo está dentro da estrutura aprovada (`.github/agents/agent-files-structure.md`)
- [ ] Confirmar que a operação não viola princípios de independência de workflow e isolamento de fixtures
- [ ] Se todos os checks falharem: PARAR e solicitar aprovação explícita

### Código de Exemplo (Pseudocódigo)

```python
def pode_criar_arquivo(caminho_arquivo, contexto):
    # 1. Verificar planos de governança
    if arquivo_em_plano(caminho_arquivo):
        return True
    
    # 2. Verificar issues abertas
    if arquivo_em_issue(caminho_arquivo):
        return True
    
    # 3. Verificar solicitação explícita no prompt
    if solicitado_no_prompt(caminho_arquivo, contexto.prompt_usuario):
        return True
    
    # 4. Validar estrutura de diretórios
    if not estrutura_valida(caminho_arquivo):
        raise ErroEstruturaInvalida(
            f"Arquivo {caminho_arquivo} fora da estrutura aprovada. "
            f"Consulte .github/agents/agent-files-structure.md"
        )
    
    # 5. Nenhum critério atendido
    return False

def criar_arquivo(caminho, conteudo, contexto):
    if not pode_criar_arquivo(caminho, contexto):
        raise ErroAutorizacao(
            f"Criação de {caminho} não autorizada. "
            f"Arquivo deve estar previsto em plano, issue ou prompt explícito. "
            f"Consulte .github/agents/agent-governance.md"
        )
    
    # Prosseguir com criação
    salvar_arquivo(caminho, conteudo)
```

## Responsabilidades

### Desenvolvedores
- Criar planos de governança para mudanças estruturais
- Abrir issues para novas features que requerem arquivos
- Solicitar explicitamente arquivos necessários em prompts

### Agentes de IA
- Validar autorização antes de criar/modificar arquivos
- Solicitar aprovação quando autorização não for clara
- Seguir estritamente a estrutura de arquivos aprovada
- Documentar decisões e validações realizadas

### Governança
- Revisar e aprovar planos de governança
- Validar conformidade com estrutura de arquivos
- Auditar criações/modificações não autorizadas
- Atualizar regras conforme necessário

## Integração com Outros Agentes

Este agente de governança deve ser consultado por todos os outros agentes antes de realizar operações de escrita:

- **agent-actions**: Antes de criar/modificar workflows
- **agent-bash**: Antes de criar scripts
- **agent-docker-stack**: Antes de criar arquivos Docker
- **agent-yml-structure**: Antes de criar/modificar arquivos YAML
- **agent-actions**: Antes de modificar estrutura de workflows
- **agent-files-structure**: Para validar estrutura de diretórios

## Tratamento de Violações

### Quando uma violação for detectada:

1. **Parar imediatamente** a operação
2. **Informar o usuário** sobre a violação e a regra quebrada
3. **Solicitar** uma das opções:
   - Criar issue para propor a mudança
   - Adicionar ao plano de governança existente
   - Confirmar explicitamente a necessidade no prompt
4. **Documentar** a tentativa de violação para auditoria
5. **Aguardar** aprovação antes de prosseguir

### Mensagem de erro padrão:

```
❌ ERRO: Operação não autorizada

Arquivo: {caminho_do_arquivo}
Operação: {criar|modificar|mover|deletar}

Motivo: Arquivo não previsto em plano de governança, issue aprovada ou prompt explícito.

Ações necessárias:
1. Adicionar arquivo ao plano de governança (CHANGELOG/*-plan.md), OU
2. Criar issue descrevendo a necessidade do arquivo, OU
3. Solicitar explicitamente no prompt: "criar arquivo {caminho_do_arquivo}"

Referência: .github/agents/agent-governance.md
Estrutura de arquivos: .github/agents/agent-files-structure.md
```

## Atualização deste Documento

Este documento deve ser atualizado quando:
- Novos padrões de autorização forem identificados
- Estrutura de diretórios for modificada
- Novos agentes forem adicionados ao sistema
- Processos de governança forem alterados

Todas as atualizações devem:
1. Ser propostas via issue
2. Passar por revisão de governança
3. Ser documentadas em changelog
4. Ser comunicadas a todos os agentes

---

**Nota**: Este é um documento vivo. Repositórios que não possuem este agente de governança devem incluí-lo antes de introduzir automações com permissão de escrita no repositório.

**Versão**: 1.0.0  
**Última atualização**: 2026-01-29  
**Responsável**: Governança do Repositório
