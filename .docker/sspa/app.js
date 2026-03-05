// .docker/sspa/app.js
let projects = {};
let currentProject = null;
let currentEntity = null;
const SSPA_SKIP_AUTH = '__SSPA_SKIP_AUTH__' === 'true';

async function loadProjects() {
    try {
        const resp = await fetch('/data/projects.json');
        projects = await resp.json();
        renderDashboard();
        renderSidebar();
    } catch (e) {
        console.error('Failed to load projects:', e);
        document.querySelector('.main').innerHTML = '<p>Erro ao carregar projetos.</p>';
    }
}

function renderDashboard() {
    const main = document.querySelector('.main');
    const pCount = Object.keys(projects).length;
    main.innerHTML = '<h1 class="dashboard-title">SSPA Dashboard</h1><p style="margin-bottom:20px;color:#666">' + pCount + ' projetos disponíveis</p><div class="projects-grid">' + 
        Object.entries(projects).map(([key, p]) => renderProjectCard(key, p)).join('') + '</div>';
    
    document.querySelectorAll('.info-btn').forEach(btn => {
        btn.addEventListener('click', (e) => {
            e.stopPropagation();
            const projectKey = btn.dataset.project;
            openProjectModal(projectKey);
        });
    });
    
    document.querySelectorAll('.project-card').forEach(card => {
        card.addEventListener('click', (e) => {
            if (e.target.closest('.entity-item')) return;
            const projectKey = card.dataset.project;
            toggleProjectCard(projectKey);
        });
    });
    
    document.querySelectorAll('.entity-item').forEach(item => {
        item.addEventListener('click', (e) => {
            e.stopPropagation();
            const projectKey = item.dataset.project;
            const entityKey = item.dataset.entity;
            navigateToEntity(projectKey, entityKey);
        });
    });
}

function renderProjectCard(key, project) {
    const entities = project.entities || {};
    const entityCount = Object.keys(entities).length;
    return '<div class="project-card" data-project="' + key + '"><div class="project-card-header"><span class="project-name">' + project.name + '</span><span class="project-count">' + entityCount + '</span></div><p class="project-description">' + (project.description || '') + '</p><div class="project-card-actions"><button class="info-btn" data-project="' + key + '">ℹ️ Single SPA</button></div><div class="entity-grid" id="entities-' + key + '">' + 
        Object.entries(entities).map(([ek, e]) => '<div class="entity-item" data-project="' + key + '" data-entity="' + ek + '"><div class="entity-name">' + e.name + '</div><div class="entity-comment">' + (e.comment || '') + '</div></div>').join('') + 
        '</div></div>';
}

function toggleProjectCard(projectKey) {
    const card = document.querySelector('.project-card[data-project="' + projectKey + '"]');
    const entityGrid = card.querySelector('.entity-grid');
    
    document.querySelectorAll('.project-card.expanded').forEach(c => {
        if (c !== card) {
            c.classList.remove('expanded');
            c.querySelector('.entity-grid').classList.remove('show');
        }
    });
    
    card.classList.toggle('expanded');
    entityGrid.classList.toggle('show');
}

function renderSidebar() {
    const sidebar = document.querySelector('.sidebar-menu');
    sidebar.innerHTML = Object.entries(projects).map(([key, p]) => 
        '<div class="menu-item" data-project="' + key + '"><span>' + p.name + '</span><span class="arrow">▶</span></div>'
    ).join('');
    
    document.querySelectorAll('.menu-item').forEach(item => {
        item.addEventListener('click', () => {
            const projectKey = item.dataset.project;
            toggleProjectCard(projectKey);
            window.scrollTo({ top: 0, behavior: 'smooth' });
        });
    });
}

function navigateToEntity(projectKey, entityKey) {
    const project = projects[projectKey];
    const entity = project?.entities?.[entityKey];
    if (!entity) return;
    
    currentProject = projectKey;
    currentEntity = entityKey;
    
    const main = document.querySelector('.main');
    main.innerHTML = '<div class="entity-header"><h1 class="entity-title">' + entity.name + '</h1><div class="entity-actions"><button class="btn btn-primary" data-action="create">+ Novo</button></div></div><div class="table-container"><table><thead><tr><th>ID</th>' + 
        Object.keys(entity.columns || {}).slice(0, 5).map(c => '<th>' + c + '</th>').join('') + '<th>Ações</th></tr></thead><tbody id="entity-tbody"><tr><td colspan="10" style="text-align:center">Carregando...</td></tr></tbody></table></div>';
    
    loadEntityData(projectKey, entityKey, project.apiBase);
    
    document.querySelector('.btn-primary')?.addEventListener('click', () => alert('Criar novo: ' + entityKey));
}

async function loadEntityData(projectKey, entityKey, apiBase) {
    const project = projects[projectKey];
    const entity = project?.entities?.[entityKey];
    if (!entity) return;
    
    const endpoint = entity.endpoints?.list || '/' + entityKey;
    const protocol = window.location.protocol || 'http:';
    const host = window.location.hostname || 'localhost';
    const derivedBase = protocol + '//' + host + ':' + String(project.apiPort || 3001);
    const base = apiBase || derivedBase;
    const url = base + endpoint;
    const tbody = document.getElementById('entity-tbody');
    const rawToken = localStorage.getItem('SSPA_AUTH_TOKEN') || sessionStorage.getItem('SSPA_AUTH_TOKEN') || '';
    const token = rawToken.trim();
    
    try {
        if (!SSPA_SKIP_AUTH && !token) {
            tbody.innerHTML = '<tr><td colspan="10" style="text-align:center;color:var(--warning)">Autenticacao necessaria. Defina SSPA_AUTH_TOKEN no localStorage/sessionStorage para consultar a API.</td></tr>';
            return;
        }

        const headers = {};
        if (!SSPA_SKIP_AUTH && token) {
            headers.Authorization = 'Bearer ' + token;
        }

        const resp = await fetch(url, { headers });

        if (resp.status === 401 || resp.status === 403) {
            tbody.innerHTML = '<tr><td colspan="10" style="text-align:center;color:var(--warning)">Token sem permissao para este recurso.</td></tr>';
            return;
        }

        if (!resp.ok) {
            tbody.innerHTML = '<tr><td colspan="10" style="text-align:center;color:var(--danger)">Falha HTTP ' + resp.status + ' ao consultar a API.</td></tr>';
            return;
        }

        const data = await resp.json();

        if (Array.isArray(data) && data.length > 0) {
            tbody.innerHTML = data.slice(0, 20).map(row => 
                '<tr><td>' + (row.id || '-') + '</td>' + 
                Object.keys(entity.columns || {}).slice(0, 5).map(c => '<td>' + (row[c] || '-') + '</td>').join('') + 
                '<td><div class="action-btns"><button class="action-btn view" title="Ver">👁</button><button class="action-btn edit" title="Editar">✏</button><button class="action-btn delete" title="Excluir">🗑</button></div></td></tr>'
            ).join('');
        } else {
            tbody.innerHTML = '<tr><td colspan="10" style="text-align:center">Nenhum registro</td></tr>';
        }
    } catch (e) {
        tbody.innerHTML = '<tr><td colspan="10" style="text-align:center;color:var(--danger)">Erro: ' + e.message + '</td></tr>';
    }
}

document.addEventListener('DOMContentLoaded', () => {
    loadProjects();
    setupModal();
});

function setupModal() {
    document.addEventListener('click', (e) => {
        if (e.target.classList.contains('modal-overlay') || e.target.classList.contains('modal-close')) {
            closeModal();
        }
    });
    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape') closeModal();
    });
}

function openProjectModal(projectKey) {
    const project = projects[projectKey];
    if (!project) return;
    
    const entityCount = Object.keys(project.entities || {}).length;
    const modalContent = `
        <div class="modal-header">
            <div class="modal-title">📦 ${project.name}</div>
            <button class="modal-close">×</button>
        </div>
        <div class="modal-body">
            <div class="modal-section">
                <div class="modal-section-title">🎯 O que é Single SPA?</div>
                <div class="modal-welcome">
                    Este é um <strong>micro-frontend independente</strong> que faz parte da arquitetura Single SPA.
                    Cada MFE pode ser atualizado, escalado e mantido de forma isolada, sem afetar os demais.
                    Isso permite <strong>deploys independentes</strong>, <strong>equipes autônomas</strong> e
                    <strong>tecnologias diversificadas</strong> em um único приложение.
                </div>
            </div>
            <div class="modal-section">
                <div class="modal-section-title">⚙️ Detalhes Técnicos</div>
                <div class="modal-tech-grid">
                    <div class="modal-tech-item">
                        <div class="modal-tech-label">Rota</div>
                        <div class="modal-tech-value">/${projectKey}</div>
                    </div>
                    <div class="modal-tech-item">
                        <div class="modal-tech-label">Porta API</div>
                        <div class="modal-tech-value">${project.apiPort}</div>
                    </div>
                    <div class="modal-tech-item">
                        <div class="modal-tech-label">Entidades</div>
                        <div class="modal-tech-value">${entityCount}</div>
                    </div>
                </div>
            </div>
            <div class="modal-section">
                <div class="modal-section-title">✅ Benefícios de Manutenção</div>
                <div class="modal-benefits">
                    <span class="modal-benefit">🔵 Deploy Independente</span>
                    <span class="modal-benefit">🔵 Atualização Sem Impacto</span>
                    <span class="modal-benefit">🔵 Manutenção Isolada</span>
                    <span class="modal-benefit">🔵 Escalabilidade</span>
                    <span class="modal-benefit">🔵 Equipes Autônomas</span>
                    <span class="modal-benefit">🔵 Falha Isolada</span>
                </div>
            </div>
            <div class="modal-section">
                <div class="modal-section-title">🛠️ Tecnologia</div>
                <div style="display:flex;justify-content:space-between;align-items:center;">
                    <span class="modal-tech-stack">React + TypeScript</span>
                    <span class="modal-tech-badge">✓ Ativo</span>
                </div>
            </div>
        </div>
        <div class="modal-footer">
            <div class="modal-footer-text">Arquitetura Single SPA • Cada MFE é um micro-frontend independente</div>
        </div>
    `;
    
    let modal = document.getElementById('project-modal');
    if (!modal) {
        modal = document.createElement('div');
        modal.id = 'project-modal';
        modal.className = 'modal-overlay';
        document.body.appendChild(modal);
    }
    modal.innerHTML = '<div class="modal">' + modalContent + '</div>';
    setTimeout(() => modal.classList.add('show'), 10);
}

function closeModal() {
    const modal = document.getElementById('project-modal');
    if (modal) {
        modal.classList.remove('show');
        setTimeout(() => modal.remove(), 300);
    }
}
