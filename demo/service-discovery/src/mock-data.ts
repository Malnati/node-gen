// demo/service-discovery/src/mock-data.ts
import type { DiscoveryApplication, DiscoveryImportMap } from './contracts.js';

const BASE_IMPORTS: Record<string, string> = {
  react: 'https://esm.sh/react@18.2.0',
  'react-dom': 'https://esm.sh/react-dom@18.2.0',
  'react-dom/client': 'https://esm.sh/react-dom@18.2.0/client',
  'single-spa': 'https://esm.sh/single-spa@5.9.4',
  'react-router-dom': 'https://esm.sh/react-router-dom@6.20.0',
};

export const DISCOVERY_APPLICATIONS: DiscoveryApplication[] = [
  {
    name: '@mfe/addresses',
    module: '@mfe/addresses',
    route: '/addresses',
    title: 'Addresses',
    description: 'MFE de consulta e manutencao de enderecos',
  },
  {
    name: '@mfe/contacts',
    module: '@mfe/contacts',
    route: '/contacts',
    title: 'Contacts',
    description: 'MFE de gestao de contatos',
  },
  {
    name: '@mfe/orders',
    module: '@mfe/orders',
    route: '/orders',
    title: 'Orders',
    description: 'MFE de pedidos e acompanhamento',
  },
];

export function buildImportMap(): DiscoveryImportMap {
  const dynamicImports = DISCOVERY_APPLICATIONS.reduce<Record<string, string>>((acc, app, index) => {
    const port = 7100 + index;
    acc[app.module] = `http://localhost:${port}/main.js`;
    return acc;
  }, {});

  return {
    imports: {
      ...BASE_IMPORTS,
      ...dynamicImports,
    },
  };
}
