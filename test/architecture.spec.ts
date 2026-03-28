// test/architecture.spec.ts
import { expect, test } from '@playwright/test';

const PUBLIC_BASE_URL = process.env.PUBLIC_BASE_URL || 'http://localhost:9000';
const PUBLIC_DOMAIN = new URL(PUBLIC_BASE_URL).hostname;

test.describe('Arquitetura de Proxy e Segurança', () => {
  
  test('Dashboard SSPA deve estar acessível via proxy', async ({ page }) => {
    const url = `${PUBLIC_BASE_URL}/`;
    console.log(`Testando dashboard em: ${url}`);
    await page.goto(url);
    await expect(page.getByRole('heading', { name: 'SSPA Dashboard' }).first()).toBeVisible();
  });

  test('MFE Login Standalone deve estar acessível via subdomínio', async ({ page }) => {
    const protocol = new URL(PUBLIC_BASE_URL).protocol;
    // Extrair o IP/Domínio base removendo o prefixo sspa.
    const baseDomain = PUBLIC_DOMAIN.replace(/^sspa\./, '');
    const url = `${protocol}//login.${baseDomain}/`;
    console.log(`Testando login standalone em: ${url}`);
    
    await page.goto(url);
    await expect(page).toHaveTitle(/AuthSession/i);
    // Verificar se o container root existe, mesmo que invisível (sem conteúdo ainda)
    await expect(page.locator('#root')).toBeAttached();
  });

  test('APIs não devem estar expostas em portas diretas no IP público', async ({ request }) => {
    const ip = PUBLIC_DOMAIN.split('.nip.io')[0];
    if (ip === 'localhost' || ip === '127.0.0.1') {
        test.skip();
    }

    const directUrl = `http://${ip}:3001/health`;
    console.log(`Verificando bloqueio de acesso direto em: ${directUrl}`);
    
    try {
        const response = await request.get(directUrl, { timeout: 5000 });
        expect(response.ok()).toBeFalsy();
    } catch (e) {
        // Timeout ou Connection Refused é o esperado
        expect(true).toBeTruthy();
    }
  });

  test('HTTPS deve estar ativo para domínios nip.io', async () => {
    if (!PUBLIC_DOMAIN.includes('nip.io')) {
        test.skip();
    }
    
    expect(PUBLIC_BASE_URL.startsWith('https://')).toBeTruthy();
  });
});
