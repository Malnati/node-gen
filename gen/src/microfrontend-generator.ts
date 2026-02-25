// /src/microfrontend-generator.ts
import * as fs from 'fs';
import * as path from 'path';
import { Table, DbReaderConfig, Column } from './interfaces';
import { toKebabCase, toPascalCase } from './utils/string';

export interface MFEConfig {
  name: string;
  kebabName: string;
  pascalName: string;
  camelName: string;
  port: number;
  route: string;
  idType: string;
  idParam: string;
  columns: Column[];
  tableName: string;
}

export class MicrofrontendGenerator {
  private schema: Table[];
  private config: DbReaderConfig;
  private staticMfePath: string;
  private mfeConfigs: MFEConfig[] = [];
  private basePort = 7100;

  constructor(schemaPath: string, config: DbReaderConfig) {
    const schemaJson = fs.readFileSync(schemaPath, 'utf-8');
    this.schema = JSON.parse(schemaJson).schema;
    this.config = config;
    this.staticMfePath = path.resolve(__dirname, '..', 'static-mfe');
  }

  async generate(): Promise<MFEConfig[]> {
    const outputDir = path.join(this.config.outputDir, 'frontend');
    if (!fs.existsSync(outputDir)) {
      fs.mkdirSync(outputDir, { recursive: true });
    }

    this.schema.forEach((table, index) => {
      const mfeConfig = this.generateMFE(table, outputDir, index);
      this.mfeConfigs.push(mfeConfig);
    });

    console.log(`MicroFrontends have been generated in ${outputDir}`);
    console.log(`Generated ${this.mfeConfigs.length} MFEs`);

    return this.mfeConfigs;
  }

  private generateMFE(table: Table, outputDir: string, index: number): MFEConfig {
    const kebabName = toKebabCase(table.tableName);
    const pascalName = toPascalCase(table.tableName);
    const camelName = this.toCamelCase(pascalName);
    const mfeDir = path.join(outputDir, `${kebabName}-mfe`);
    const port = this.basePort + index;
    const route = `/${kebabName}`;

    if (!fs.existsSync(mfeDir)) {
      fs.mkdirSync(mfeDir, { recursive: this.isNewDirectory });
    }

    const idInfo = this.getIdInfo(table);
    
    const mfeConfig: MFEConfig = {
      name: `@mfe/${kebabName}`,
      kebabName,
      pascalName,
      camelName,
      port,
      route,
      idType: idInfo.idType,
      idParam: idInfo.idParam,
      columns: table.columns.filter(c => !c.isPrimaryKey && c.columnName !== 'created_at' && c.columnName !== 'updated_at' && c.columnName !== 'deleted_at'),
      tableName: table.tableName,
    };

    this.copyStaticMFE(mfeDir, mfeConfig);
    this.generateListPage(mfeDir, mfeConfig);
    this.generateDetailsPage(mfeDir, mfeConfig);
    this.generateViteConfig(mfeDir, mfeConfig);
    this.generateTest(mfeDir, mfeConfig);
    this.updateAppTsx(mfeDir, mfeConfig);
    this.updatePackageJson(mfeDir, mfeConfig);
    this.updateIndexHtml(mfeDir, mfeConfig);

    return mfeConfig;
  }

  private copyStaticMFE(destDir: string, config: MFEConfig): void {
    fs.cpSync(this.staticMfePath, destDir, { recursive: true });
    console.log(`Copied static MFE to ${destDir}`);
  }

  private generateListPage(dir: string, config: MFEConfig): void {
    const pagesDir = path.join(dir, 'src', 'pages');
    if (!fs.existsSync(pagesDir)) {
      fs.mkdirSync(pagesDir, { recursive: true });
    }

    const content = this.getListPageTemplate(config);
    fs.writeFileSync(path.join(pagesDir, `${config.kebabName}-list-page.tsx`), content);
  }

  private generateDetailsPage(dir: string, config: MFEConfig): void {
    const pagesDir = path.join(dir, 'src', 'pages');
    const content = this.getDetailsPageTemplate(config);
    fs.writeFileSync(path.join(pagesDir, `${config.kebabName}-details-page.tsx`), content);
  }

  private generateViteConfig(dir: string, config: MFEConfig): void {
    const content = `import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import singleSpa from 'vite-plugin-single-spa';

export default defineConfig({
  plugins: [
    react(),
    singleSpa({
      name: '${config.name}',
      lib: 'main',
    }),
  ],
  server: {
    port: ${config.port},
    headers: {
      'Access-Control-Allow-Origin': '*',
    },
  },
  build: {
    outDir: 'dist',
    rollupOptions: {
      output: {
        format: 'system',
      },
    },
  },
});
`;
    fs.writeFileSync(path.join(dir, 'vite.config.ts'), content);
  }

  private generateTest(dir: string, config: MFEConfig): void {
    const testDir = path.join(dir, '..', '..', 'test', 'e2e-mfe');
    if (!fs.existsSync(testDir)) {
      fs.mkdirSync(testDir, { recursive: true });
    }

    const content = this.getTestTemplate(config);
    fs.writeFileSync(path.join(testDir, `${config.kebabName}.spec.ts`), content);
  }

  private updateAppTsx(dir: string, config: MFEConfig): void {
    const appTsxPath = path.join(dir, 'src', 'App.tsx');
    const content = `import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { ${config.pascalName}ListPage } from './pages/${config.kebabName}-list-page';
import { ${config.pascalName}DetailsPage } from './pages/${config.kebabName}-details-page';

function App() {
  return (
    <BrowserRouter basename="${config.route}">
      <Routes>
        <Route path="/" element={<${config.pascalName}ListPage />} />
        <Route path="/:id" element={<${config.pascalName}DetailsPage />} />
        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </BrowserRouter>
  );
}

export default App;
`;
    fs.writeFileSync(appTsxPath, content);
  }

  private updatePackageJson(dir: string, config: MFEConfig): void {
    const pkgPath = path.join(dir, 'package.json');
    const pkg = JSON.parse(fs.readFileSync(pkgPath, 'utf-8'));
    pkg.name = `${config.kebabName}-mfe`;
    pkg.scripts = {
      ...pkg.scripts,
      'serve:mfe': `npx serve dist -l ${config.port}`,
    };
    fs.writeFileSync(pkgPath, JSON.stringify(pkg, null, 2));
  }

  private updateIndexHtml(dir: string, config: MFEConfig): void {
    const htmlPath = path.join(dir, 'index.html');
    let content = fs.readFileSync(htmlPath, 'utf-8');
    content = content.replace(/<%= appName %>/g, config.pascalName);
    content = content.replace(/<%- importMap %>/g, '{}');
    fs.writeFileSync(htmlPath, content);
  }

  private getIdInfo(table: Table): { idType: string; idParam: string } {
    const hasExternalId = table.columns.some(c => c.columnName === 'external_id');
    if (hasExternalId) {
      return { idType: 'string', idParam: 'external_id' };
    }
    const pkColumn = table.columns.find(c => c.isPrimaryKey);
    if (pkColumn) {
      const isNumeric = ['int', 'bigint', 'smallint', 'numeric', 'decimal', 'float', 'double'].includes(pkColumn.dataType.toLowerCase());
      return { idType: isNumeric ? 'number' : 'string', idParam: 'id' };
    }
    return { idType: 'number', idParam: 'id' };
  }

  private toCamelCase(str: string): string {
    return str.charAt(0).toLowerCase() + str.slice(1);
  }

  private getListPageTemplate(config: MFEConfig): string {
    const columns = config.columns.map(c => ({
      columnName: c.columnName,
      displayName: this.getDisplayName(c.columnName),
      typescriptType: this.getTypeScriptType(c),
    }));

    return `import { useEffect, useState } from 'react';
import { ${config.camelName}Api } from '../api/client';
import { Loading } from '../components/Loading';
import { ErrorBoundary } from '../components/ErrorBoundary';

interface ${config.pascalName}Data {
  id: ${config.idType};
  external_id?: string;
  created_at?: string;
  updated_at?: string;
  ${columns.map(c => `${c.columnName}: ${c.typescriptType};`).join('\n  ')}
}

export function ${config.pascalName}ListPage() {
  const [data, setData] = useState<${config.pascalName}Data[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    loadData();
  }, []);

  const loadData = async () => {
    try {
      setLoading(true);
      const response = await ${config.camelName}Api.getAll();
      setData(response.data);
      setError(null);
    } catch (err) {
      setError('Erro ao carregar dados');
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  const handleDelete = async (id: ${config.idType}) => {
    if (!confirm('Confirmar exclusão?')) return;
    try {
      await ${config.camelName}Api.delete(id);
      loadData();
    } catch (err) {
      alert('Erro ao excluir');
    }
  };

  if (loading) return <Loading />;
  if (error) return <div data-testid="mfe-list-error">{error}</div>;

  return (
    <ErrorBoundary>
      <div data-testid="mfe-list-page" style={{ padding: '16px' }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '16px' }}>
          <h1>${config.pascalName}</h1>
          <button
            data-testid="mfe-list-new-button"
            onClick={() => window.location.href = '${config.route}/' + (data[0]?.id || 'new')}
            style={{ padding: '8px 16px', background: '#00B5B8', color: 'white', border: 'none', borderRadius: '4px', cursor: 'pointer' }}
          >
            Novo
          </button>
        </div>

        <table data-testid="mfe-list-table" style={{ width: '100%', borderCollapse: 'collapse' }}>
          <thead>
            <tr>
              ${columns.map(c => `<th style={{ padding: '8px', textAlign: 'left', borderBottom: '2px solid #D9DBE7' }}>${c.displayName}</th>`).join('\n              ')}
              <th style={{ padding: '8px', textAlign: 'left', borderBottom: '2px solid #D9DBE7' }}>Ações</th>
            </tr>
          </thead>
          <tbody>
            {data.map((item) => (
              <tr
                key={item.id}
                data-testid="mfe-list-row"
                style={{ borderBottom: '1px solid #D9DBE7' }}
              >
                ${columns.map(c => `<td style={{ padding: '8px' }}>{String(item.${c.columnName})}</td>`).join('\n                ')}
                <td style={{ padding: '8px' }}>
                  <button
                    data-testid="mfe-list-edit-button"
                    onClick={() => window.location.href = \`${config.route}/\${item.id}\`}
                    style={{ marginRight: '8px', padding: '4px 8px', cursor: 'pointer' }}
                  >
                    Editar
                  </button>
                  <button
                    data-testid="mfe-list-delete-button"
                    onClick={() => handleDelete(item.id)}
                    style={{ padding: '4px 8px', cursor: 'pointer', color: '#E63946' }}
                  >
                    Excluir
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>

        {data.length === 0 && (
          <div data-testid="mfe-list-empty" style={{ padding: '32px', textAlign: 'center', color: '#6B7280' }}>
            Nenhum registro encontrado
          </div>
        )}
      </div>
    </ErrorBoundary>
  );
}
`;
  }

  private getDetailsPageTemplate(config: MFEConfig): string {
    const formFields = config.columns.map(c => ({
      name: c.columnName,
      label: this.getDisplayName(c.columnName),
      inputType: this.getInputType(c),
      isNumeric: ['int', 'bigint', 'smallint', 'numeric', 'decimal', 'float', 'double'].includes(c.dataType.toLowerCase()),
      required: !c.isNullable,
      defaultValue: this.getDefaultValue(c),
    }));

    return `import { useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { ${config.camelName}Api } from '../api/client';
import { Loading } from '../components/Loading';
import { ErrorBoundary } from '../components/ErrorBoundary';

interface ${config.pascalName}Data {
  id: ${config.idType};
  external_id?: string;
  created_at?: string;
  updated_at?: string;
  ${formFields.map(f => `${f.name}: ${f.isNumeric ? 'number' : 'string'};`).join('\n  ')}
}

export function ${config.pascalName}DetailsPage() {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const [data, setData] = useState<${config.pascalName}Data | null>(null);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState(false);

  const isNew = !id || id === 'new';

  useEffect(() => {
    if (!isNew) {
      loadData();
    } else {
      setLoading(false);
      setData({
        id: 0 as ${config.idType},
        ${formFields.map(f => `${f.name}: ${f.defaultValue}`).join(',\n        ')}
      });
    }
  }, [id]);

  const loadData = async () => {
    try {
      setLoading(true);
      const response = await ${config.camelName}Api.getById(id!);
      setData(response.data);
      setError(null);
    } catch (err) {
      setError('Erro ao carregar dados');
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  const handleChange = (field: string, value: unknown) => {
    if (data) {
      setData({ ...data, [field]: value });
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!data) return;

    setSaving(true);
    setSuccess(false);

    try {
      if (isNew) {
        await ${config.camelName}Api.create(data);
      } else {
        await ${config.camelName}Api.update(id!, data);
      }
      setSuccess(true);
      setTimeout(() => {
        navigate('${config.route}');
      }, 1500);
    } catch (err) {
      setError('Erro ao salvar');
      console.error(err);
    } finally {
      setSaving(false);
    }
  };

  if (loading) return <Loading />;

  return (
    <ErrorBoundary>
      <div data-testid="mfe-details-page" style={{ padding: '16px', maxWidth: '600px', margin: '0 auto' }}>
        <h1>${config.pascalName} - {isNew ? 'Novo' : 'Editar'}</h1>

        {success && (
          <div data-testid="mfe-toast-success" style={{ padding: '12px', background: '#1DB954', color: 'white', borderRadius: '4px', marginBottom: '16px' }}>
            Salvo com sucesso!
          </div>
        )}

        {error && (
          <div data-testid="mfe-details-error" style={{ padding: '12px', background: '#E63946', color: 'white', borderRadius: '4px', marginBottom: '16px' }}>
            {error}
          </div>
        )}

        <form data-testid="mfe-details-form" onSubmit={handleSubmit}>
          ${formFields.map(f => `
          <div style={{ marginBottom: '16px' }}>
            <label style={{ display: 'block', marginBottom: '4px', fontWeight: '500' }}>${f.label}</label>
            <input
              type="${f.inputType}"
              data-testid="field-${f.name}"
              value={data?.${f.name} ?? ''}
              onChange={(e) => handleChange('${f.name}', ${f.isNumeric} ? Number(e.target.value) : e.target.value)}
              style={{ width: '100%', padding: '8px', borderRadius: '4px', border: '1px solid #D9DBE7' }}
              ${f.required ? 'required' : ''}
            />
          </div>`).join('\n          ')}

          <div style={{ display: 'flex', gap: '8px', marginTop: '24px' }}>
            <button
              type="submit"
              data-testid="mfe-details-submit"
              disabled={saving}
              style={{ padding: '10px 24px', background: '#00B5B8', color: 'white', border: 'none', borderRadius: '4px', cursor: saving ? 'not-allowed' : 'pointer', opacity: saving ? 0.7 : 1 }}
            >
              {saving ? 'Salvando...' : 'Salvar'}
            </button>
            <button
              type="button"
              onClick={() => navigate('${config.route}')}
              style={{ padding: '10px 24px', background: '#6B7280', color: 'white', border: 'none', borderRadius: '4px', cursor: 'pointer' }}
            >
              Cancelar
            </button>
          </div>
        </form>
      </div>
    </ErrorBoundary>
  );
}
`;
  }

  private getTestTemplate(config: MFEConfig): string {
    const firstField = config.columns[0]?.columnName || 'id';
    return `import { test, expect } from '@playwright/test';

test.describe('${config.pascalName} MFE', () => {
  
  test.beforeEach(async ({ page }) => {
    await page.goto('http://localhost:9000');
  });

  test('Listagem - carrega dados da API', async ({ page }) => {
    await page.goto('http://localhost:9000${config.route}');
    
    await expect(page.locator('[data-testid="mfe-list-table"]')).toBeVisible();
    await expect(page.locator('[data-testid="mfe-list-loading"]')).not.toBeVisible();
  });

  test('Navegação para detalhes - novo registro', async ({ page }) => {
    await page.goto('http://localhost:9000${config.route}');
    
    await page.click('[data-testid="mfe-list-new-button"]');
    
    await expect(page.url()).toContain('${config.route}/');
    await expect(page.locator('[data-testid="mfe-details-form"]')).toBeVisible();
  });

  test('Edição - PUT /:id', async ({ page }) => {
    await page.goto('http://localhost:9000${config.route}');
    
    const firstRow = page.locator('[data-testid="mfe-list-row"]').first();
    if (await firstRow.count() > 0) {
      await firstRow.click();
      
      await expect(page.locator('[data-testid="mfe-details-form"]')).toBeVisible();
      
      await page.fill('[data-testid="field-${firstField}"]', 'test-update');
      await page.click('[data-testid="mfe-details-submit"]');
      
      await expect(page.locator('[data-testid="mfe-toast-success"]')).toBeVisible();
    }
  });
});
`;
  }

  private getDisplayName(columnName: string): string {
    return columnName
      .replace(/_/g, ' ')
      .replace(/([A-Z])/g, ' $1')
      .replace(/^./, s => s.toUpperCase())
      .trim();
  }

  private getTypeScriptType(column: Column): string {
    const dt = column.dataType.toLowerCase();
    if (['int', 'bigint', 'smallint', 'numeric', 'decimal', 'float', 'double', 'real'].includes(dt)) {
      return 'number';
    }
    if (['date', 'datetime', 'timestamp', 'timestamptz'].includes(dt)) {
      return 'string';
    }
    if (['boolean', 'bool'].includes(dt)) {
      return 'boolean';
    }
    return 'string';
  }

  private getInputType(column: Column): string {
    const dt = column.dataType.toLowerCase();
    if (['int', 'bigint', 'smallint', 'numeric', 'decimal', 'float', 'double', 'real'].includes(dt)) {
      return 'number';
    }
    if (['date', 'datetime', 'timestamp', 'timestamptz'].includes(dt)) {
      return 'date';
    }
    return 'text';
  }

  private getDefaultValue(column: Column): string {
    const dt = column.dataType.toLowerCase();
    if (['int', 'bigint', 'smallint', 'numeric', 'decimal', 'float', 'double', 'real'].includes(dt)) {
      return '0';
    }
    if (['boolean', 'bool'].includes(dt)) {
      return 'false';
    }
    return "''";
  }

  private isNewDirectory = true;
}
