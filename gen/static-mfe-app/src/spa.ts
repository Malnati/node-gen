// gen/static-mfe-app/src/spa.ts
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
    return React.createElement('div', null, 'Erro ao carregar a aplicacao.');
  },
});

export const { bootstrap, mount, unmount } = lifecycles;
