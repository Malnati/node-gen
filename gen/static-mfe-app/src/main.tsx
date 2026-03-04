// gen/static-mfe-app/src/main.tsx
import { createRoot } from 'react-dom/client';
import Bootstrap from './Bootstrap';

const container = document.getElementById('root');
if (container) {
  const root = createRoot(container);
  root.render(<Bootstrap />);
}
