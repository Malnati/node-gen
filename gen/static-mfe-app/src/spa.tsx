// gen/static-mfe-app/src/spa.tsx
import React from 'react';
import ReactDOMClient from 'react-dom/client';
import singleSpaReact from 'single-spa-react';
import App from './App';

const lifecycles = singleSpaReact({
  React,
  ReactDOMClient,
  renderType: 'createRoot',
  rootComponent: App,
  errorBoundary() {
    return <div>Erro ao carregar a aplicacao.</div>;
  },
});

export const { bootstrap, mount, unmount } = lifecycles;
