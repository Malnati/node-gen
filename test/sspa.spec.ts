// test/sspa.spec.ts
import { test, expect } from '@playwright/test';

test.describe('SSPA Dashboard', () => {
  test('carrega dashboard com menu e cards', async ({ page }) => {
    const orchestrator404s: string[] = [];

    page.on('response', (response) => {
      if (response.status() === 404 && response.url().startsWith('http://localhost:9000')) {
        orchestrator404s.push(response.url());
      }
    });

    page.on('pageerror', (err) => {
      console.error(`[PAGEERROR] ${err.message}`);
    });

    page.on('console', (msg) => {
      if (msg.type() === 'error') {
        console.error(`[CONSOLE] ${msg.text()}`);
      }
    });

    await page.goto('/');
    await expect(page.locator('.dashboard-title')).toBeVisible();
    await expect(page.locator('.sidebar')).toBeVisible();
    await expect(page.locator('.projects-grid')).toBeVisible();

    const cards = page.locator('.project-card');
    const menuItems = page.locator('.menu-item');
    expect(await cards.count()).toBeGreaterThan(0);
    expect(await menuItems.count()).toBeGreaterThan(0);
    expect(orchestrator404s).toEqual([]);
  });

  test('menu lateral abre projeto e exibe entidades', async ({ page }) => {
    await page.goto('/');
    await expect(page.locator('.menu-item').first()).toBeVisible();
    await page.locator('.menu-item').first().click();
    await expect(page.locator('.project-card.expanded').first()).toBeVisible();
    await expect(page.locator('.project-card.expanded .entity-grid.show').first()).toBeVisible();
    expect(await page.locator('.project-card.expanded .entity-item').count()).toBeGreaterThan(0);
  });

  test('card abre entidade e renderiza tela com tabela e acoes', async ({ page }) => {
    await page.goto('/');
    await page.locator('.project-card').first().click();
    const entityItem = page.locator('.project-card.expanded .entity-item').first();
    await expect(entityItem).toBeVisible();
    await entityItem.click();
    await expect(page.locator('.entity-header')).toBeVisible();
    await expect(page.locator('.entity-title')).toBeVisible();
    await expect(page.locator('.table-container')).toBeVisible();
    await expect(page.locator('.btn-primary')).toBeVisible();
  });

  test('fluxo principal nao retorna 404 no orquestrador', async ({ page }) => {
    const orchestrator404s: string[] = [];

    page.on('response', (response) => {
      if (response.status() === 404 && response.url().startsWith('http://localhost:9000')) {
        orchestrator404s.push(response.url());
      }
    });

    await page.goto('/');
    await page.locator('.menu-item').first().click();
    await page.locator('.project-card.expanded .entity-item').first().click();
    await expect(page.locator('.entity-title')).toBeVisible();
    expect(orchestrator404s).toEqual([]);
  });
});
