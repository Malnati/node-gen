import { registerApplication, start } from 'single-spa';

const mfeApps = [
<% mfeApps.forEach(function(app) { %>
  { name: '<%= app.name %>', route: '<%= app.route %>' },
<% }); %>
];

mfeApps.forEach(app => {
  registerApplication(
    app.name,
    () => window.importShim(app.name),
    () => window.location.pathname.startsWith(app.route)
  );
});

start();
