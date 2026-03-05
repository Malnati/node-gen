<!-- CHANGELOG/20260305170000-service-discovery-mfe-browser-fix-plan.md -->
# Plano - Diagnóstico e correção de MFEs no navegador

## Problema reportado
Erro ao acessar via navegador:
```
[Error] [demo/sspa] failed to setup dynamic applications – TypeError: Load failed
Error loading http://157.173.125.230:7101/spa.js (SystemJS Error#3)
```

## Hipóteses do problema
1. Containers dos MFEs não iniciaram corretamente (build falhou ou porta não exposta)
2. Service-discovery configurou URLs externas (IP público) mas containers não são acessíveis externamente
3. MFEs gerados não têm build concluído (apenas código copiado)
4. Porta 7101 não está mapeada corretamente no docker-compose

## Verificações diagnósticas necessárias
### 1. Verificar status dos containers
```bash
docker ps -a | grep -E "nodegen|mfe|contacts|accounts|orders"
```

### 2. Verificar logs dos containers
```bash
docker logs nodegen-demo-mfe-contacts
```

### 3. Verificar se MFEs foram buildados
```bash
ls -la output/contacts/postgres/frontend/contact-mfe/dist/ 2>/dev/null || echo "dist não existe"
cat output/contacts/postgres/frontend/contact-mfe/Dockerfile
```

### 4. Verificar variáveis de ambiente no compose
```bash
grep -r "VITE_MFE_BASE_URL\|VITE_PUBLIC_URL" .docker/
```

## Arquivos a alterar (dependendo da causa)
Possíveis correções:
1. `gen/templates/mfe-docker-compose.ejs` - adicionar EXPOSE da porta
2. `Makefile` - ajustar mapeamento de portas nos containers
3. `gen/templates/mfe-vite-config.ejs` - verificar configuração de build
4. `gen/templates/mfe-dockerfile.ejs` - verificar se faz build corretamente

## Requisitos
- MFEs devem ser acessíveis via navegador no IP/domínio configurado
- URLs dinâmicas devem funcionar com VITE_MFE_BASE_URL

## Plano de auditoria
### Verificações manuais
1. Verificar se containers estão rodando: `docker ps`
2. Verificar se portas estão mapeadas: `docker port <container>`
3. Acessar URL direto do MFE: `curl http://localhost:7101/spa.js`
4. Testar via IP público no navegador

### Verificações automáticas
- `make demo-pg-up` executa sem erro
- `curl localhost:7101/spa.js` retorna conteúdo válido
- `curl localhost:3015/api/discovery/applications` retorna lista de apps

## Checklists obrigatórios
- [ ] Diagnosticar causa raiz do erro
- [ ] Corrigir problema identificado
- [ ] Validar acesso via navegador
- [ ] Documentar solução
