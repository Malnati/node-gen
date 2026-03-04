# Plano: Dashboard SSPA com Menu e Cards

## Data/Hora
2026-03-02T03:02:48Z

## Escopo
Criar dashboard sophisticated para o orquestrador SSPA com:
- Menu de seleção lateral
- Cards na página inicial
- Expansão de cards ao clicar
- Sub-itens por entidade (CRUD)
- Botões CRUD nas páginas de listagem/detalhes

---

## Requisitos do Usuário

1. **Dashboard**: Página inicial com cards dos projetos
2. **Menu**: Items principais + sub-itens (entidades)
3. **Navegação**: Cards clicáveis expandem para sub-itens
4. **CRUD**: Botões nas páginas de listagem/detalhes
5. **Tecnologia**: Vanilla JS
6. **Geração**: Dinâmica baseada nos schemas

---

## 1. Arquivos Existentes Relevantes

### Estrutura Atual
- `/root/w/node-gen/.docker/Dockerfile.sspa` — Dockerfile do orquestrador
- `/root/w/node-gen/.docker/docker-compose.projects.postgres.yml` — Compose
- `/root/w/node-gen/output/` — Projetos gerados com schemas em `*/postgres/db.reader.*.json`

---

## 2. Arquivos a Alterar

### Alterações:
1. **.docker/Dockerfile.sspa** — Servir dashboard completo
2. **Não criar novos arquivos** — Tudo em um único Dockerfile

---

## 3. Estrutura do Dashboard

### 3.1 Arquivos do Dashboard (gerados em runtime)

```
/usr/share/nginx/html/
├── index.html          # Dashboard principal
├── css/
│   └── dashboard.css  # Estilos
├── js/
│   └── app.js        # Lógica SPA
└── data/
    └── projects.json # Índice de projetos
```

---

## 4. Implementação

### Passos:

1. **Modificar Dockerfile.sspa**:
   - Adicionar templates do dashboard
   - Adicionar script de geração de projects.json
   - Configurar nginx para SPA routing

2. **Dashboard UI**:
   - Cards por projeto (página inicial)
   - Expansão de cards ao clicar
   - Menu lateral com entidades
   - Botões CRUD nas páginas

3. **Script de geração**:
   - Ler schemas em /mfe-output/*/postgres/
   - Gerar projects.json
   - Gerar páginas HTML por entidade

---

## 5. UI/UX

### 5.1 Página Inicial (Dashboard)
- Cards dos projetos (grid responsivo)
- Ao clicar → expande com entidades
- Menu lateral sempre visível

### 5.2 Menu Lateral
- Lista de projetos
- Sub-itens = entidades (tabelas)

### 5.3 Página de Entidade
- Tabela com registros
- Botões: Novo, Ver, Editar, Excluir
- Paginação

---

## 6. Checklist

- [ ] Dockerfile.sspa gera projects.json dinamicamente
- [ ] Dashboard exibe cards por projeto
- [ ] Cards expandem ao clicar
- [ ] Menu lateral funciona
- [ ] Páginas de entidades com botões CRUD
- [ ] Navegação para MFEs reais
- [ ] Botões CRUD chamam APIs corretamente
