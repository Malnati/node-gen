# Plano: Geração de Micro Frontends (MFEs) no node-gen

## Visão Geral do Sistema

```
┌─────────────┐     ┌──────────────────┐     ┌─────────────────┐
│  Database  │────▶│   NestJS API     │────▶│  MFEs (React)  │
│  (Schema)  │     │  (node-gen)       │     │  (Vite + MF)   │
└─────────────┘     └──────────────────┘     └────────┬────────┘
                                                     │
                              ┌──────────────────────▼──────────┐
                              │   Single-spa Orchestrator     │
                              │   (App Shell - porta 9000)    │
                              └──────────────┬─────────────────┘
                                             │
                        ┌────────────────────▼─────────────────┐
                        │      Playwright E2E Tests            │
                        │   (validação UI + integração)         │
                        └──────────────────────────────────────┘
```

## Tarefa

Criar uma nova funcionalidade de geração chamada MicroFrontendGenerator que segue o padrão das classes existentes (como ControllerGenerator) e implementa a seguinte lógica:

### Conhecimento Partilhado entre Geradores

Para que o AppShellGenerator consiga criar um import-map funcional e registrar os MFEs no Single-spa, é necessário implementar um contrato de dados entre os geradores:

1. **MicroFrontendGenerator** gera os projetos MFE por tabela e retorna uma lista de configurações (`MFEConfig[]`)
2. **AppShellGenerator** recebe essa lista e utiliza os metadados para:
   - Gerar o `import-map.json` dinamicamente
   - Criar o `root-config.js` com `registerApplication` para cada MFE
   - Configurar as rotas no App Shell

Este padrão de "conhecimento partilhado" segue o mesmo princípio utilizado em outras partes do node-gen onde o `main.ts` coordena a passagem de dados entre geradores.

### Localização de Ativos Estáticos

- Toda a estrutura base (boilerplate) do projeto React deve residir em uma nova pasta chamada `gen/static-mfe`.
- O gerador deve copiar o conteúdo de `gen/static-mfe` para cada novo diretório de projeto gerado (ex: `frontend/[entity-name]-mfe/`).

### Estrutura de Projetos Distintos

- Para cada tabela no esquema (Table[]), deve ser gerado um projeto React independente.
- Utiliza as funções `toKebabCase` e `toPascalCase` para nomear pastas e componentes.

### Novos Templates EJS (em gen/templates)

| Template | Descrição |
|----------|-----------|
| `mfe-list-page.ejs` | Tela de listagem baseada em GET / |
| `mfe-details-page.ejs` | Tela de detalhes/edição baseada em GET /:id e PUT /:id |
| `mfe-webpack-config.ejs` | Configuração de Module Federation para transformar o projeto em um "remote app" |

### Orquestrador (App Shell)

- Implementa um AppShellGenerator que gera um projeto central para consumir os MFEs.
- Este Shell deve ser configurado dinamicamente para incluir as rotas de todos os micro-frontends gerados a partir do esquema.
- Se não informado parâmetro 'app-shell', gera automaticamente quando 'mfes' estiver ativo.

### Atualização de Interfaces

- Modifica a interface DbReaderConfig em interfaces.ts para incluir 'mfes' e 'app-shell' no array de componentes permitidos.

### Requisitos Técnicos

- Os MFEs devem usar Axios para se comunicar com a API gerada.
- A lógica de identificação de Primary Keys e colunas deve ser usada para gerar automaticamente os formulários e parâmetros de URL (ex: :id ou :external_id) nos arquivos .tsx.

---

## Fase 1: Estrutura Base do MFE (gen/static-mfe/)

### Arquivos a criar em `gen/static-mfe/`:

| Arquivo | Descrição |
|---------|-----------|
| `package.json` | Dependencies: react, react-dom, axios, react-router-dom, vite |
| `vite.config.ts` | Config Vite com plugin `vite-plugin-single-spa` |
| `tsconfig.json` | TypeScript para React |
| `index.html` | Entry HTML para Vite |
| `src/main.tsx` | Entry point React |
| `src/App.tsx` | Componente raiz |
| `src/api/client.ts` | Cliente Axios configurado |
| `src/components/` | Loading, ErrorBoundary |
| `src/pages/` | Placeholder para ListPage/DetailsPage |
| `src/bootstrap.tsx` | Bootstrap para lazy loading |
| `root-config.js` | Template Single-spa para orquestrador |

---

## Fase 2: Templates EJS (gen/templates/)

| Template | Descrição |
|----------|-----------|
| `mfe-list-page.ejs` | Página de listagem (GET /), tabela com dados, botão "Novo" |
| `mfe-details-page.ejs` | Página detalhes/edição (GET /:id, PUT /:id) |
| `mfe-vite-config.ejs` | Configuração Vite com Single-spa expose |

---

## Fase 3: Geradores (gen/src/)

### 3.1 MicrofrontendGenerator - Contrato de Saída

**Importante:** O `MicroFrontendGenerator` deve retornar uma lista de objetos com metadados para que o `AppShellGenerator` possa criar o import-map e o root-config dinamicamente.

```typescript
interface MFEConfig {
  name: string;      // Nome do MFE (ex: "account-mfe")
  kebabName: string; // Nome em kebab-case para URL (ex: "account")
  pascalName: string; // Nome em PascalCase para componente (ex: "Account")
  port: number;      // Porta do MFE (gerada dinamicamente)
  route: string;     // Rota no App Shell (ex: "/account")
}

class MicrofrontendGenerator {
  generate(): MFEConfig[] // Retorna lista de MFEs com metadados
  
  // Para cada tabela:
  // 1. Criar diretório frontend/[entity-name]-mfe/
  // 2. Copiar gen/static-mfe
  // 3. Gerar ListPage.tsx via template
  // 4. Gerar DetailsPage.tsx via template
  // 5. Gerar vite.config.ts com expose
  // 6. Configurar routes no App.tsx
}
```

### 3.2 AppShellGenerator - Conhecimento Partilhado

```typescript
class AppShellGenerator {
  // Se não informado parâmetro 'app-shell', gera automaticamente
  // Se informado 'app-shell=false', não gera
  
  generate(mfeList: MFEConfig[]): void
  
  // 1. Criar diretório frontend/app-shell/
  // 2. Copiar boilerplate React + react-router-dom
  // 3. Gerar root-config.js com registerApplication para cada MFE
  // 4. Gerar import-map.json dinamicamente via generateImportMap()
  // 5. Gerar routes dinamicamente para cada MFE
  // 6. Configurar como remote no webpack/vite
}
```

### 3.3 Geração Dinâmica do import-map.json

O `AppShellGenerator` deve implementar o método `generateImportMap()` que produz um JSON no formato SystemJS:

```typescript
generateImportMap(mfeList: MFEConfig[]): string {
  // Para ambiente E2E: http://localhost:9000
  // Mapeia cada MFE para subdiretórios estáticos: /mfes/[nome]/main.js
  const importMap = {
    "imports": {
      "react": "https://esm.sh/react@18.2.0",
      "react-dom": "https://esm.sh/react-dom@18.2.0",
      "single-spa": "https://esm.sh/single-spa@5.9.4",
      // ... cada MFE:
      "@mfe/account": "http://localhost:9000/mfes/account-mfe/main.js",
      "@mfe/product": "http://localhost:9000/mfes/product-mfe/main.js",
    }
  };
  return JSON.stringify(importMap, null, 2);
}
```

#### Injeção no Template index.html

Atualizar o template `gen/static-mfe/index.html` para incluir a tag `<script type="systemjs-importmap">`:

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title><%= appName %></title>
    <!-- Import Map Gerado Dinamicamente -->
    <script type="systemjs-importmap">
<%- importMap %>
    </script>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.tsx"></script>
  </body>
</html>
```

---

## Fase 4: Atualização de Interfaces

### Arquivo: `gen/src/interfaces.ts`

Adicionar aos componentes permitidos:

```typescript
components: [
  // ... existentes ...
  'mfes',        // Gera MFEs por tabela
  'app-shell'    // Gera App Shell (auto se mfes ativo)
]
```

### Arquivo: `gen/src/main.ts`

Adicionar casos no switch:

```typescript
case "mfes": {
  const mfeGen = new MicrofrontendGenerator(schemaPath, dbConfig);
  const mfeList = await mfeGen.generate();
  // Passar mfeList para AppShellGenerator se app-shell não desabilitado
  break;
}
```

---

## Fase 5: Infraestrutura de Testes E2E

### 5.1 Configuração Single-spa Root Config

**Arquivo: `gen/static-mfe/root-config.js`**

- Template para orquestrador que registra cada MFE como aplicação remota
- Configuração de lifecycle (bootstrap, mount, unmount)

### 5.2 Atualização docker-compose.e2e.yml

```yaml
services:
  # ... existentes ...
  single-spa:
    image: node-gen-e2e:latest
    command: ["sh", "-c", "npm run serve:mfe"]
    ports:
      - "9000:9000"
    volumes:
      - ./output:/app/output
    environment:
      NODE_ENV: development
    depends_on:
      e2e:
        condition: service_completed_successfully
```

### 5.3 Script serve:mfe no package.json

Adicionar ao package.json do projeto gerado:

```json
{
  "scripts": {
    "serve:mfe": "npx serve frontend/app-shell -l 9000"
  }
}
```

### 5.4 Configuração do Root Config Single-spa

O `AppShellGenerator` deve gerar o arquivo `root-config.js` que utiliza `registerApplication` do Single-spa para cada item da lista de MFEs:

```javascript
// frontend/app-shell/root-config.js
import { registerApplication, start } from 'single-spa';

const mfeApps = [
  { name: '@mfe/account', route: '/account' },
  { name: '@mfe/product', route: '/product' },
  // ... gerado dinamicamente
];

mfeApps.forEach(app => {
  registerApplication(
    app.name,
    () => window.importShim(app.name),
    () => window.location.pathname.startsWith(app.route)
  );
});

start();
```

---

### 5.5 Template de Teste Playwright

**Arquivo: `gen/templates/mfe-test-playwright.ejs`**

O gerador deve criar um arquivo `test/e2e-mfe/[entity].spec.ts` para cada tabela:

```typescript
import { test, expect } from '@playwright/test';

test.describe('<%= pascalName %> MFE', () => {
  
  test.beforeEach(async ({ page }) => {
    // Espera o Single-spa estar pronto
    await page.goto('http://localhost:9000');
  });

  test('Listagem - carrega dados da API', async ({ page }) => {
    await page.goto('http://localhost:9000/<%= kebabName %>');
    
    // Valida elementos gerados pelo template mfe-list-page.ejs
    await expect(page.locator('[data-testid="mfe-list-table"]')).toBeVisible();
    await expect(page.locator('[data-testid="mfe-list-loading"]')).not.toBeVisible();
  });

  test('Navegação para detalhes', async ({ page }) => {
    await page.goto('http://localhost:9000/<%= kebabName %>');
    
    // Clica na primeira linha da tabela
    await page.locator('[data-testid="mfe-list-table"] tbody tr').first().click();
    
    // Valida navegação para página de detalhes
    await expect(page.url()).toContain('/<%= kebabName %>/');
    await expect(page.locator('[data-testid="mfe-details-form"]')).toBeVisible();
  });

  test('Edição - PUT /:id', async ({ page }) => {
    await page.goto('http://localhost:9000/<%= kebabName %>/<%= entityId %>');
    
    // Preenche formulário e submete
    await page.fill('[data-testid="field-<%= firstField %>"]', 'novo-valor');
    await page.click('[data-testid="mfe-details-submit"]');
    
    // Valida sucesso
    await expect(page.locator('[data-testid="mfe-toast-success"]')).toBeVisible();
  });
});
```

### 5.6 Integração no run.js - Fase de Execução

Atualizar o script `test/e2e-generator/run.js` para incluir uma nova fase de execução:

```javascript
async function executePlaywrightTests(projectOutDir) {
  const mfeDir = path.join(projectOutDir, 'frontend');
  if (!fs.existsSync(mfeDir)) {
    console.log('[e2e] Diretório MFEs não encontrado, pulando testes UI');
    return true;
  }

  // Identificar MFEs gerados
  const mfeDirs = fs.readdirSync(mfeDir).filter(d => d.endsWith('-mfe'));
  
  if (mfeDirs.length === 0) {
    console.log('[e2e] Nenhum MFE encontrado, pulando testes UI');
    return true;
  }

  console.log('[e2e] MFEs detectados:', mfeDirs.join(', '));

  // Verificar se Single-spa está disponível
  const singleSpaReady = await waitForPort(9000, 30000);
  if (!singleSpaReady) {
    console.error('[e2e] Single-spa Orchestrator não está disponível na porta 9000');
    return false;
  }

  // Verificar se API está respondendo
  const apiPort = readPortFromEnv(projectOutDir);
  const apiReady = await waitForPort(apiPort, 10000);
  if (!apiReady) {
    console.error('[e2e] API não está disponível na porta', apiPort);
    return false;
  }

  // Executar testes Playwright
  console.log('[e2e] Executando testes Playwright para MFEs...');
  const testDir = path.join(projectOutDir, 'test', 'e2e-mfe');
  
  const result = spawnSync('npx', ['playwright', 'test', testDir], {
    cwd: projectOutDir,
    stdio: 'inherit',
    timeout: 120000,
  });

  return result.status === 0;
}
```

### 5.7 Atualização entrypoint.e2e.sh

```bash
# Adicionar após healthcheck da API e antes dos testes E2E:

echo "[e2e] Instalando dependências Playwright..."
npm install -g playwright
npx playwright install --with-deps chromium

echo "[e2e] Subindo Single-spa Orchestrator (porta 9000)..."
cd /app/output
npm run serve:mfe &
SPA_PID=$!

# Aguardar Single-spa estar pronto
for i in $(seq 1 30); do
  if curl -s http://localhost:9000 > /dev/null 2>&1; then
    echo "[e2e] Single-spa Orchestrator pronto na porta 9000"
    break
  fi
  if [ "$i" -eq 30 ]; then
    echo "[e2e] Single-spa Orchestrator não iniciou a tempo"
    kill $SPA_PID 2>/dev/null || true
    exit 1
  fi
  sleep 1
done

echo "[e2e] Executando testes E2E MFEs..."
npx playwright test test/e2e-mfe --reporter=html

# Guardar código de saída
TEST_EXIT=$?

# Cleanup
kill $SPA_PID 2>/dev/null || true

exit $TEST_EXIT
```

---

## Fase 6: Parâmetros de Linha de Comando

| Parâmetro | Descrição | Padrão |
|-----------|-----------|--------|
| `-f, --components` | Componentes (incluir 'mfes') | - |
| `--app-shell` | Controla geração do App Shell | `auto` (gera se mfes ativo) |
| `--app-shell=false` | Não gera App Shell | - |

---

## Arquivos a Modificar

| Arquivo | Ação |
|---------|------|
| `gen/src/interfaces.ts` | Adicionar 'mfes', 'app-shell' aos components |
| `gen/src/main.ts` | Adicionar casos no switch, coordenar geração MFEs → AppShell |
| `gen/src/microfrontend-generator.ts` | **NOVO** - Implementar MicrofrontendGenerator com retorno MFEConfig[] |
| `gen/src/appshell-generator.ts` | **NOVO** - Implementar AppShellGenerator com generateImportMap() |
| `gen/package.json` | Adicionar dependências React/Vite/Playwright |
| `gen/templates/mfe-list-page.ejs` | **NOVO** - Template página listagem |
| `gen/templates/mfe-details-page.ejs` | **NOVO** - Template página detalhes/edição |
| `gen/templates/mfe-vite-config.ejs` | **NOVO** - Template config Vite |
| `gen/templates/mfe-test-playwright.ejs` | **NOVO** - Template testes Playwright |
| `.docker/docker-compose.e2e.yml` | Adicionar serviço single-spa |
| `.docker/entrypoint.e2e.sh` | Adicionar instalação Playwright + serve:mfe |
| `test/e2e-generator/run.js` | Adicionar fase executePlaywrightTests() |
| `test/e2e-generator/e2e.json` | Adicionar validações MFE |

---

## Fluxo de Execução em Container

```
1. Subir containers DB (mysql, postgres, sqlserver)
2. Aguardar healthcheck de cada DB
3. node-gen gerar API backend
4. API backend iniciar e responder /health
5. node-gen gerar MFEs (se 'mfes' em components)
6. Gerar App Shell automaticamente (se não desabilitado)
7. Subir Single-spa Orchestrator (porta 9000)
8. Instalar Playwright browsers
9. Executar testes Playwright por entidade
10. Relatório de resultados
```

---

## Critérios de Aceite

### Geração de MFEs
- [ ] `gen/static-mfe/` existe e contém boilerplate React completo
- [ ] Templates EJS geram páginas funcionais com data-testids
- [ ] MicrofrontendGenerator cria diretório por tabela
- [ ] MicrofrontendGenerator.generate() retorna MFEConfig[] com metadados

### App Shell e Import Maps
- [ ] AppShellGenerator registra todos os MFEs dinamicamente
- [ ] generateImportMap() produz JSON válido no formato SystemJS
- [ ] index.html inclui tag `<script type="systemjs-importmap">` gerada dinamicamente
- [ ] root-config.js utiliza registerApplication para cada MFE

### Interface e Coordenação
- [ ] Interface DbReaderConfig aceita 'mfes' e 'app-shell'
- [ ] main.ts coordena passagem de dados entre MicrofrontendGenerator e AppShellGenerator

### Infraestrutura E2E
- [ ] docker-compose.e2e.yml sobe serviço single-spa na porta 9000
- [ ] entrypoint.e2e.sh instala Playwright antes dos testes
- [ ] Healthcheck da API é verificado antes dos testes UI
- [ ] Healthcheck do Single-spa é verificado antes dos testes UI

### Testes Playwright
- [ ] Testes validam listagem (GET /)
- [ ] Testes validam navegação para detalhes
- [ ] Testes validam edição (PUT /:id)
- [ ] testes usam data-testids gerados pelos templates
