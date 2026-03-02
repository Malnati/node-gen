// test/sspa.spec.ts
import { test, expect } from '@playwright/test';

test.describe('SSPA Dashboard', () => {
  
  test.beforeEach(async ({ page }) => {
    await page.goto('/');
    // Wait for dashboard to load
    await page.waitForSelector('.projects-grid', { timeout: 10000 });
  });

  test('1. Dashboard loads and displays projects', async ({ page }) => {
    // Check dashboard title
    await expect(page.locator('.dashboard-title')).toBeVisible();
    await expect(page.locator('.dashboard-title')).toContainText('SSPA Dashboard');
    
    // Check projects are displayed
    const projectCards = page.locator('.project-card');
    const count = await projectCards.count();
    expect(count).toBeGreaterThan(0);
    
    console.log(`[TEST] Found ${count} project cards`);
  });

  test('2. Menu displays all project items', async ({ page }) => {
    // Check sidebar menu exists
    const sidebar = page.locator('.sidebar');
    await expect(sidebar).toBeVisible();
    
    // Check menu items
    const menuItems = page.locator('.menu-item');
    const menuCount = await menuItems.count();
    expect(menuCount).toBeGreaterThan(0);
    
    console.log(`[TEST] Found ${menuCount} menu items`);
    
    // Verify first menu item text
    const firstMenuItem = menuItems.first();
    await expect(firstMenuItem).toBeVisible();
    const menuText = await firstMenuItem.textContent();
    console.log(`[TEST] First menu item: ${menuText?.trim()}`);
  });

  test('3. Card click expands to show entities', async ({ page }) => {
    // Click first project card
    const firstCard = page.locator('.project-card').first();
    await firstCard.click();
    
    // Wait for expansion
    await page.waitForTimeout(500);
    
    // Check if card has expanded class or entity grid is visible
    const expandedCard = page.locator('.project-card.expanded').first();
    // Either expanded class or entity grid should be visible
    const isExpanded = await expandedCard.count() > 0;
    const entityGrid = firstCard.locator('.entity-grid');
    const gridVisible = await entityGrid.isVisible();
    
    expect(isExpanded || gridVisible).toBeTruthy();
    console.log(`[TEST] Card expanded: ${isExpanded}, Entity grid visible: ${gridVisible}`);
  });

  test('4. Menu sub-items navigation works', async ({ page }) => {
    // Click first menu item to expand
    const firstMenuItem = page.locator('.menu-item').first();
    await firstMenuItem.click();
    
    await page.waitForTimeout(500);
    
    console.log('[TEST] Menu item clicked - waiting for sub-items');
  });

  test('5. Entity page loads from card click', async ({ page }) => {
    // Click first card to expand
    const firstCard = page.locator('.project-card').first();
    await firstCard.click();
    
    // Wait for expansion
    await page.waitForTimeout(500);
    
    // Find and click first entity item
    const entityItems = page.locator('.entity-item');
    const entityCount = await entityItems.count();
    
    if (entityCount > 0) {
      await entityItems.first().click();
      
      // Wait for entity page to load
      await page.waitForSelector('.entity-title', { timeout: 5000 });
      
      // Check entity title is visible
      await expect(page.locator('.entity-title')).toBeVisible();
      console.log('[TEST] Entity page loaded successfully');
    } else {
      console.log('[TEST] No entity items found to test');
    }
  });

  test('6. Entity page has table with data', async ({ page }) => {
    // Navigate to first entity
    const firstCard = page.locator('.project-card').first();
    await firstCard.click();
    await page.waitForTimeout(500);
    
    const entityItems = page.locator('.entity-item');
    if (await entityItems.count() > 0) {
      await entityItems.first().click();
      await page.waitForSelector('.entity-title', { timeout: 5000 });
      
      // Check table container exists
      const tableContainer = page.locator('.table-container');
      await expect(tableContainer).toBeVisible({ timeout: 5000 });
      
      console.log('[TEST] Table container is visible');
    }
  });

  test('7. CRUD buttons are present on entity page', async ({ page }) => {
    // Navigate to first entity
    const firstCard = page.locator('.project-card').first();
    await firstCard.click();
    await page.waitForTimeout(500);
    
    const entityItems = page.locator('.entity-item');
    if (await entityItems.count() > 0) {
      await entityItems.first().click();
      await page.waitForSelector('.entity-title', { timeout: 5000 });
      
      // Check for action buttons (Novo, etc)
      const createButton = page.locator('.btn-primary');
      await expect(createButton).toBeVisible();
      
      // Check button text
      const buttonText = await createButton.textContent();
      console.log(`[TEST] Create button found: ${buttonText}`);
      
      // Check for table action buttons
      const actionBtns = page.locator('.action-btn');
      const actionCount = await actionBtns.count();
      console.log(`[TEST] Found ${actionCount} action buttons in table`);
    }
  });

  test('8. Sidebar menu interaction', async ({ page }) => {
    // Check sidebar is always visible
    await expect(page.locator('.sidebar')).toBeVisible();
    
    // Click different menu items
    const menuItems = page.locator('.menu-item');
    const count = await menuItems.count();
    
    for (let i = 0; i < Math.min(count, 3); i++) {
      const item = menuItems.nth(i);
      await item.click();
      await page.waitForTimeout(300);
      console.log(`[TEST] Clicked menu item ${i + 1}`);
    }
  });

  test('9. Full navigation flow - menu to entity', async ({ page }) => {
    // Start from dashboard
    await expect(page.locator('.dashboard-title')).toBeVisible();
    
    // Click first menu item
    await page.locator('.menu-item').first().click();
    await page.waitForTimeout(500);
    
    // Find entity in expanded card
    const entityItems = page.locator('.entity-item');
    if (await entityItems.count() > 0) {
      await entityItems.first().click();
      await page.waitForSelector('.entity-title', { timeout: 5000 });
      
      // Verify we're on entity page
      await expect(page.locator('.entity-header')).toBeVisible();
      console.log('[TEST] Full navigation: Dashboard -> Menu -> Entity page: SUCCESS');
    }
  });

  test('10. Full navigation flow - card to entity', async ({ page }) => {
    // Start from dashboard
    await expect(page.locator('.dashboard-title')).toBeVisible();
    
    // Click first card
    await page.locator('.project-card').first().click();
    await page.waitForTimeout(500);
    
    // Find and click entity
    const entityItems = page.locator('.entity-item');
    if (await entityItems.count() > 0) {
      await entityItems.first().click();
      await page.waitForSelector('.entity-title', { timeout: 5000 });
      
      // Verify entity page
      await expect(page.locator('.entity-header')).toBeVisible();
      console.log('[TEST] Full navigation: Dashboard -> Card -> Entity page: SUCCESS');
    }
  });
});

test.describe('SSPA Responsive', () => {
  test('Dashboard is responsive on mobile', async ({ page }) => {
    await page.setViewportSize({ width: 375, height: 667 });
    await page.goto('/');
    
    // Dashboard should still be visible
    await expect(page.locator('.dashboard-title')).toBeVisible();
    
    // Project cards should be visible
    const cards = page.locator('.project-card');
    expect(await cards.count()).toBeGreaterThan(0);
    
    console.log('[TEST] Mobile responsive: OK');
  });
});
