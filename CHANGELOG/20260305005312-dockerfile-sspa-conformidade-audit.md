<!-- CHANGELOG/20260305005312-dockerfile-sspa-conformidade-audit.md -->
# Auditoria — plano de conformidade do .docker/Dockerfile.sspa

## Data/Hora UTC
2026-03-05T00:53:12Z

## Plano relacionado
- `CHANGELOG/20260305005312-dockerfile-sspa-conformidade-plan.md`

## Comandos executados
1. `ls -la`
2. `rg --files CHANGELOG | head -n 40`
3. `rg -n "Dockerfile\\.sspa|plan|audit" CHANGELOG .github opencode.json`
4. `sed -n '1,220p' CHANGELOG/20260304115247-makefile-gen-project-pg-plan.md`
5. `sed -n '1,220p' CHANGELOG/20260304115247-makefile-gen-project-pg-audit.md`
6. `sed -n '1,220p' .docker/Dockerfile.sspa`
7. `wc -l .docker/Dockerfile.sspa`
8. `rg -n "^(FROM|RUN|ARG|ENV|COPY|CMD|ENTRYPOINT|EXPOSE|WORKDIR)|SSPA_SKIP_AUTH|SSPA_AUTH_TOKEN|cat >|__SSPA_SKIP_AUTH__|projects\\.json" .docker/Dockerfile.sspa`
9. `sed -n '220,520p' .docker/Dockerfile.sspa`
10. `rg -n "Dockerfile\\.sspa|\\.docker/Dockerfile\\.sspa|sspa\\.conf|SSPA_SKIP_AUTH" CHANGELOG`
11. `ls -1 CHANGELOG | sort | tail -n 25`
12. `date -u +%Y%m%d%H%M%S`
13. Revisão do plano com ajuste de escopo para remover `HEREDOC` e `node -e` inline do `.docker/Dockerfile.sspa`, com extração para `.docker/sspa/*`
14. `rg -n "RUN cat >|<< '\\w+EOF'|node -e '" .docker/Dockerfile.sspa .docker/sspa/* || true`
15. `make projects-build`
16. `make projects-up`
17. `curl -s -o /tmp/sspa-home.html -w "%{http_code}" http://localhost:9000/`
18. `curl -sS http://localhost:9000/data/projects.json | head -n 20`
19. `curl -s -o /dev/null -w "%{http_code}" http://localhost:9000/data/projects.json`
20. `make projects-down`

## Resultado resumido
- Criação do novo plano estruturado para correção do `.docker/Dockerfile.sspa`: **PASSOU**.
- Criação do arquivo de auditoria irmão com referência cruzada: **PASSOU**.
- Ajuste do plano para explicitar divisão do Dockerfile em arquivos versionados (`.docker/sspa/*`) e remoção de hardcoded inline: **PASSOU**.
- Implementação da correção no `.docker/Dockerfile.sspa` com `COPY` de arquivos versionados: **PASSOU**.
- Verificação de conformidade sem `HEREDOC` e sem `node -e` inline no Dockerfile: **PASSOU**.
- Build da stack de projetos PostgreSQL (`make projects-build`): **PASSOU**.
- Subida do orquestrador e APIs (`make projects-up`): **PASSOU**.
- Health HTTP do SSPA em `http://localhost:9000/` (status `200`): **PASSOU**.
- Publicação de `http://localhost:9000/data/projects.json` (status `200` e payload retornado): **PASSOU**.
- Encerramento da stack (`make projects-down`): **PASSOU COM OBSERVAÇÃO** (rede `node-gen_default` permaneceu em uso por recursos órfãos externos ao compose alvo).

## Evidências obrigatórias
- Arquivos alterados:
  - `.docker/Dockerfile.sspa`
  - `.docker/sspa/dashboard.css`
  - `.docker/sspa/app.js`
  - `.docker/sspa/index.html`
  - `.docker/sspa/sspa.conf`
  - `.docker/sspa/generate-projects-json.js`
  - `CHANGELOG/20260305005312-dockerfile-sspa-conformidade-plan.md`
  - `CHANGELOG/20260305005312-dockerfile-sspa-conformidade-audit.md`
- Definição de pronto (escopo desta solicitação):
  - [x] Novo plano criado no `CHANGELOG/` para o `.docker/Dockerfile.sspa`.
  - [x] Estrutura do plano em 8 seções obrigatórias.
  - [x] Arquivo de auditoria irmão com mesmo prefixo de timestamp e sufixo `-audit`.
  - [x] Referências cruzadas a ciclos anteriores relevantes.
  - [x] Plano atualizado para exigir extração de `HEREDOC`/hardcoded e `node -e` inline para arquivos versionados.
  - [x] Correção implementada no `.docker/Dockerfile.sspa` com extração para arquivos versionados.
  - [x] Dockerfile final sem blocos `RUN cat <<EOF`.
  - [x] Dockerfile final sem `node -e` inline.
  - [x] Build e validação HTTP básicos do SSPA executados via `Makefile`.

## Pendências remanescentes
- Sem pendências funcionais dentro do escopo deste plano.
- Observação operacional: havia recursos órfãos mantendo a rede padrão em uso ao final do `make projects-down`; tratar limpeza total em ciclo dedicado, se necessário.
