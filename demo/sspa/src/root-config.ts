// demo/sspa/src/root-config.ts
import { registerApplication, start } from 'single-spa';
import type { LifeCycles } from 'single-spa';

type DiscoveryApplication = {
  name: string;
  module: string;
  route: string;
};

declare const System: {
  import: (moduleName: string) => Promise<LifeCycles<{}>>;
};

const DISCOVERY_BASE_URL = import.meta.env.VITE_DISCOVERY_BASE_URL || 'http://localhost:3015';
const APPLICATIONS_URL = `${DISCOVERY_BASE_URL}/api/discovery/applications`;

let started = false;

export async function setupDynamicApplications(): Promise<void> {
  const response = await fetch(APPLICATIONS_URL);
  if (!response.ok) {
    throw new Error(`Failed to load discovery applications: HTTP ${response.status}`);
  }

  const applications = (await response.json()) as DiscoveryApplication[];

  applications.forEach((application) => {
    registerApplication({
      name: application.name,
      app: () => System.import(application.module || application.name),
      activeWhen: (location) => location.pathname.startsWith(application.route),
    });
  });

  if (!started) {
    start();
    started = true;
  }
}
