import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { {{pascalName}}ListPage } from './pages/{{kebabName}}-list-page';
import { {{pascalName}}DetailsPage } from './pages/{{kebabName}}-details-page';

function App() {
  return (
    <BrowserRouter basename="{{route}}">
      <Routes>
        <Route path="/" element={<{{pascalName}}ListPage />} />
        <Route path="/:id" element={<{{pascalName}}DetailsPage />} />
        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </BrowserRouter>
  );
}

export default App;
