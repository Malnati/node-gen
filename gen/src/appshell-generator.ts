// gen/src/appshell-generator.ts
import * as fs from 'fs';
import * as path from 'path';
import { DbReaderConfig } from './interfaces';
import { MFEConfig } from './microfrontend-generator';
import { renderTemplate } from './utils/TemplateEngine';

export class AppShellGenerator {
  private config: DbReaderConfig;
  private staticMfePath: string;
  private staticAppShellPath: string;

  constructor(config: DbReaderConfig) {
    this.config = config;
    this.staticMfePath = path.resolve(__dirname, '..', 'static-mfe');
    this.staticAppShellPath = path.resolve(__dirname, '..', 'static-mfe', 'app-shell');
  }

  generate(mfeList: MFEConfig[]): void {
    const outputDir = path.join(this.config.outputDir, 'frontend', 'app-shell');
    if (!fs.existsSync(outputDir)) {
      fs.mkdirSync(outputDir, { recursive: true });
    }

    const frontendDir = path.join(this.config.outputDir, 'frontend');

    this.copyBoilerplate(outputDir);
    this.copyStaticAppShellFiles(outputDir);
    this.generateRootConfig(outputDir, mfeList);
    this.generateImportMap(outputDir, mfeList);
    this.generateAppShellTsx(outputDir, mfeList);
    this.generateIndexHtml(outputDir, mfeList);
    this.generateDockerCompose(frontendDir, mfeList);
    this.generateAppShellDockerfile(outputDir);

    console.log(`AppShell has been generated in ${outputDir}`);
  }

  private copyBoilerplate(destDir: string): void {
    const filesToCopy = [
      'src/main.tsx',
      'src/Bootstrap.tsx',
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
        fs.copyFileSync(srcPath, destFilePath);
      }
    });
  }

  private copyStaticAppShellFiles(destDir: string): void {
    const staticFiles = ['package.json', 'vite.config.ts', 'tsconfig.json', 'tsconfig.node.json'];
    staticFiles.forEach(file => {
      const srcPath = path.join(this.staticAppShellPath, file);
      if (fs.existsSync(srcPath)) {
        fs.copyFileSync(srcPath, path.join(destDir, file));
      }
    });
  }

  private generateRootConfig(destDir: string, mfeList: MFEConfig[]): void {
    const mfeApps = mfeList.map(mfe => ({
      name: mfe.name,
      route: mfe.route,
    }));

    const content = renderTemplate('app-shell-root-config.ejs', { mfeApps });
    fs.writeFileSync(path.join(destDir, 'root-config.js'), content);
  }

  private generateImportMap(destDir: string, mfeList: MFEConfig[]): void {
    const content = renderTemplate('app-shell-import-map.ejs', { mfeList });
    fs.writeFileSync(path.join(destDir, 'import-map.json'), content);
  }

  private generateAppShellTsx(destDir: string, mfeList: MFEConfig[]): void {
    const srcDir = path.join(destDir, 'src');
    if (!fs.existsSync(srcDir)) {
      fs.mkdirSync(srcDir, { recursive: true });
    }

    const content = renderTemplate('app-shell-app.ejs', { mfeList });
    fs.writeFileSync(path.join(srcDir, 'App.tsx'), content);
  }

  private generateIndexHtml(destDir: string, mfeList: MFEConfig[]): void {
    const importMapJson = renderTemplate('app-shell-import-map.ejs', { mfeList });
    const content = renderTemplate('app-shell-index-html.ejs', { importMapJson });
    fs.writeFileSync(path.join(destDir, 'index.html'), content);
  }

  private generateDockerCompose(frontendDir: string, mfeList: MFEConfig[]): void {
    const content = renderTemplate('mfe-docker-compose.ejs', { mfeList });
    fs.writeFileSync(path.join(frontendDir, 'docker-compose.mfe.yml'), content);
  }

  private generateAppShellDockerfile(destDir: string): void {
    const content = renderTemplate('mfe-dockerfile.ejs', {
      kebabName: 'app-shell',
      port: 9000,
    });
    fs.writeFileSync(path.join(destDir, 'Dockerfile'), content);
  }

}
