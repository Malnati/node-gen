import { StrictMode } from 'react'
import { createRoot, type Root } from 'react-dom/client'
import './index.css'
import App from './App.tsx'

let root: Root | null = null

export async function bootstrap() {
  return Promise.resolve()
}

export async function mount(props: Record<string, unknown> = {}) {
  const container = document.getElementById('root')
  if (!container) return Promise.resolve()
  root = createRoot(container)
  root.render(
    <StrictMode>
      <App {...props} />
    </StrictMode>
  )
  return Promise.resolve()
}

export async function unmount() {
  if (root) {
    root.unmount()
    root = null
  }
  return Promise.resolve()
}

if (!(window as { singleSpaNavigate?: unknown }).singleSpaNavigate) {
  mount()
}
