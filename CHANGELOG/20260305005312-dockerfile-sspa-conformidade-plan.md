<!-- CHANGELOG/20260305005312-dockerfile-sspa-conformidade-plan.md -->
# Plano — conformidade do .docker/Dockerfile.sspa com regras do repositório

## Data/Hora UTC
2026-03-05T00:53:12Z

## 1. Arquivos existentes relevantes para o escopo
- `.docker/Dockerfile.sspa`
- `.docker/docker-compose.projects.postgres.yml`
- `Makefile`
- `AGENTS.md`
- `opencode.json`
- `CHANGELOG/20260304180439-demo-sspa-discovery-dinamico-plan.md`
- `CHANGELOG/20260304180439-demo-sspa-discovery-dinamico-audit.md`
- `CHANGELOG/20260302190041-sspa-skip-auth-regression-fix.md`

## 2. Arquivos que serão alterados
- `.docker/Dockerfile.sspa`
- `.docker/sspa/dashboard.css`
- `.docker/sspa/app.js`
- `.docker/sspa/index.html`
- `.docker/sspa/sspa.conf`
- `.docker/sspa/generate-projects-json.js`
- `CHANGELOG/20260305005312-dockerfile-sspa-conformidade-plan.md`
- `CHANGELOG/20260305005312-dockerfile-sspa-conformidade-audit.md`

## 3. Lista combinada de requisitos (específicos + globais)
- Registrar novo plano no `CHANGELOG/` para o ciclo de correção do `.docker/Dockerfile.sspa`.
- Corrigir o `.docker/Dockerfile.sspa` sem expandir escopo para outros subprojetos.
- Preservar a regra obrigatória do SSPA: quando `SSPA_SKIP_AUTH=true`, o frontend não deve exigir `SSPA_AUTH_TOKEN`.
- Garantir cadeia de configuração explícita para flags do SSPA (`.env` -> compose -> serviço/aplicação), sem valores sensíveis hardcoded.
- Eliminar `HEREDOC` (`RUN cat <<EOF`) e conteúdo hardcoded inline no `.docker/Dockerfile.sspa`.
- Extrair CSS, JavaScript, HTML e configuração NGINX para arquivos versionados em `.docker/sspa/`, usando `COPY` no Dockerfile.
- Extrair o script inline `node -e` da geração de `projects.json` para arquivo JavaScript dedicado em `.docker/sspa/`, mantendo comportamento funcional.
- Manter execução operacional exclusivamente por alvos já existentes do `Makefile`.
- Não adicionar dependências, serviços, pipelines, jobs ou refactors amplos.

## 4. Requisitos não atendidos no início do ciclo
- O `.docker/Dockerfile.sspa` concentra conteúdo extenso de CSS/JS/HTML/NGINX e lógica de geração em comandos inline (`RUN cat <<EOF` e `node -e ...`), reduzindo rastreabilidade e manutenção.
- Existem valores operacionais fixos no Dockerfile (por exemplo, portas e lista de rotas) sem parametrização explícita por variáveis de ambiente.
- O plano específico deste ciclo ainda não estava registrado com pendências e validações objetivas.

## 5. Lista combinada de regras (específicas + globais)
- Alterar apenas arquivos necessários para corrigir a não conformidade do `.docker/Dockerfile.sspa`.
- Não criar múltiplas soluções; entregar a solução direta definida no plano.
- Não introduzir scripts shell novos (`.sh`/`.bash`) nem novos alvos no `Makefile` sem solicitação explícita.
- Garantir que o Dockerfile final não contenha blocos `RUN cat <<EOF` para ativos estáticos/aplicação.
- Garantir que o Dockerfile final não contenha script de aplicação em linha (`node -e ...`) para geração de manifesto.
- Preservar rastreabilidade com plano + auditoria em `CHANGELOG/*` com referências cruzadas.
- Não incluir segredos, tokens ou dumps de ambiente nos artefatos gerados.

## 6. Regras não atendidas que motivam os ajustes
- O Dockerfile atual mistura responsabilidades de build e entrega de artefatos de aplicação em blocos inline extensos.
- A parametrização de configuração operacional do SSPA não está explicitada de forma uniforme no artefato alvo do ajuste.
- A rastreabilidade do ciclo de correção ainda não estava formalizada em um novo par plano/auditoria.

## 7. Plano de auditoria (manual + automático)
1. Executar `make projects-build` para validar que a imagem do SSPA continua buildando após a correção.
2. Executar `make projects-up` para validar subida do orquestrador e APIs.
3. Executar `curl -sS http://localhost:9000/data/projects.json | head` para confirmar geração/publicação de `projects.json`.
4. Executar `curl -s -o /dev/null -w "%{http_code}" http://localhost:9000/` e validar `200`.
5. Executar `rg -n "RUN cat >|<< '\\w+EOF'|node -e '" .docker/Dockerfile.sspa` e validar ausência de ocorrências.
6. Validar, via inspeção do código final, que `SSPA_SKIP_AUTH=true` mantém bypass de token no frontend do SSPA.
7. Executar `make projects-down` ao final para limpeza do ambiente de validação.
8. Registrar no arquivo de auditoria irmão os comandos, status (passou/falhou) e pendências remanescentes.

## 8. Seleção de checklists aplicáveis
- Checklist obrigatório transversal: rastreabilidade de ciclo com `CHANGELOG/*-plan.md` e `CHANGELOG/*-audit.md`.
- Checklist de escopo mínimo: apenas correção de não conformidade do `.docker/Dockerfile.sspa`.
- Checklist de conformidade Dockerfile: sem `HEREDOC` e sem `node -e` inline para ativos da aplicação.
- Checklist de evidências: arquivos alterados, comandos executados e resultado objetivo.

## Pendências registradas deste ciclo
- Executar a implementação da correção no `.docker/Dockerfile.sspa` com extração dos blocos inline para `.docker/sspa/*`.
- Registrar evidências de validação de build/subida/health do SSPA no arquivo de auditoria do mesmo timestamp.

## Referências cruzadas
- `CHANGELOG/20260304180439-demo-sspa-discovery-dinamico-plan.md`
- `CHANGELOG/20260304180439-demo-sspa-discovery-dinamico-audit.md`
- `CHANGELOG/20260302190041-sspa-skip-auth-regression-fix.md`
