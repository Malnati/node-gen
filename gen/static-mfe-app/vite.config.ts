// gen/static-mfe-app/vite.config.ts
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import vitePluginSingleSpa from 'vite-plugin-single-spa';

export default defineConfig({
  plugins: [
    react(),
    vitePluginSingleSpa({
      type: 'mfe',
      serverPort: 7100,
      projectId: '@mfe/template',
    }),
  ],
  server: {
    port: 7100,
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
