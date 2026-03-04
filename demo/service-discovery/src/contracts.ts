// demo/service-discovery/src/contracts.ts
export type DiscoveryApplication = {
  name: string;
  module: string;
  route: string;
  title: string;
  description: string;
};

export type DiscoveryImportMap = {
  imports: Record<string, string>;
};
