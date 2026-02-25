// /src/appshell-generator.ts
import * as fs from 'fs';
import * as path from 'path';
import { DbReaderConfig } from './interfaces';
import { MFEConfig } from './microfrontend-generator';

export class AppShellGenerator {
  private config: DbReaderConfig;
  private staticMfePath: string;

  constructor(config: DbReaderConfig) {
    this.config = config;
    this.staticMfePath = path.resolve(__dirname, '..', 'static-mfe');
  }

  generate(mfeList: MFEConfig[]): void {
    const outputDir = path.join(this.config.outputDir, 'frontend', 'app-shell');
    if (!fs.existsSync(outputDir)) {
      fs.mkdirSync(outputDir, { recursive: true });
    }

    this.copyBoilerplate(outputDir);
    this.generateRootConfig(outputDir, mfeList);
    this.generateImportMap(outputDir, mfeList);
    this.generateAppShellTsx(outputDir, mfeList);
    this.generatePackageJson(outputDir, mfeList);
    this.updateIndexHtml(outputDir, mfeList);

    console.log(`AppShell has been generated in ${outputDir}`);
  }

  private copyBoilerplate(destDir: string): void {
    const filesToCopy = [
      'src/main.tsx',
      'src/Bootstrap.tsx',
      'src/api/client.ts',
      'src/components/Loading.tsx',
      'src/components/ErrorBoundary.tsx',
    ];

    filesToCopy.forEach(file => {
      const srcPath = path.join(this.staticMfePath, file);
      const destFilePath = path.join(destDir, file);
      const destDirPath = path.dirname(destFilePath);
      
      if (!fs.existsSync(destDirPath)) {
        fs.mkdirSync(destDirPath, { recursive: true });
      }
      
      if (fs.existsSync(srcPath)) {
        let content = fs.readFileSync(srcPath, 'utf-8');
        content = content.replace(/import \* as ReactDOM from 'react-dom';/g, "import ReactDOM from 'react-dom';");
        fs.writeFileSync(destFilePath, content);
      }
    });

    const srcDir = path.join(destDir, 'src');
    const componentsDir = path.join(srcDir, 'components');
    const apiDir = path.join(srcDir, 'api');
    
    if (!fs.existsSync(componentsDir)) fs.mkdirSync(componentsDir, { recursive: true });
    if (!fs.existsSync(apiDir)) fs.mkdirSync(apiDir, { recursive: true });

    ['Loading.tsx', 'ErrorBoundary.tsx'].forEach(file => {
      const srcPath = path.join(this.staticMfePath, 'src', 'components', file);
      const destPath = path.join(componentsDir, file);
      if (fs.existsSync(srcPath)) {
        fs.copyFileSync(srcPath, destPath);
      }
    });

    const apiClientSrc = path.join(this.staticMfePath, 'src', 'api', 'client.ts');
    const apiClientDest = path.join(apiDir, 'client.ts');
    if (fs.existsSync(apiClientSrc)) {
      fs.copyFileSync(apiClientSrc, apiClientDest);
    }
  }

  private generateRootConfig(destDir: string, mfeList: MFEConfig[]): void {
    const mfeApps = mfeList.map(mfe => ({
      name: mfe.name,
      route: mfe.route,
    }));

    let content = `import { registerApplication, start } from 'single-spa';

const mfeApps = [
${mfeApps.map(app => `  { name: '${app.name}', route: '${app.route}' },`).join('\n')}
];

mfeApps.forEach(app => {
  registerApplication(
    app.name,
    () => window.importShim(app.name),
    () => window.location.pathname.startsWith(app.route)
  );
});

start();
`;

    fs.writeFileSync(path.join(destDir, 'root-config.js'), content);
  }

  private generateImportMap(destDir: string, mfeList: MFEConfig[]): void {
    const importMap = {
      imports: {
        'react': 'https://esm.sh/react@18.2.0',
        'react-dom': 'https://esm.sh/react-dom@18.2.0',
        'react-dom/client': 'https://esm.sh/react-dom@18.2.0/client',
        'single-spa': 'https://esm.sh/single-spa@5.9.4',
        'react-router-dom': 'https://esm.sh/react-router-dom@6.20.0',
        'axios': 'https://esm.sh/axios@1.6.2',
        ...Object.fromEntries(mfeList.map(mfe => [mfe.name, `http://localhost:9000/mfes/${mfe.kebabName}-mfe/main.js`])),
      },
    };

    fs.writeFileSync(path.join(destDir, 'import-map.json'), JSON.stringify(importMap, null, 2));
  }

  generateImportMapString(mfeList: MFEConfig[]): string {
    const importMap = {
      imports: {
        'react': 'https://esm.sh/react@18.2.0',
        'react-dom': 'https://esm.sh/react-dom@18.2.0',
        'react-dom/client': 'https://esm.sh/react-dom@18.2.0/client',
        'single-spa': 'https://esm.sh/single-spa@5.9.4',
        'react-router-dom': 'https://esm.sh/react-router-dom@6.20.0',
        'axios': 'https://esm.sh/axios@1.6.2',
        ...Object.fromEntries(mfeList.map(mfe => [mfe.name, `http://localhost:9000/mfes/${mfe.kebabName}-mfe/main.js`])),
      },
    };
    return JSON.stringify(importMap, null, 2);
  }

  private generateAppShellTsx(destDir: string, mfeList: MFEConfig[]): void {
    const routes = mfeList.map(mfe => {
      const componentName = `${mfe.pascalName}ListPage`;
      return `  <Route path="${mfe.route}" element={<${componentName} />} />
  <Route path="${mfe.route}/:id" element={<${mfe.pascalName}DetailsPage />} />`;
    }).join('\n');

    const imports = mfeList.map(mfe => {
      return `import { ${mfe.pascalName}ListPage } from '../${mfe.kebabName}-mfe/src/pages/${mfe.kebabName}-list-page';
import { ${mfe.pascalName}DetailsPage } from '../${mfe.kebabName}-mfe/src/pages/${mfe.kebabName}-details-page';`;
    }).join('\n');

    const content = `import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
${imports}

function App() {
  return (
    <BrowserRouter>
      <Routes>
${routes}
        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </BrowserRouter>
  );
}

export default App;
`;

    fs.writeFileSync(path.join(destDir, 'src', 'App.tsx'), content);
  }

  private generatePackageJson(destDir: string, mfeList: MFEConfig[]): void {
    const pkg = {
      name: 'app-shell',
      version: '1.0.0',
      type: 'module',
      scripts: {
        dev: 'vite',
        build: 'tsc && vite build',
        preview: 'vite preview',
        'serve:mfe': 'npx serve dist -l 9000',
      },
      dependencies: {
        react: '^18.2.0',
        'react-dom': '^18.2.0',
        'react-router-dom': '^6.20.0',
        'single-spa': '^5.9.4',
      },
      devDependencies: {
        '@types/react': '^18.2.43',
        '@types/react-dom': '^18.2.17',
        '@vitejs/plugin-react': '^4.2.1',
        typescript: '^5.3.3',
        vite: '^5.0.8',
      },
    };

    fs.writeFileSync(path.join(destDir, 'package.json'), JSON.stringify(pkg, null, 2));
  }

  private updateIndexHtml(destDir: string, mfeList: MFEConfig[]): void {
    const importMapJson = this.generateImportMapString(mfeList);
    const htmlContent = `<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>App Shell</title>
    <script type="systemjs-importmap">
${importMapJson}
    </script>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.tsx"></script>
  </body>
</html>
`;

    fs.writeFileSync(path.join(destDir, 'index.html'), htmlContent);

    const viteConfig = `import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [react()],
  server: {
    port: 9000,
    headers: {
      'Access-Control-Allow-Origin': '*',
    },
  },
  build: {
    outDir: 'dist',
  },
});
`;
    fs.writeFileSync(path.join(destDir, 'vite.config.ts'), viteConfig);

    const tsconfig = {
      compilerOptions: {
        target: 'ES2020',
        useDefineForClassFields: true,
        lib: ['ES2020', 'DOM', 'DOM.Iterable'],
        module: 'ESNext',
        skipLibCheck: true,
        moduleResolution: 'bundler',
        allowImportingTsExtensions: true,
        resolveJsonModule: true,
        isolatedModules: true,
        noEmit: true,
        jsx: 'react-jsx',
        strict: true,
        noUnusedLocals: true,
        noUnusedParameters: true,
        noFallthroughCasesInSwitch: true,
        esModuleInterop: true,
        allowSyntheticDefaultImports: true,
        forceConsistentCasingInFileNames: true,
      },
      include: ['src'],
    };
    fs.writeFileSync(path.join(destDir, 'tsconfig.json'), JSON.stringify(tsconfig, null, 2));
  }
}
