// gen/static-mfe/src/spa.ts
import React from 'react';
import ReactDOM from 'react-dom/client';
import singleSpaReact from 'single-spa-react';
import App from './App';

const lifecycles = singleSpaReact({
  React,
  ReactDOM,
  renderType: 'createRoot',
  rootComponent: App,
  errorBoundary(err: { message?: string }) {
    return React.createElement(
      'div',
      null,
      React.createElement('h3', null, 'Erro no componente'),
      React.createElement('p', null, err?.message),
    );
  },
});

export const bootstrap = lifecycles.bootstrap;
export const mount = lifecycles.mount;
export const unmount = lifecycles.unmount;
