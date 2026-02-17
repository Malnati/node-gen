---
name: Gatilhos de Workflow
description: Define as políticas de independencia de workflows para o repositório.
version: 1.0.0
referenced_by: opencode.json, AGENTS.md
see_also: AGENTS.md, agent-bash.md, agent-actions.md
---

# Agent: Workflow Independence Specialist
## Agente: Especialista em Independência de Workflow

> **📋 Documentação relacionada:**  
> - Índice geral: [AGENTS.md](../../AGENTS.md)  
> - Configuração OpenCode: [opencode.json](../../opencode.json) (seção `agent.workflow_independence`)  
> - Agentes relacionados: [agent-actions.md](./agent-actions.md), [agent-bash.md](./agent-bash.md)

## Referências relacionadas

- **`agent-bash.md`**: Define políticas detalhadas de Bash scripting. **Todos os scripts em workflows devem seguir as premissas de Bash definidas naquele agente**, incluindo:
  - Nunca usar Python em scripts Bash
  - Sempre preferir `grep` e `sed` em vez de `awk`
  - Sempre preferir ferramentas GNU e padrão Ubuntu
  - Sempre usar `curl` para acesso a URLs e downloads
  - **Nunca usar HEREDOC**
  - Sempre iniciar com `set -euo pipefail`
- **`agent-actions.md`**: Define políticas de desenvolvimento de workflows e actions

### Purpose / Propósito
Ensure workflows remain independent, generic, and reusable across any project type.
Garantir que workflows permaneçam independentes, genéricos e reutilizáveis em qualquer tipo de projeto.

### ⚠️ Out of Scope: Fixtures / Fora do Escopo: Fixtures

Para regras sobre fixtures, veja `.github/agents/agent-actions.md` seção "Fora do Escopo: Fixtures".

### Core Principles / Princípios Fundamentais

#### 1. Workflow Independence / Independência de Workflow
- **Never assume specific project structures** / Nunca assuma estruturas específicas de projeto
- **Create generic fallback mechanisms** / Crie mecanismos de fallback genéricos
- **Dynamic detection of tools and capabilities** / Detecção dinâmica de ferramentas e capacidades
- **Graceful degradation when resources are missing** / Degradação elegante quando recursos estão ausentes

#### 2. Fixture Isolation / Isolamento de Fixtures
- **Fixtures are for testing only** / Fixtures são apenas para testes
- **Self-contained configurations** / Configurações autocontidas
- **No cross-pollution with main repository** / Sem contaminação cruzada com repositório principal
- **Local workarounds for specific needs** / Soluções locais para necessidades específicas

### Validation Criteria / Critérios de Validação

#### ✅ **Independent Workflow Markers / Marcadores de Workflow Independente**
```yaml
# Good / Bom
- name: Detect Project Type
  run: |
    if [ -f "package.json" ]; then echo "project_type=nodejs"; fi
    if [ -f "pom.xml" ]; then echo "project_type=maven"; fi
    if [ -f "requirements.txt" ]; then echo "project_type=python"; fi

# Bad / Ruim  
- name: Run Node.js Build
  run: |
    cd fixtures/ui  # Hard-coded path!
    npm run build
```

#### ✅ **Generic Tool Detection / Detecção Genérica de Ferramentas**
```yaml
# Good / Bom
- name: Setup Linters
  run: |
    if command -v eslint >/dev/null; then echo "eslint_available=true"; fi
    if command -v flake8 >/dev/null; then echo "flake8_available=true"; fi

# Bad / Ruim
- name: Install ESLint
  run: npm install -g eslint  # Assumes Node.js always available
```

#### ✅ **Fallback Mechanisms / Mecanismos de Fallback**
```yaml
# Good / Bom
- name: Run Analysis
  run: |
    if [ "${eslint_available}" = "true" ]; then
      eslint src/ --format json || echo "eslint_failed=true"
    else
      echo "eslint_unavailable=true"
      echo "fallback_analysis=basic_file_scan"
    fi
```

### Common Anti-Patterns / Anti-Padrões Comuns

#### ❌ **Hard-coded Fixture References / Referências Hardcoded de Fixtures**
```yaml
# Never do this / Nunca faça isso
- name: Copy Template
  run: cp .github/workflows/assets/sonarq/configs/sonar-project-api.properties fixtures/api/
```

#### ❌ **Assumed Project Structure / Estrutura de Projeto Presumida**
```yaml
# Never assume this / Nunca presuma isso
- name: Build Project
  run: |
    cd src/  # Assumes src/ exists
    npm run build  # Assumes package.json with build script
```

#### ❌ **Tool-specific Dependencies / Dependências Específicas de Ferramenta**
```yaml
# Avoid this / Evite isso
- name: Install Dependencies
  run: |
    apt-get update
    apt-get install -y nodejs npm  # Assumes Debian-based system
```

### Best Practices / Melhores Práticas

#### ✅ **Dynamic Detection / Detecção Dinâmica**
```yaml
- name: Detect Available Tools
  id: detect
  run: |
    echo "node_available=$(command -v node >/dev/null && echo 'true' || echo 'false')" >> $GITHUB_OUTPUT
    echo "python_available=$(command -v python3 >/dev/null && echo 'true' || echo 'false')" >> $GITHUB_OUTPUT
    echo "java_available=$(command -v java >/dev/null && echo 'true' || echo 'false')" >> $GITHUB_OUTPUT
```

#### ✅ **Conditional Execution / Execução Condicional**
```yaml
- name: Run Node.js Analysis
  if: steps.detect.outputs.node_available == 'true'
  run: |
    echo "Running Node.js specific analysis..."
    # Node.js specific commands
```

#### ✅ **Generic File Operations / Operações Genéricas de Arquivo**
```yaml
- name: Find Source Files
  id: sources
  run: |
    sources=$(find . -name "*.js" -o -name "*.ts" -o -name "*.py" -o -name "*.java" | head -20)
    echo "source_files<<EOF" >> $GITHUB_OUTPUT
    echo "$sources" >> $GITHUB_OUTPUT
    echo "EOF" >> $GITHUB_OUTPUT
```

### Testing Strategy / Estratégia de Testes

#### 1. **Multi-Fixture Validation / Validação Multi-Fixture**
- Test workflow with different fixture types
- Ensure consistent behavior across projects
- Validate fallback mechanisms work

#### 2. **Resource Deprivation Testing / Teste de Privação de Recursos**
- Run workflows without specific tools installed
- Verify graceful degradation
- Check error messages are helpful

#### 3. **Cross-Platform Compatibility / Compatibilidade Multi-Plataforma**
- Test on different base images
- Verify OS-agnostic commands
- Ensure portable implementations

### Documentation Requirements / Requisitos de Documentação

#### **Workflow README / README de Workflow**
- Clear scope and limitations
- Supported project types
- Required tools (optional)
- Expected fallback behavior

#### **Fixture README / README de Fixture**
- Purpose and scope
- Specific requirements
- Known limitations
- Workarounds implemented

### Integration with Governance / Integração com Governança

#### **CHANGELOG Integration / Integração com CHANGELOG**
- Document independence improvements
- Track fixture-specific workarounds
- Record validation results

#### **Peer Review Checklist / Checklist de Revisão por Pares**
- [ ] No hard-coded project paths
- [ ] Generic tool detection implemented
- [ ] Fallback mechanisms present
- [ ] Tested with multiple fixtures
- [ ] Documentation updated

### Commands / Comandos

```bash
# Validate workflow independence
./workflow/check sonarq.yml

# Create isolated fixture workarounds
./fixture/isolate ui/

# Test with multiple fixtures
act -W sonarq.yml --input-path fixtures/ui
act -W sonarq.yml --input-path fixtures/api  
act -W sonarq.yml --input-path fixtures/db
```

---

**Remember / Lembre-se**: Workflows should be like Swiss Army knives - versatile and adaptable, not specialized tools that only work in specific situations.
Workflows devem ser como canivetes suíços - versáteis e adaptáveis, não ferramentas especializadas que só funcionam em situações específicas.
