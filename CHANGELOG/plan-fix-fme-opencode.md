<!-- CHANGELOG/plan-fix-fme-opencode.md -->
# Prompt de execução — correção do fluxo de geração MFE/AppShell com padrão de templates

## Objetivo
Unificar a orquestração de geração de micro frontends (`microfrontend-generator.ts`) e app-shell (`appshell-generator.ts`) no fluxo principal de `gen/src/main.ts`, removendo geração manual de trechos TypeScript dentro dos geradores e migrando todo conteúdo gerado para `gen/templates`, mantendo arquivos estáticos de cópia em `gen/static` (API) e `gen/static-mfe` (MFE).

## Contexto de problema (design)
- Hoje há strings grandes de código embutidas em `gen/src/appshell-generator.ts` e `gen/src/microfrontend-generator.ts`.
- O padrão já existente do projeto (API generators) usa template engine + arquivos em `gen/templates`.
- A geração MFE/AppShell precisa seguir exatamente o mesmo padrão dos demais geradores (`entity`, `service`, `interface`, `controller`, `dto`, `module`, `app-module`, `main`, `env`, `package.json`, `readme`, `datasource`).

## Prompt para o agente A (execução passo a passo)

### 1) Auditoria inicial e mapeamento de trechos hardcoded
Use os comandos abaixo para localizar geração manual e pontos de integração:

```bash
find gen/src -maxdepth 1 -type f \( -name '*microfrontend*' -o -name '*appshell*' -o -name 'main.ts' \)
rg -n "writeFileSync\(|cpSync\(|copyFileSync\(|`import|<Route|defineConfig\(|package\.json|index\.html" gen/src/microfrontend-generator.ts gen/src/appshell-generator.ts
rg -n "new\s+TypeORMEntityGenerator|new\s+ServiceGenerator|new\s+MicrofrontendGenerator|new\s+AppShellGenerator" gen/src/main.ts
```

Critério: identificar todos os pontos em que strings inline viram arquivos no destino.

### 2) Criar/normalizar templates em `gen/templates`
Para cada arquivo gerado por conteúdo inline em MFE/AppShell, criar template dedicado em `gen/templates`.

Arquivos esperados (nomes sugeridos, mantendo padrão do projeto):
- `gen/templates/mfe-list-page.ejs` (já existe, validar cobertura)
- `gen/templates/mfe-details-page.ejs` (já existe, validar cobertura)
- `gen/templates/mfe-vite-config.ejs` (já existe, validar cobertura)
- `gen/templates/mfe-test-playwright.ejs` (já existe, validar cobertura)
- `gen/templates/mfe-app.ejs` (novo, para `src/App.tsx` do MFE)
- `gen/templates/app-shell-root-config.ejs` (novo)
- `gen/templates/app-shell-import-map.ejs` (novo, ou gerar JSON via template)
- `gen/templates/app-shell-app.ejs` (novo, para `src/App.tsx` do app-shell)
- `gen/templates/app-shell-package-json.ejs` (novo)
- `gen/templates/app-shell-index-html.ejs` (novo)
- `gen/templates/app-shell-vite-config.ejs` (novo)
- `gen/templates/app-shell-tsconfig.ejs` (novo)

Critério: nenhum trecho de código final deve permanecer hardcoded nos geradores quando se tratar de conteúdo de arquivo gerado.

### 3) Refatorar geradores para usar `TemplateEngine`
Replicar o mesmo padrão já praticado nos geradores de API.

#### Antes (exemplo real de anti-padrão)
```xml
<![CDATA[
// gen/src/microfrontend-generator.ts
private generateViteConfig(dir: string, config: MFEConfig): void {
  const content = `import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
...`;
  fs.writeFileSync(path.join(dir, 'vite.config.ts'), content);
}
]]>
```

#### Depois (padrão desejado)
```xml
<![CDATA[
// gen/src/microfrontend-generator.ts
private generateViteConfig(dir: string, config: MFEConfig): void {
  const content = this.templateEngine.render('mfe-vite-config.ejs', {
    name: config.name,
    port: config.port,
  });
  fs.writeFileSync(path.join(dir, 'vite.config.ts'), content);
}
]]>
```

#### Antes (exemplo app-shell hardcoded)
```xml
<![CDATA[
// gen/src/appshell-generator.ts
private generatePackageJson(destDir: string, mfeList: MFEConfig[]): void {
  const pkg = {
    name: 'app-shell',
    version: '1.0.0',
    ...
  };
  fs.writeFileSync(path.join(destDir, 'package.json'), JSON.stringify(pkg, null, 2));
}
]]>
```

#### Depois (padrão desejado)
```xml
<![CDATA[
// gen/src/appshell-generator.ts
private generatePackageJson(destDir: string, mfeList: MFEConfig[]): void {
  const content = this.templateEngine.render('app-shell-package-json.ejs', {
    mfeList,
  });
  fs.writeFileSync(path.join(destDir, 'package.json'), content);
}
]]>
```

### 4) Consolidar integração no `gen/src/main.ts`
Objetivo: manter MFE/AppShell no fluxo padrão principal, com chamadas explícitas em `main.ts` alinhadas ao switch de componentes.

#### Antes (chamada isolada por arquivos separados sem padrão de template completo)
```xml
<![CDATA[
import { MicrofrontendGenerator } from "./microfrontend-generator";
import { AppShellGenerator } from "./appshell-generator";
]]>
```

#### Depois (continua no main, mas com contrato padronizado)
```xml
<![CDATA[
import { MicrofrontendGenerator } from "./microfrontend-generator";
import { AppShellGenerator } from "./appshell-generator";

// dentro do switch:
case "mfes": {
  const mfeGenerator = new MicrofrontendGenerator(schemaPath, dbConfig, templateEngine);
  mfeConfigs = await mfeGenerator.generate();
  break;
}
case "app-shell": {
  const appShellGenerator = new AppShellGenerator(dbConfig, templateEngine);
  appShellGenerator.generate(mfeConfigs);
  break;
}
]]>
```

Observação: a mudança aqui é de contrato e padronização, não remoção obrigatória de classes dedicadas.

### 5) Preservar regra de estáticos por domínio
- API: manter cópia de estáticos em `gen/static`.
- MFE: manter estáticos em `gen/static-mfe`.

Se houver arquivos estáticos de MFE fora de `gen/static-mfe`, mover.
Se houver conteúdo dinâmico em `gen/static-mfe` que deveria ser template, migrar para `gen/templates`.

### 6) Aplicar substituições guiadas (replace seguro)
Use busca + replace dirigido para remover templates inline:

```bash
rg -n "return `|const content = `|JSON\.stringify\(pkg" gen/src/microfrontend-generator.ts gen/src/appshell-generator.ts
```

Para cada ocorrência:
1. extrair conteúdo para `.ejs` em `gen/templates`;
2. substituir por chamada ao render do template engine;
3. manter apenas composição de dados no TypeScript.

### 7) Validar alinhamento com padrão dos geradores API
Comparar implementação com geradores que já seguem padrão:

```bash
rg -n "TemplateEngine|template-loader|render\(" gen/src/*generator.ts
```

Critério de aceite técnico:
- MFE/AppShell usam o mesmo mecanismo de renderização por template.
- Não há geração manual de código-fonte final (TS/TSX/JS/JSON/HTML) embutida em string longa no gerador.
- Todo template novo está em `gen/templates`.

### 8) Checklist objetivo de conclusão
- [ ] `gen/src/main.ts` mantém a orquestração MFE/AppShell no fluxo principal.
- [ ] `gen/src/microfrontend-generator.ts` sem blocos longos de código inline para arquivos finais.
- [ ] `gen/src/appshell-generator.ts` sem blocos longos de código inline para arquivos finais.
- [ ] Templates necessários criados/movidos para `gen/templates`.
- [ ] `gen/static` apenas estáticos API.
- [ ] `gen/static-mfe` apenas estáticos MFE para cópia direta.
- [ ] Padrão consistente com geradores de API já existentes.

## Resultado esperado
A geração de micro frontends e app-shell passa a respeitar o design padrão do projeto: orquestração em `main.ts`, geradores especializados para cada artefato e conteúdo final sempre vindo do motor de templates.
