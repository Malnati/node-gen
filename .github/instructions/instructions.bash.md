<!-- .github/instructions/instructions.bash.md -->
---
name: Bash and Shell Scripting Instructions
description: Políticas e melhores práticas para scripts bash, sh, zsh e steps de workflows
version: 1.0.0
applies_to: bash_scripts, shell_scripts, entrypoints, workflow_steps
applyTo: '**/*.sh'
---

# Bash and Shell Scripting Instructions

Instruções para escrever scripts bash, sh, zsh e passos de workflows com segurança, clareza e manutenção simples.

## Políticas Fundamentais

### ⚠️ Proibições Absolutas

1. **NUNCA usar HEREDOC** (`<<EOF`, `<<-EOF`, `<<'EOF'`)
   - Substitutos: `echo`, `printf`, template files, JSON/YAML files
   - Razão: dificulta manutenção, leitura e debugging

2. **NUNCA usar Python em scripts Bash**
   - Razão: mantém simplicidade e portabilidade
   - Exceção: se Python é a ferramenta principal do projeto

3. **NUNCA usar wget** (sempre `curl`)
   - Razão: `curl` é mais versátil e padronizado

4. **NUNCA usar eval**
   - Razão: risco de injeção e comportamento imprevisível

### ✅ Preferências Obrigatórias

1. **Sempre começar com:**
   ```bash
   #!/usr/bin/env bash
   set -euo pipefail
   ```

2. **Preferir grep/sed sobre awk**
   - Usar `awk` apenas quando absolutamente necessário

3. **Usar ferramentas GNU padrão**
   - `grep`, `sed`, `cut`, `sort`, `uniq`, `find`, `xargs`

4. **Formato de dados estruturados:**
   - JSON para dados (use `jq` para parsing)
   - YAML para configurações (use `yq` para parsing)
   - Markdown para documentação

5. **Logging estruturado:**
   ```bash
   echo "✅ Success message"
   echo "⚠️ Warning message" >&2
   echo "❌ Error message" >&2
   ```

## Princípios Gerais

- Gerar código limpo, simples e conciso
- Garantir leitura fácil e manutenção previsível
- Adicionar comentários somente quando necessário para entendimento
- Gerar `echo` concisos para status de execução
- Evitar log excessivo e output desnecessário
- Usar `shellcheck` quando disponível
- Assumir scripts para automação e testes, salvo especificação em contrário
- Preferir expansões seguras: `"$var"` e `${var}`; evitar `eval`
- Usar recursos modernos do Bash (`[[ ]]`, `local`, arrays) quando portabilidade permitir
- Escolher parsers confiáveis para dados estruturados ao invés de parsing ad hoc

## Tratamento de Erros

### Formato de Erro Obrigatório (6 Componentes)

Todos os erros devem incluir:

1. **[DATA/HORA]**: Data/hora do evento em ISO-8601
2. **[ERRO NATIVO]**: Mensagem nativa do sistema/ferramenta
3. **[MOTIVO]**: Contexto do que estava sendo executado
4. **[AÇÃO DESENVOLVEDOR]**: Ajuste específico (arquivo/variável/função)
5. **[SUPORTE USUÁRIO]**: Mensagem amigável sem detalhes internos
6. **[STACK TRACE]**: Detalhes técnicos (quando disponível)

### Formato de Log Estruturado

O log de erro **deve** seguir esta estrutura, **sem usar HEREDOC**:

- Linha separadora inicial (`================================================================================`)
- `[DATA/HORA]: ...`
- `[ERRO NATIVO]: ...`
- `[MOTIVO]: ...`
- `[AÇÃO DESENVOLVEDOR]: ...`
- `[SUPORTE USUÁRIO]: ...`
- `[STACK TRACE]: ...` (quando aplicável)
- Linha separadora final (`================================================================================`)

### Exemplo

```bash
if ! docker compose up -d; then
  echo "================================================================================" >&2
  echo "[DATA/HORA]: $(date -u +"%Y-%m-%dT%H:%M:%SZ")" >&2
  echo "[ERRO NATIVO]: docker compose up failed with exit code $?" >&2
  echo "[MOTIVO]: Tentativa de iniciar stack Docker para aplicação ${APP_NAME}" >&2
  echo "[AÇÃO DESENVOLVEDOR]: Verificar docker-compose.yml, validar rede global_net, checar portas em uso" >&2
  echo "[SUPORTE USUÁRIO]: Falha ao iniciar serviços. Contate o suporte técnico." >&2
  echo "================================================================================" >&2
  exit 1
fi
```

## Segurança e Robustez

- **Sempre habilitar** `set -euo pipefail`
- Validar parâmetros obrigatórios antes de executar
- Declarar valores imutáveis com `readonly` (ou `declare -r`)
- Usar `trap` para limpar recursos temporários em saídas inesperadas
- Criar temporários com `mktemp` e remover no `cleanup`

```bash
cleanup() {
  if [[ -n "${TEMP_DIR:-}" && -d "$TEMP_DIR" ]]; then
    rm -rf "$TEMP_DIR"
  fi
}

trap cleanup EXIT
```

## Estrutura de Script

- Shebang claro: `#!/bin/bash` ou `#!/usr/bin/env bash`
- Comentário de cabeçalho descrevendo o propósito do script
- Valores padrão no topo
- Funções para blocos reutilizáveis
- Fluxo principal limpo e direto

## Validação de Variáveis

### Pattern Obrigatório

```bash
if [ -z "${VAR_NAME:-}" ]; then
  echo "❌ Error: VAR_NAME not defined" >&2
  echo "Set with: export VAR_NAME=value" >&2
  exit 1
fi
```

### Defaults para Variáveis Opcionais

```bash
LOG_LEVEL="${LOG_LEVEL:-info}"
PORT="${PORT:-3000}"
HOST="${HOST:-0.0.0.0}"
DB_PASSWORD="${DB_PASSWORD:-changeme}"
API_KEY="${API_KEY:-changeme}"
JWT_SECRET="${JWT_SECRET:-changeme}"
```

## Output e Formatação

### Símbolos Padronizados

```bash
echo "✅ Success: Operation completed"
echo "⚠️ Warning: Non-critical issue detected" >&2
echo "❌ Error: Critical failure" >&2
echo "ℹ️ Info: Additional information"
echo "🔍 Debug: Detailed diagnostic" >&2
```

### JSON Output (Preferencial)

```bash
output=$(jq -n \
  --arg status "success" \
  --arg message "Operation completed" \
  --arg timestamp "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" \
  '{status: $status, message: $message, timestamp: $timestamp}')

echo "$output"
```

### Alternativa sem jq

```bash
if command -v jq >/dev/null 2>&1; then
  output=$(jq -n --arg status "success" '{status: $status}')
else
  output='{"status":"success","message":"Operation completed"}'
fi
echo "$output"
```

## JSON e YAML

- Preferir `jq` (JSON) e `yq` (YAML) em vez de parsing manual com `grep`, `awk` ou split
- Validar campos obrigatórios e tratar caminhos ausentes com status de erro
- Usar filtros com aspas para evitar expansão pelo shell
- Usar `--raw-output` quando precisar de strings
- Tratar erros do parser como fatais com `set -euo pipefail`
- Documentar dependências de `jq`/`yq` e falhar rápido quando ausentes

## Detecção Dinâmica de Ferramentas

```bash
HAS_NODE=false
if command -v node >/dev/null 2>&1; then
  HAS_NODE=true
  echo "✅ Node.js detected: $(node --version)"
else
  echo "⚠️ Node.js not found - skipping Node.js tasks" >&2
fi

if [ "$HAS_NODE" = true ]; then
  npm test
else
  echo "⚠️ Skipping npm test (Node.js not available)" >&2
fi
```

## Substituição de HEREDOC

### ❌ NÃO USAR (HEREDOC)

```bash
cat > config.json <<EOF
{
  "name": "${APP_NAME}",
  "version": "${VERSION}"
}
EOF
```

### ✅ USAR (Alternativas)

**Opção 1: echo com escaping**

```bash
echo "{\"name\":\"${APP_NAME}\",\"version\":\"${VERSION}\"}" > config.json
```

**Opção 2: printf**

```bash
printf '{"name":"%s","version":"%s"}\n' "$APP_NAME" "$VERSION" > config.json
```

**Opção 3: jq (melhor para JSON)**

```bash
jq -n \
  --arg name "$APP_NAME" \
  --arg version "$VERSION" \
  '{name: $name, version: $version}' > config.json
```

**Opção 4: Template file**

```bash
sed -e "s/__NAME__/${APP_NAME}/g" \
    -e "s/__VERSION__/${VERSION}/g" \
    config.json.template > config.json
```

**Opção 5: Arquivo YAML/JSON pré-existente**

```bash
yq eval ".name = \"${APP_NAME}\"" -i config.yaml
jq ".version = \"${VERSION}\"" config.json > config.json.tmp
mv config.json.tmp config.json
```

## Exemplos

### Script de Inicialização (entrypoint.sh)

```bash
#!/usr/bin/env bash
set -euo pipefail

if [ -z "${APP_NAME:-}" ]; then
  echo "❌ Error: APP_NAME not defined" >&2
  exit 1
fi

PORT="${PORT:-3000}"
HOST="${HOST:-0.0.0.0}"
LOG_LEVEL="${LOG_LEVEL:-info}"

echo "✅ Starting ${APP_NAME}"
echo "ℹ️ Config: PORT=${PORT}, HOST=${HOST}, LOG_LEVEL=${LOG_LEVEL}"

if ! command -v node >/dev/null 2>&1; then
  echo "❌ Error: Node.js not found" >&2
  exit 1
fi

echo "✅ Launching application..."
exec node server.js
```

### Script de Build (GitHub Actions)

```bash
#!/usr/bin/env bash
set -euo pipefail

HAS_NODE=false
HAS_DOCKER=false

if command -v node >/dev/null 2>&1; then
  HAS_NODE=true
  echo "✅ Node.js $(node --version) detected"
fi

if command -v docker >/dev/null 2>&1; then
  HAS_DOCKER=true
  echo "✅ Docker $(docker --version) detected"
fi

if [ "$HAS_NODE" = true ]; then
  echo "ℹ️ Building Node.js project..."
  npm ci
  npm run build
  echo "✅ Node.js build completed"
else
  echo "⚠️ Skipping Node.js build (not detected)" >&2
fi

if [ "$HAS_DOCKER" = true ]; then
  echo "ℹ️ Building Docker image..."
  docker build -t myapp:latest .
  echo "✅ Docker build completed"
else
  echo "⚠️ Skipping Docker build (not detected)" >&2
fi

echo "✅ Build process completed"
```

### Script de Validação

```bash
#!/usr/bin/env bash
set -euo pipefail

EXIT_CODE=0

echo "ℹ️ Validating directory structure..."
for dir in .github docs; do
  if [ ! -d "$dir" ]; then
    echo "❌ Missing directory: $dir" >&2
    EXIT_CODE=1
  else
    echo "✅ Found: $dir"
  fi
done

echo "ℹ️ Validating required files..."
for file in AGENTS.md opencode.json .github/copilot-instructions.md; do
  if [ ! -f "$file" ]; then
    echo "❌ Missing file: $file" >&2
    EXIT_CODE=1
  else
    echo "✅ Found: $file"
  fi
done

echo "ℹ️ Validating JSON files..."
if command -v jq >/dev/null 2>&1; then
  for json_file in $(find . -name "*.json" -not -path "*/node_modules/*"); do
    if jq empty "$json_file" 2>/dev/null; then
      echo "✅ Valid JSON: $json_file"
    else
      echo "❌ Invalid JSON: $json_file" >&2
      EXIT_CODE=1
    fi
  done
else
  echo "⚠️ jq not found - skipping JSON validation" >&2
fi

if [ $EXIT_CODE -eq 0 ]; then
  echo "✅ All validations passed"
else
  echo "❌ Validation failed" >&2
fi

exit $EXIT_CODE
```

## Integração com GitHub Actions

### Inline Scripts (Preferencial)

```yaml
- name: Setup and validate
  shell: bash
  run: |
    set -euo pipefail
    
    if [ -z "${APP_NAME:-}" ]; then
      echo "❌ Error: APP_NAME not defined" >&2
      exit 1
    fi
    
    echo "has_node=$(command -v node >/dev/null 2>&1 && echo true || echo false)" >> $GITHUB_OUTPUT
    
    if command -v node >/dev/null 2>&1; then
      echo "✅ Building with Node.js $(node --version)"
      npm ci
      npm run build
    else
      echo "⚠️ Node.js not available - skipping build" >&2
    fi
```

### Comandos Encadeados

```yaml
- name: Lint, build, and test
  shell: bash
  run: |
    set -euo pipefail
    npm run lint:fix && npm run build && npm test
```

## Referências

- **Documentação completa**: `.github/agents/agent-bash.md`
- **Tratamento de erros**: `.github/agents/agent-error-message.md`
- **Workflows**: `.github/agents/agent-actions.md`
- **Índice geral**: `AGENTS.md`
