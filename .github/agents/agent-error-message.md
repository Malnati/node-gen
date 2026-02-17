---
name: Error Messaging
description: Define políticas de mensagens de erro, logging estruturado e observabilidade para garantir rastreabilidade e debugging eficiente
version: 1.0.0
referenced_by: opencode.json, AGENTS.md
see_also: AGENTS.md, agent-bash.md
---

<!-- .github/agents/agent-error-message.md -->

# Agente: Política de Mensagens de Erro

> **📋 Documentação relacionada:**  
> - Índice geral: [AGENTS.md](../../AGENTS.md)  
> - Configuração OpenCode: [opencode.json](../../opencode.json) (seção `agent.error_handling`)  
> - Agentes relacionados: [agent-bash.md](./agent-bash.md)

## Referências relacionadas

- **`agent-bash.md`**: Define políticas detalhadas de Bash scripting. **Todos os scripts de logging e tratamento de erros devem seguir as premissas de Bash**, incluindo:
  - Nunca usar Python em scripts Bash
  - Sempre preferir `grep` e `sed` em vez de `awk`
  - Sempre preferir ferramentas GNU e padrão Ubuntu
  - Sempre usar `curl` para acesso a URLs e downloads
  - **Nunca usar HEREDOC**
  - Sempre enviar mensagens de erro para stderr
  - Sempre iniciar com `set -euo pipefail`

## Propósito

Este agente define o **padrão global para todas as mensagens de erro e exceções críticas** em todo o repositório, bem como as **políticas de tratamento de erros, logging estruturado e observabilidade**, garantindo:

1. Mensagens estruturadas e padronizadas
2. Informações completas para diagnóstico
3. Contexto adequado para desenvolvedores e usuários
4. Segurança (sem exposição de dados sensíveis)
5. Observabilidade e rastreabilidade
6. Separação clara entre informações técnicas e mensagens para usuários finais

## Escopo

Este agente se aplica a:

- Logs de erro em workflows do GitHub Actions
- Mensagens de exceção em scripts Bash (entrypoints, utilitários)
- Logs de aplicações e serviços
- Mensagens de erro em APIs
- Logs de containers Docker
- Qualquer output de erro ou exceção no repositório

### ⚠️ Aplicação Universal

Esta política é **global** e deve ser seguida por todos os componentes do repositório, independentemente de linguagem ou plataforma.

### ⚠️ Fora do Escopo: Fixtures

Para regras sobre fixtures, veja `.github/agents/agent-actions.md` seção "Fora do Escopo: Fixtures".

---

## Premissas obrigatórias

### Premissa 1 — Formato de erro com 4 componentes obrigatórios

Toda mensagem de erro ou exceção crítica deve responder, **nesta ordem**, a quatro componentes:

#### 1. [ERRO NATIVO]
**O que quebrou tecnicamente**

- Mensagem original do framework/serviço/biblioteca
- Código de erro (quando disponível)
- Tipo de exceção

**Exemplo:**
```
[ERRO NATIVO]: ConnectionRefusedError: [Errno 111] Connection refused
```

#### 2. [MOTIVO]
**O que o sistema estava tentando fazer**

- Contexto de negócio/fluxo
- Operação que estava sendo executada
- Estado esperado vs estado real

**Exemplo:**
```
[MOTIVO]: Tentativa de conectar ao banco de dados PostgreSQL durante inicialização do serviço de autenticação
```

#### 3. [AÇÃO DESENVOLVEDOR]
**O que mudar no código/config**

- Passos objetivos para correção
- Arquivos/variáveis/funções específicas quando possível
- Checklist de verificações
- Links para documentação relevante quando aplicável

**Exemplo:**
```
[AÇÃO DESENVOLVEDOR]:
1. Verificar se o serviço PostgreSQL está rodando: docker ps | grep postgres
2. Validar variáveis de ambiente: DB_HOST, DB_PORT no arquivo .env
3. Testar conectividade: nc -zv $DB_HOST $DB_PORT
4. Revisar configuração de rede no docker-compose.yml (seção networks)
```

#### 4. [SUPORTE USUÁRIO]
**O que informar ao cliente**

- Texto curto e compreensível
- Sem detalhes internos (nomes de variáveis, paths internos)
- Sem segredos ou credenciais
- Sem nomes de recursos sensíveis (IPs internos, endpoints, estrutura de DB)
- Ação que o usuário pode tomar (ex: "contate o suporte", "tente novamente mais tarde")

**Exemplo:**
```
[SUPORTE USUÁRIO]: O serviço está temporariamente indisponível. Nossa equipe foi notificada e está trabalhando na solução. Tente novamente em alguns minutos.
```

---

## Formato Obrigatório do Log

```
================================================================================
[DATA/HORA]: <ISO-8601>
[ERRO NATIVO]: <mensagem nativa>
[MOTIVO]: <contexto>
[AÇÃO DESENVOLVEDOR]: <passos objetivos no código/config>
[SUPORTE USUÁRIO]: <texto curto para cliente>
[STACK TRACE]: <stack>
================================================================================
```

### Exemplo Completo

```
================================================================================
[DATA/HORA]: 2026-01-29T00:43:42.997Z
[ERRO NATIVO]: ECONNREFUSED: connect ECONNREFUSED 172.30.0.100:5432
[MOTIVO]: Tentativa de conectar ao PostgreSQL durante inicialização do auth-service
[AÇÃO DESENVOLVEDOR]:
1. Verificar se PostgreSQL está rodando: docker ps | grep postgres
2. Validar variáveis: DB_HOST=172.30.0.100 DB_PORT=5432 no .env
3. Testar conectividade: nc -zv 172.30.0.100 5432
4. Revisar docker-compose.yml seção networks.global_net
[SUPORTE USUÁRIO]: Serviço temporariamente indisponível. Equipe notificada. Tente novamente em alguns minutos.
[STACK TRACE]:
  at TCPConnectWrap.afterConnect [as oncomplete] (node:net:1495:16)
  at Protocol._enqueue (/app/node_modules/mysql2/lib/protocol/protocol.js:144:48)
  at Protocol.handshake (/app/node_modules/mysql2/lib/protocol/protocol.js:51:23)
================================================================================
```

---

## Regras de Implementação

### Regra 1: Sempre incluir [DATA/HORA]
- Formato ISO-8601
- Timezone UTC ou explicitamente indicado
- Permite correlação temporal entre logs

**Em scripts Bash:**
```bash
date -Iseconds  # Formato: 2026-01-29T00:15:30-03:00
date -u -Iseconds  # UTC: 2026-01-29T03:15:30Z
```

**Em aplicações Node.js/TypeScript:**
```typescript
new Date().toISOString()  // 2026-01-29T03:15:30.123Z
```

### Regra 2: Incluir [STACK TRACE] quando relevante

Stack traces devem ser incluídos quando:
- Exceção não tratada ocorreu
- Erro de runtime inesperado
- Debugging de problema complexo é necessário

Stack traces **não** devem ser incluídos quando:
- Erro de validação de entrada (esperado)
- Erro de configuração (mensagem clara é suficiente)
- Fluxo de erro controlado (handled exception)

Formato de stack trace:
```
[STACK TRACE]:
at function_name (file.js:123:45)
at parent_function (file.js:100:10)
at main (file.js:50:5)
```

### Regra 3: [AÇÃO DESENVOLVEDOR] deve ser específica
- Indicar exatamente onde investigar/corrigir (arquivo, linha, variável, função)
- Citar arquivos, variáveis, funções específicas
- Incluir comandos de diagnóstico quando aplicável
- Usar checklist numerado para clareza
- Links para documentação relevante quando aplicável

### Regra 4: [SUPORTE USUÁRIO] não expõe internals
- Sem detalhes de implementação
- Sem endpoints internos
- Sem credenciais ou tokens
- Sem nomes de recursos sensíveis (IPs internos, nomes de serviços, estrutura de DB)
- Mensagem curta e clara em linguagem simples

### Regra 5: Usar separadores visuais
- Linha de 80 caracteres (=) para delimitar blocos
- Facilita leitura em logs longos
- Permite parsing automatizado

### Regra 6: Direcionar erros para stderr
- Mensagens de erro devem ser enviadas para stderr usando `>&2` em scripts Bash
- Logs de operações bem-sucedidas devem usar stdout
- Distinguir stdout (sucesso/info) de stderr (erros)

---

## Premissa 2 — Logging estruturado em Bash

Scripts Bash devem usar logging estruturado com prefixos consistentes:

```bash
echo "✅ Sucesso: operação concluída"
echo "⚠️  Aviso: possível problema detectado"
echo "❌ Erro: falha na operação" >&2
echo "ℹ️  Info: informação relevante"
```

Mensagens de erro devem ser enviadas para stderr usando `>&2`:

```bash
if [ -z "${VAR:-}" ]; then
  echo "❌ Erro: VAR não definida" >&2
  echo "================================================================================
[DATA/HORA]: $(date -Iseconds)
[ERRO NATIVO]: Variable VAR is not set
[MOTIVO]: Tentando processar configuração de deploy
[AÇÃO DESENVOLVEDOR]: Definir VAR no docker-compose.yml ou no ambiente
[SUPORTE USUÁRIO]: Configuração incompleta, contate o suporte
[STACK TRACE]: N/A (erro de validação)
================================================================================" >&2
  exit 1
fi
```

Logs de operações bem-sucedidas devem ser concisos:

```bash
echo "✅ Deploy concluído: ambiente PRD, versão 1.2.3"
```

---

## Ferramentas Sugeridas (Ubuntu)

### Para Diagnóstico

| Ferramenta | Uso | Exemplo |
|------------|-----|---------|
| `grep` / `rg` | Localizar mensagens, padrões e tags no código e documentação | `grep -r "ERRO NATIVO" logs/` |
| `find` | Varrer arquivos por extensão/pasta para limitar escopo de busca | `find . -name "*.log" -mtime -1` |
| `docker logs` | Coletar evidências de erro com data/hora para correlação | `docker logs auth-service --since 1h` |
| `journalctl` | Logs do sistema (systemd) | `journalctl -u docker -n 100` |
| `jq` | Parse de logs JSON | `cat error.log \| jq '.[] \| select(.level=="error")'` |
| `tail -f` | Monitoramento em tempo real | `tail -f /var/log/app.log \| grep ERROR` |

### Para Formatação

| Ferramenta | Uso | Exemplo |
|------------|-----|---------|
| `echo` | Output simples em Bash | `echo "[ERRO NATIVO]: ${error_msg}"` |
| `printf` | Output formatado em Bash | `printf "[DATA/HORA]: %s\n" "$(date -Iseconds)"` |
| `logger` | Enviar para syslog | `logger -t myapp "[ERRO NATIVO]: Connection failed"` |

### Comandos GNU para validação

```bash
# Verificar erros com formato estruturado
grep -r "\[ERRO NATIVO\]" . --include="*.log" --include="*.txt"

# Verificar uso de stderr em scripts
grep -Rn ">&2" --include="*.sh" .

# Validar prefixos de log
grep -E "(✅|⚠️|❌|ℹ️)" logs/*.log | cut -d':' -f2 | sort | uniq -c

# Extrair stack traces de logs
grep -A 20 "\[STACK TRACE\]" logs/*.log

# Validar formato de data/hora ISO-8601
grep -E "\[DATA/HORA\]: [0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}" logs/*.log

# Verificar se mensagens de usuário não expõem secrets
grep -i "\[SUPORTE USUÁRIO\].*password\|secret\|key\|token" logs/*.log

# Verificar se ações de desenvolvedor têm contexto suficiente
grep "\[AÇÃO DESENVOLVEDOR\]" logs/*.log | grep -v "linha\|arquivo\|variável"

# Extrair e contar stack traces por tipo de erro
grep -B 5 "\[STACK TRACE\]" logs/*.log | grep "\[ERRO NATIVO\]" | sort | uniq -c

# Extrair e ordenar logs por timestamp
grep "\[DATA/HORA\]" logs/*.log | sort

# Verificar erros em workflows
grep -Rn "echo.*Error" .github/workflows/ --include="*.yml"
```

---

## Exemplos de Implementação

### Bash Script

```bash
#!/bin/bash
set -euo pipefail

log_error() {
    local native_error="$1"
    local reason="$2"
    local dev_action="$3"
    local user_msg="$4"
    local stack_trace="${5:-}"
    
    echo "================================================================================" >&2
    echo "[DATA/HORA]: $(date -Iseconds)" >&2
    echo "[ERRO NATIVO]: ${native_error}" >&2
    echo "[MOTIVO]: ${reason}" >&2
    echo "[AÇÃO DESENVOLVEDOR]: ${dev_action}" >&2
    echo "[SUPORTE USUÁRIO]: ${user_msg}" >&2
    if [ -n "${stack_trace}" ]; then
        echo "[STACK TRACE]:" >&2
        echo "${stack_trace}" >&2
    fi
    echo "================================================================================" >&2
}

# Uso
if ! curl -f https://api.example.com/health; then
    log_error \
        "curl: (7) Failed to connect to api.example.com port 443" \
        "Health check do API gateway durante deploy do workflow" \
        "1. Verificar conectividade: curl -v https://api.example.com
2. Validar certificado SSL: openssl s_client -connect api.example.com:443
3. Revisar configuração de DNS
4. Verificar firewall/proxy settings" \
        "Serviço temporariamente indisponível. Tente novamente em alguns minutos."
    exit 1
fi
```

### GitHub Actions Workflow

```yaml
- name: Deploy com tratamento de erro
  run: |
    set -euo pipefail
    
    if ! ./deploy.sh; then
        echo "================================================================================" >&2
        echo "[DATA/HORA]: $(date -Iseconds)" >&2
        echo "[ERRO NATIVO]: deploy.sh exited with status $?" >&2
        echo "[MOTIVO]: Falha durante deploy do workflow para ambiente de produção" >&2
        echo "[AÇÃO DESENVOLVEDOR]:" >&2
        echo "1. Revisar logs do deploy: cat deploy.log" >&2
        echo "2. Verificar permissões: ls -la deploy.sh" >&2
        echo "3. Validar variáveis de ambiente necessárias" >&2
        echo "4. Testar deploy localmente: act -W .github/workflows/deploy.yml" >&2
        echo "[SUPORTE USUÁRIO]: Deploy falhou. Equipe notificada. Versão anterior permanece ativa." >&2
        echo "================================================================================" >&2
        exit 1
    fi
```

### Docker Entrypoint

```bash
#!/bin/bash
# entrypoint.sh
set -euo pipefail

log_error() {
    local native_error="$1"
    local reason="$2"
    local dev_action="$3"
    local user_msg="$4"
    
    echo "================================================================================" >&2
    echo "[DATA/HORA]: $(date -Iseconds)" >&2
    echo "[ERRO NATIVO]: ${native_error}" >&2
    echo "[MOTIVO]: ${reason}" >&2
    echo "[AÇÃO DESENVOLVEDOR]: ${dev_action}" >&2
    echo "[SUPORTE USUÁRIO]: ${user_msg}" >&2
    echo "================================================================================" >&2
}

# Validar variáveis obrigatórias
if [ -z "${DATABASE_URL:-}" ]; then
    log_error \
        "Variable DATABASE_URL is not set" \
        "Container startup requer DATABASE_URL para conectar ao banco" \
        "1. Adicionar DATABASE_URL no docker-compose.yml (environment)
2. Verificar defaults: \${DATABASE_URL:-postgresql://localhost:5432/db}
3. Validar sintaxe da connection string" \
        "Serviço não pode iniciar devido a configuração faltante."
    exit 1
fi

exec "$@"
```

### Exemplo: Erro em script Bash

**Antes (não conforme):**
```bash
if [ ! -f "$CONFIG_FILE" ]; then
  echo "Error: config file not found"
  exit 1
fi
```

**Depois (conforme):**
```bash
if [ ! -f "$CONFIG_FILE" ]; then
  echo "❌ Erro: arquivo de configuração não encontrado" >&2
  echo "================================================================================
[DATA/HORA]: $(date -Iseconds)
[ERRO NATIVO]: File not found: ${CONFIG_FILE}
[MOTIVO]: Tentando carregar configuração do aplicativo
[AÇÃO DESENVOLVEDOR]: Verificar se CONFIG_FILE está definido corretamente no docker-compose.yml. Path esperado: /app/config/app.yml
[SUPORTE USUÁRIO]: Configuração do aplicativo não encontrada, contate o suporte
[STACK TRACE]: N/A (erro de validação)
================================================================================" >&2
  exit 1
fi
```

### Exemplo: Erro em workflow

**Antes (não conforme):**
```yaml
- name: Deploy
  run: |
    if ! deploy.sh; then
      echo "Deploy failed"
      exit 1
    fi
```

**Depois (conforme):**
```yaml
- name: Deploy
  run: |
    set -euo pipefail
    
    if ! deploy.sh; then
      echo "❌ Erro: deploy falhou" >&2
      echo "================================================================================" >&2
      echo "[DATA/HORA]: $(date -Iseconds)" >&2
      echo "[ERRO NATIVO]: deploy.sh exited with code $?" >&2
      echo "[MOTIVO]: Tentando fazer deploy para ambiente ${{ inputs.environment }}" >&2
      echo "[AÇÃO DESENVOLVEDOR]: Verificar logs do workflow e arquivo deploy.sh. Conferir credenciais em GitHub Secrets" >&2
      echo "[SUPORTE USUÁRIO]: Deploy temporariamente indisponível, tentaremos novamente em breve" >&2
      echo "[STACK TRACE]: N/A" >&2
      echo "================================================================================" >&2
      exit 1
    fi
    
    echo "✅ Deploy concluído: ${{ inputs.environment }}"
```

### Exemplo: Erro com stack trace (Node.js)

**Antes (não conforme):**
```javascript
try {
  await processData();
} catch (error) {
  console.error('Error:', error.message);
  process.exit(1);
}
```

**Depois (conforme):**
```javascript
try {
  await processData();
} catch (error) {
  console.error('❌ Erro: falha ao processar dados');
  console.error('================================================================================');
  console.error(`[DATA/HORA]: ${new Date().toISOString()}`);
  console.error(`[ERRO NATIVO]: ${error.message}`);
  console.error('[MOTIVO]: Tentando processar batch de dados do usuário');
  console.error('[AÇÃO DESENVOLVEDOR]: Verificar função processData() em src/services/data-processor.ts linha 156. Validar schema de entrada');
  console.error('[SUPORTE USUÁRIO]: Não foi possível processar seus dados, tente novamente ou contate o suporte');
  console.error('[STACK TRACE]:');
  console.error(error.stack);
  console.error('================================================================================');
  process.exit(1);
}
```

---

## Integração com Observabilidade

### Structured Logging (JSON)

Para sistemas que suportam logs estruturados (JSON):

```json
{
  "timestamp": "2026-01-29T00:43:42.997Z",
  "level": "error",
  "native_error": "ECONNREFUSED",
  "reason": "Database connection failed during startup",
  "developer_action": [
    "Check if PostgreSQL is running",
    "Verify DATABASE_URL environment variable",
    "Test connectivity with nc -zv host port"
  ],
  "user_message": "Service temporarily unavailable",
  "stack_trace": "...",
  "context": {
    "service": "auth-api",
    "component": "database-client",
    "transaction_id": "abc-123"
  }
}
```

### Alerting

Mensagens com este formato facilitam:
- **Detecção automática**: Parse de [ERRO NATIVO] para categorização
- **Contexto para devops**: [AÇÃO DESENVOLVEDOR] em alertas
- **Mensagens para usuários**: [SUPORTE USUÁRIO] em status pages
- **Correlação**: [DATA/HORA] para timeline de incidentes

---

## Fluxo de atuação do agente

1. **Validação de formato de erro**
   - Verificar que todos os erros seguem formato de 4 componentes
   - Identificar erros que não seguem o padrão

2. **Validação de logging estruturado**
   - Verificar uso de prefixos consistentes (✅, ⚠️, ❌, ℹ️)
   - Confirmar que erros vão para stderr (`>&2`)

3. **Validação de separação de responsabilidades**
   - Confirmar que `[AÇÃO DESENVOLVEDOR]` tem contexto técnico suficiente
   - Confirmar que `[SUPORTE USUÁRIO]` não expõe internals

4. **Validação de stack traces**
   - Verificar que stack traces são incluídos quando relevante
   - Identificar stack traces desnecessários

5. **Validação de timestamps**
   - Confirmar formato ISO-8601
   - Verificar consistência de timezone

6. **Relato de inconformidades**
   - Para cada premissa violada, gerar relatório em formato JSON
   - Incluir arquivo, linha, trecho "Antes/Depois" e orientação
   - Salvar em `docs/review/NNNN-report-error-handling.json`

---

## Estrutura do relatório de saída

- **Formato obrigatório: JSON**
- Caminho: `docs/review/NNNN-report-error-handling.json`
- Formato do identificador: `NNNN` (4 dígitos sequenciais, ex.: 0001, 0002)

Conteúdo mínimo:

```json
{
  "report_id": "NNNN",
  "title": "Review Error Handling e Observabilidade – Relatório NNNN",
  "context": {
    "data_analise": "YYYY-MM-DD",
    "agente": "Engenharia - Error Messaging",
    "escopo_analisado": "scripts, workflows, logs"
  },
  "premissas": [
    {
      "numero": 1,
      "nome": "Formato de erro com 4 componentes obrigatórios",
      "inconformidades": [
        {
          "arquivo": "entrypoint.sh",
          "linha": 42,
          "problema": "Erro não segue formato de 4 componentes",
          "antes": "echo \"Error: failed\" >&2\nexit 1",
          "depois": "echo \"❌ Erro: falha na operação\" >&2\necho \"================================================================================\n[DATA/HORA]: $(date -Iseconds)\n[ERRO NATIVO]: Exit code 1\n[MOTIVO]: Tentando iniciar serviço\n[AÇÃO DESENVOLVEDOR]: Verificar logs em /var/log/app.log\n[SUPORTE USUÁRIO]: Serviço temporariamente indisponível\n[STACK TRACE]: N/A\n================================================================================\" >&2\nexit 1",
          "orientacao": [
            "Adicionar os 4 componentes obrigatórios",
            "Incluir timestamp ISO-8601",
            "Separar informação técnica de mensagem para usuário"
          ],
          "comando_gnu": "grep -Rn 'echo.*Error' --include='*.sh' ."
        }
      ]
    }
  ]
}
```

---

## Checklist de Conformidade

Antes de commitar código com tratamento de erro, verificar:

- [ ] Mensagem de erro inclui [DATA/HORA] em ISO-8601
- [ ] [ERRO NATIVO] captura a mensagem original da biblioteca/framework
- [ ] [MOTIVO] explica o contexto de negócio/fluxo
- [ ] [AÇÃO DESENVOLVEDOR] lista passos específicos de correção
- [ ] [AÇÃO DESENVOLVEDOR] cita arquivos/variáveis/funções relevantes
- [ ] [SUPORTE USUÁRIO] não expõe detalhes internos
- [ ] [SUPORTE USUÁRIO] não contém credenciais ou endpoints sensíveis
- [ ] [STACK TRACE] incluído quando relevante (não para validação/config errors)
- [ ] Formato visual (separadores =) facilita leitura em logs
- [ ] Mensagem direcionada para stderr (`>&2` em Bash)
- [ ] Prefixos consistentes (✅, ⚠️, ❌, ℹ️) em logs
- [ ] Logs de sucesso concisos e informativos
- [ ] Comandos GNU documentados para validação

---

## Responsabilidades

### Desenvolvedores
- Implementar formato padrão em todo código novo
- Refatorar mensagens existentes quando modificar código
- Garantir que logs críticos sigam este padrão

### Code Review
- Validar conformidade com formato em PRs
- Verificar que mensagens não expõem dados sensíveis
- Confirmar que [AÇÃO DESENVOLVEDOR] é específica e útil

### Governança
- Auditar logs periodicamente para conformidade
- Atualizar este documento conforme necessário
- Coletar feedback sobre utilidade das mensagens

---

## Referências

- `.github/agents/agent-bash.md` - Práticas de Bash scripting
- `.github/agents/agent-actions.md` - Políticas de workflows
- `.github/agents/agent-governance.md` - Controle de mudanças
- `AGENTS.md` - Visão geral de todos os agentes

---

**Versão**: 1.0.0  
**Última atualização**: 2026-01-29  
**Responsável**: Governança de Engenharia
