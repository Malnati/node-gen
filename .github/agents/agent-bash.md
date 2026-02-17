---
name: Bash Scripting
description: Define as políticas e preferências para desenvolvimento de scripts Bash em workflows, entrypoints e utilitários. Estabelece padrões de uso de ferramentas GNU, formato de saída, e práticas recomendadas para garantir consistência, portabilidade e manutenibilidade.
version: 1.0.0
referenced_by: opencode.json, AGENTS.md
see_also: AGENTS.md, agent-actions.md, agent-error-message.md
---

<!-- .github/agents/agent-bash.md -->

# Agente: Bash Scripting

> **📋 Documentação relacionada:**  
> - Índice geral: [AGENTS.md](../../AGENTS.md)  
> - Configuração OpenCode: [opencode.json](../../opencode.json) (seção `agent.bash`)  
> - Agentes relacionados: [agent-actions.md](./agent-actions.md), [agent-error-message.md](./agent-error-message.md)

## Propósito

Este agente define exclusivamente as **políticas e preferências para scripts Bash** utilizados em:

1. Workflows do GitHub Actions (steps com `shell: bash`)
2. Scripts de entrypoint em containers Docker (`entrypoint.sh`)
3. Scripts utilitários e de automação no repositório
4. Qualquer arquivo `.sh` quando necessário (seguindo as políticas do repositório)

## Escopo

Este agente define exclusivamente as **políticas e preferências para scripts Bash** utilizados em:

- Scripts Bash em workflows (`.github/workflows/*.yml`)
- Scripts de entrypoint Docker (`entrypoint.sh`)
- Scripts utilitários e de automação
- Padrões de uso de ferramentas GNU e Unix
- Formato de arquivos de saída e persistência de dados
- Boas práticas de scripting Bash

### ⚠️ Fora do Escopo: Fixtures

Para regras sobre fixtures, veja `.github/agents/agent-actions.md` seção "Fora do Escopo: Fixtures".

---

## Premissas obrigatórias

### Premissa 1 — Nunca usar Python em scripts Bash

1. É **proibido** usar Python dentro de scripts Bash ou como substituto de Bash.
2. Regras:
   - Não usar `python -c "..."` ou `python3 -c "..."` em scripts Bash
   - Não usar blocos Python embutidos em scripts Bash
   - Não chamar scripts Python de dentro de scripts Bash quando a lógica puder ser implementada em Bash
   - Python pode ser usado apenas em actions externas de terceiros onde não há controle sobre a implementação
3. Objetivo:
   - Reduzir dependências externas
   - Manter consistência de linguagem
   - Facilitar manutenção e portabilidade
   - Garantir que scripts funcionem em ambientes mínimos (Alpine, Ubuntu base, etc.)

#### Ferramentas e comandos GNU

- Verificar uso de Python em scripts:

  ```bash
  grep -Rin "python -c\|python3 -c\|#!/usr/bin/env python" --include="*.sh" --include="*.yml" --include="*.yaml" .
  ```

### Premissa 2 — Sempre preferir grep e sed em vez de awk

1. Para processamento de texto, **sempre** preferir `grep` e `sed` em vez de `awk`.
2. Regras:
   - Usar `grep` para busca e filtragem de linhas
   - Usar `sed` para transformação e substituição de texto
   - Usar `awk` **apenas** quando a tarefa for genuinamente complexa e não puder ser realizada eficientemente com `grep` e `sed`
3. Razão:
   - `grep` e `sed` são mais simples e diretos para a maioria das tarefas
   - Melhor legibilidade e manutenibilidade
   - Menor curva de aprendizado
4. Exemplos conformes:

   ```bash
   # Buscar linhas contendo padrão
   grep "pattern" file.txt
   
   # Substituir texto
   sed 's/old/new/g' file.txt
   
   # Extrair campo específico (quando possível com cut)
   cut -d':' -f2 file.txt
   
   # Filtrar e transformar
   grep "pattern" file.txt | sed 's/foo/bar/g'
   ```

5. Uso aceitável de awk (casos complexos):

   ```bash
   # Operações matemáticas complexas em campos
   awk '{sum += $2} END {print sum/NR}' file.txt
   
   # Processamento condicional complexo de múltiplos campos
   awk '$1 > 100 && $2 < 50 {print $3}' file.txt
   ```

#### Ferramentas e comandos GNU

- Verificar uso de awk em scripts:

  ```bash
  grep -Rn "awk " --include="*.sh" --include="*.yml" --include="*.yaml" .
  ```

### Premissa 3 — Sempre preferir ferramentas GNU e padrão Ubuntu

1. **Sempre** usar ferramentas GNU e outras ferramentas disponíveis por padrão no Ubuntu.
2. Regras:
   - Usar ferramentas do coreutils: `cat`, `cut`, `sort`, `uniq`, `tr`, `wc`, `head`, `tail`, etc.
   - Usar ferramentas padrão: `grep`, `sed`, `find`, `xargs`, etc.
   - Evitar dependência de ferramentas não padrão que exigem instalação adicional
   - Quando ferramentas adicionais forem necessárias, documentar explicitamente a dependência
3. Objetivo:
   - Máxima portabilidade entre ambientes Ubuntu
   - Reduzir dependências e tempo de setup
   - Garantir funcionamento em containers Alpine e Ubuntu mínimos
4. Ferramentas GNU preferenciais:
   - **Busca e filtragem:** `grep`, `find`
   - **Processamento de texto:** `sed`, `cut`, `tr`, `sort`, `uniq`
   - **Arquivos:** `cat`, `head`, `tail`, `wc`, `tee`
   - **Manipulação de diretórios:** `mkdir`, `rm`, `cp`, `mv`, `ls`
   - **Comparação:** `diff`, `comm`, `cmp`
   - **Compressão:** `gzip`, `tar`, `zip`, `unzip`

#### Ferramentas e comandos GNU

- Verificar uso de ferramentas não padrão:

  ```bash
  # Procurar por ferramentas que não são padrão Ubuntu
  grep -Rn "jq\|yq\|pup\|xmlstarlet" --include="*.sh" --include="*.yml" --include="*.yaml" . || echo "✓ Nenhuma ferramenta não-padrão encontrada"
  ```

### Premissa 4 — Sempre usar cURL quando necessário acessar URLs ou fazer downloads

1. Para acessar URLs ou fazer downloads, **sempre** usar `curl`.
2. Regras:
   - Usar `curl` para requisições HTTP/HTTPS
   - Usar `curl` para downloads de arquivos
   - Não usar `wget`, `httpie`, ou outras ferramentas de HTTP quando `curl` for suficiente
   - Sempre usar flags apropriadas: `-fsSL` para downloads silenciosos, `-o` para especificar arquivo de saída
3. Razão:
   - `curl` está disponível por padrão em praticamente todos os ambientes
   - Sintaxe consistente e bem documentada
   - Suporte robusto a HTTPS e certificados
4. Exemplos conformes:

   ```bash
   # Download de arquivo
   curl -fsSL -o output.tar.gz https://example.com/file.tar.gz
   
   # Requisição GET e processar resposta
   curl -fsSL https://api.example.com/endpoint | grep "pattern"
   
   # Requisição POST com JSON
   curl -fsSL -X POST \
     -H "Content-Type: application/json" \
     -d '{"key":"value"}' \
     https://api.example.com/endpoint
   
   # Salvar resposta em variável
   response=$(curl -fsSL https://api.example.com/endpoint)
   ```

5. Flags recomendadas:
   - `-f`: Fail silently on HTTP errors
   - `-s`: Silent mode (sem barra de progresso)
   - `-S`: Show errors even in silent mode
   - `-L`: Follow redirects
   - `-o`: Output to file
   - `-H`: Custom headers
   - `-d`: Data for POST requests
   - `-X`: HTTP method

#### Ferramentas e comandos GNU

- Verificar uso de wget ou outras ferramentas:

  ```bash
  grep -Rn "wget\|httpie\|http " --include="*.sh" --include="*.yml" --include="*.yaml" . | grep -v "https://"
  ```

### Premissa 5 — Nunca usar HEREDOC

1. É **proibido** usar HEREDOC (`<<EOF`, `<<-EOF`, `<<'EOF'`, etc.) em scripts Bash.
2. Regras:
   - Não usar HEREDOC para criar arquivos
   - Não usar HEREDOC para strings multilinhas
   - **Para textos até 10 linhas:** usar `echo` ou `printf`
   - **Para textos com 10+ linhas:** usar arquivos template com `envsubst` para interpolação de variáveis
3. Razão:
   - HEREDOCs dificultam a legibilidade em workflows YAML
   - Problemas com indentação e escaping em contextos aninhados
   - Dificulta manutenção e debug
4. Alternativas conformes:

   **Para textos curtos (até 10 linhas):**
   
   ```bash
   # ❌ NÃO FAZER:
   # cat <<EOF > file.txt
   # linha 1
   # linha 2
   # EOF
   
   # ✅ FAZER - Opção 1: echo
   echo "linha 1" > file.txt
   echo "linha 2" >> file.txt
   
   # ✅ FAZER - Opção 2: printf
   printf "linha 1\nlinha 2\n" > file.txt
   
   # ✅ FAZER - Opção 3: printf multilinha
   printf "%s\n" \
     "linha 1" \
     "linha 2" \
     "linha 3" > file.txt
   ```

   **Para textos longos (10+ linhas):**
   
   ```bash
   # ❌ NÃO FAZER:
   # cat <<EOF > config.yml
   # server:
   #   host: ${HOST}
   #   port: ${PORT}
   # ... (muitas linhas)
   # EOF
   
   # ✅ FAZER: usar arquivo template
   # 1. Criar template: templates/config.yml.template
   #    Conteúdo do template:
   #    server:
   #      host: ${HOST}
   #      port: ${PORT}
   #      ...
   
   # 2. Usar envsubst para interpolação
   export HOST="localhost"
   export PORT="8080"
   envsubst < templates/config.yml.template > config.yml
   
   # Ou com variáveis inline:
   HOST="localhost" PORT="8080" envsubst < templates/config.yml.template > config.yml
   ```

#### Ferramentas e comandos GNU

- Verificar uso de HEREDOC:

  ```bash
  grep -Rn "<<EOF\|<<-EOF\|<<'EOF'\|<<\"EOF\"\|<< EOF" --include="*.sh" --include="*.yml" --include="*.yaml" .
  ```

- Verificar disponibilidade de `envsubst`:

  ```bash
  command -v envsubst || echo "⚠️  envsubst não encontrado (pacote: gettext-base)"
  ```

### Premissa 6 — Sempre preferir formato JSON para arquivos de dados

1. Quando necessário criar arquivos ou persistir resultados de logs de requisições HTTP, **sempre** preferir formato JSON.
2. Regras:
   - Usar JSON para logs de requisições HTTP
   - Usar JSON para arquivos de dados estruturados
   - Usar JSON para configurações geradas por scripts
   - Usar JSON para resultados de análises e auditorias
3. Razão:
   - Formato estruturado e amplamente suportado
   - Fácil parsing com ferramentas padrão (`jq` quando disponível, ou `grep`/`sed` quando não)
   - Melhor para integração com APIs e ferramentas modernas
   - Fácil leitura tanto para humanos quanto para máquinas
4. Exemplos conformes:

   ```bash
   # Criar arquivo JSON simples (até 10 linhas) - usar echo/printf
   echo "{" > data.json
   echo "  \"timestamp\": \"$(date -Iseconds)\"," >> data.json
   echo "  \"status\": \"success\"," >> data.json
   echo "  \"results\": []" >> data.json
   echo "}" >> data.json
   
   # Ou com printf
   printf '{\n  "timestamp": "%s",\n  "status": "success",\n  "results": []\n}\n' \
     "$(date -Iseconds)" > data.json
   
   # JSON complexo (10+ linhas) - usar template
   # Criar templates/request-log.json.template:
   #   {
   #     "url": "${URL}",
   #     "method": "${METHOD}",
   #     "timestamp": "${TIMESTAMP}",
   #     "http_code": ${HTTP_CODE},
   #     "response": ${BODY}
   #   }
   
   # Usar template:
   response=$(curl -fsSL -w '\n%{http_code}' https://api.example.com/endpoint)
   export HTTP_CODE=$(echo "$response" | tail -n1)
   export BODY=$(echo "$response" | head -n-1)
   export URL="https://api.example.com/endpoint"
   export METHOD="GET"
   export TIMESTAMP="$(date -Iseconds)"
   envsubst < templates/request-log.json.template > request-log.json
   ```

#### Ferramentas e comandos GNU

- Verificar arquivos JSON no repositório:

  ```bash
  find . -name "*.json" -type f | sort
  ```

### Premissa 7 — Sempre preferir formato Markdown para documentação

1. Quando necessário criar arquivos de relatórios, especificações, documentações, guias, regras e afins, **sempre** preferir formato Markdown.
2. Regras:
   - Usar Markdown (`.md`) para:
     - Relatórios de análise
     - Especificações técnicas
     - Documentação de processos
     - Guias e tutoriais
     - Regras e políticas
     - Logs de auditoria formatados para leitura humana
   - Usar estrutura clara: títulos, listas, blocos de código, tabelas
   - Incluir metadados no início quando apropriado (data, autor, versão)
3. Razão:
   - Formato legível tanto em texto puro quanto renderizado
   - Amplamente suportado (GitHub, editores, geradores de documentação)
   - Fácil versionamento com Git
   - Suporta blocos de código, tabelas e formatação rica
4. Exemplos conformes:

   ```bash
   # Criar relatório em Markdown
   cat > report.md <<'MARKDOWN'
   # Relatório de Análise
   
   ## Contexto
   
   - Data: $(date -Iseconds)
   - Escopo: Análise de conformidade
   
   ## Resultados
   
   - ✅ Item 1: Conforme
   - ❌ Item 2: Não conforme
   
   ## Recomendações
   
   1. Ajustar configuração X
   2. Revisar implementação Y
   MARKDOWN
   ```

#### Ferramentas e comandos GNU

- Listar arquivos Markdown no repositório:

  ```bash
  find . -name "*.md" -type f | sort
  ```

---

## Boas práticas adicionais

### Uso de set -euo pipefail

Todos os scripts devem iniciar com:

```bash
set -euo pipefail
```

- `set -e`: Sair imediatamente se qualquer comando falhar
- `set -u`: Tratar variáveis não definidas como erro
- `set -o pipefail`: Falhar se qualquer comando em pipeline falhar

### Validação de variáveis

Sempre validar variáveis críticas antes de usar:

```bash
# Validar que variável não está vazia
if [ -z "${VAR:-}" ]; then
  echo "❌ Erro: VAR não definida" >&2
  exit 1
fi

# Validar múltiplas variáveis
for var in VAR1 VAR2 VAR3; do
  if [ -z "${!var:-}" ]; then
    echo "❌ Erro: $var não definida" >&2
    exit 1
  fi
done
```

### Mensagens de erro

Sempre enviar mensagens de erro para stderr:

```bash
echo "❌ Erro: descrição do erro" >&2
```

### Logging estruturado

Usar prefixos consistentes para diferentes níveis de log:

```bash
echo "✅ Sucesso: operação concluída"
echo "⚠️  Aviso: possível problema"
echo "❌ Erro: falha na operação" >&2
echo "ℹ️  Info: informação relevante"
```

---

## Fluxo de atuação do agente

1. **Validação de scripts Bash**
   - Identificar uso de Python em scripts
   - Verificar uso excessivo de awk
   - Verificar uso de ferramentas não padrão
   - Verificar uso de wget em vez de curl
   - Verificar uso de HEREDOC

2. **Validação de formato de arquivos**
   - Verificar que logs e dados estruturados estão em JSON
   - Verificar que documentação está em Markdown

3. **Boas práticas**
   - Verificar uso de `set -euo pipefail`
   - Verificar validação de variáveis
   - Verificar mensagens de erro em stderr

4. **Relato de inconformidades**
   - Para cada violação, gerar relatório em formato JSON
   - Incluir arquivo, linha, problema e orientação de correção
   - Salvar em `docs/review/NNNN-report-bash.json`

---

## Estrutura do relatório de saída

- **Formato obrigatório: JSON**
- Caminho: `docs/review/NNNN-report-bash.json`
- Formato do identificador: `NNNN` (4 dígitos sequenciais, ex.: 0001, 0002)

Conteúdo mínimo:

```json
{
  "report_id": "NNNN",
  "title": "Review Bash Scripting – Relatório NNNN",
  "context": {
    "data_analise": "YYYY-MM-DD",
    "agente": "Engenharia - Bash Scripting",
    "escopo_analisado": "scripts Bash em workflows e entrypoints"
  },
  "premissas": [
    {
      "numero": 1,
      "nome": "Nunca usar Python em scripts Bash",
      "inconformidades": [
        {
          "arquivo": ".github/workflows/exemplo.yml",
          "linha": 42,
          "problema": "Uso de Python em script Bash",
          "antes": "python -c 'import json; print(json.dumps({\"key\": \"value\"}))'",
          "depois": "printf '{\"key\": \"value\"}\\n'",
          "orientacao": [
            "Remover uso de Python",
            "Implementar lógica em Bash puro",
            "Usar ferramentas GNU para manipulação de dados"
          ],
          "comando_gnu": "grep -Rn 'python -c\\|python3 -c' --include='*.sh' --include='*.yml' ."
        }
      ]
    }
  ]
}
```

---

## Comandos de apoio (referência para o agente)

```bash
# Verificar uso de Python
grep -Rin "python -c\|python3 -c\|#!/usr/bin/env python" --include="*.sh" --include="*.yml" --include="*.yaml" .

# Verificar uso de awk
grep -Rn "awk " --include="*.sh" --include="*.yml" --include="*.yaml" .

# Verificar uso de wget
grep -Rn "wget " --include="*.sh" --include="*.yml" --include="*.yaml" .

# Verificar uso de HEREDOC
grep -Rn "<<EOF\|<<-EOF\|<<'EOF'" --include="*.sh" --include="*.yml" --include="*.yaml" .

# Verificar scripts sem set -euo pipefail
find . -name "*.sh" -exec sh -c '
  if ! head -n 10 "$1" | grep -q "set -euo pipefail"; then
    echo "⚠️  Missing set -euo pipefail: $1"
  fi
' _ {} \;

# Listar arquivos JSON
find . -name "*.json" -type f | sort

# Listar arquivos Markdown
find . -name "*.md" -type f | sort
```

---

## Checklist de conformidade do agente Bash Scripting

- [ ] Nenhum script Bash usa Python
- [ ] Scripts preferem `grep` e `sed` em vez de `awk` (salvo casos complexos justificados)
- [ ] Scripts usam apenas ferramentas GNU e padrão Ubuntu
- [ ] Scripts usam `curl` para acesso a URLs e downloads (não `wget`)
- [ ] Nenhum script usa HEREDOC
- [ ] Arquivos de dados e logs estruturados estão em formato JSON
- [ ] Documentação, relatórios e guias estão em formato Markdown
- [ ] Todos os scripts iniciam com `set -euo pipefail`
- [ ] Variáveis críticas são validadas antes do uso
- [ ] Mensagens de erro são enviadas para stderr
- [ ] Comandos GNU documentados e utilizados para validação
- [ ] Relatórios de inconformidade gerados em formato JSON
