<!-- app/api/README.md -->
# API - Backend NestJS

A **API** é o serviço backend responsável por toda a lógica de negócio, autenticação, processamento de dados e integrações externas. Desenvolvida com NestJS, TypeScript e seguindo as melhores práticas de arquitetura limpa.

## Visão geral

Serviço backend que oferece endpoints RESTful para autenticação Google SSO, integração com Gmail API, processamento de dados com IA via OpenRouter e gerenciamento completo da aplicação.

## Estrutura do projeto

```
app/api/
├── src/
│   ├── common/          # Componentes compartilhados
│   ├── modules/         # Módulos de negócio
│   ├── types/           # Tipos TypeScript
│   ├── utils/           # Utilitários
│   ├── app.controller.ts
│   ├── app.service.ts
│   └── app.module.ts
├── test/                # Testes unitários e E2E
├── Dockerfile
├── docker-compose.yml
├── package.json
├── tsconfig.json
├── nest-cli.json
├── .env
└── .env.example
```

## Variáveis de Ambiente

| Nome | Padrão | Descrição |
|------|--------|-----------|
| `APP_API_NODE_ENV` | `development` | Ambiente de execução da aplicação |
| `APP_API_PORT` | `3001` | Porta de exposição da API |
| `APP_API_HOST` | `0.0.0.0` | Host de bind da aplicação |
| `APP_API_CORS_ORIGIN` | `*` | Origens permitidas para CORS |
| `APP_DB_HOST` | `localhost` | Host do banco de dados |
| `DATABASE_PORT` | `5432` | Porta do banco de dados |
| `APP_DB_USER` | `postgres` | Usuário do banco de dados |
| `APP_DB_PASSWORD` | `postgres` | Senha do banco de dados |
| `APP_DB_NAME` | `db` | Nome do banco de dados |
| `GOOGLE_MAPS_SERVER_KEY` | - | Chave server-side Google Maps API |
| `APP_GOOGLE_CLIENT_ID` | - | Client ID Google OAuth 2.0 |
| `APP_GOOGLE_CLIENT_SECRET` | - | Client Secret Google OAuth 2.0 |
| `APP_JWT_SECRET` | - | Chave secreta para assinatura JWT |
| `APP_JWT_EXPIRES_IN` | `24h` | Tempo de expiração do token JWT |
| `GMAIL_CLIENT_ID` | - | Client ID Gmail API |
| `GMAIL_CLIENT_SECRET` | - | Client Secret Gmail API |
| `GMAIL_REFRESH_TOKEN` | - | Refresh token Gmail API |
| `GMAIL_SENDER` | `noreply@cranio.dev` | E-mail remetente padrão |
| `APP_BASE_URL` | `http://localhost:5174` | URL base da aplicação frontend |
| `APP_API_BASE_URL` | `http://localhost:3001` | URL base da API |
| `APP_API_PRODUCTION_URL` | `http://localhost:3001` | URL de produção da API |
| `APP_API_URL` | `http://localhost:3001/api` | URL completa da API |
| `OPENROUTER_API_KEY` | - | API key OpenRouter IA |
| `OPENROUTER_BASE_URL` | `https://openrouter.ai/api/v1/chat/completions` | URL base OpenRouter |
| `OPENROUTER_MODEL` | `anthropic/claude-3.5-sonnet` | Modelo IA padrão |
| `OPENROUTER_HTTP_REFERER` | - | HTTP referer OpenRouter |
| `OPENROUTER_APP_TITLE` | `APP` | Título da aplicação OpenRouter |
| `GOOGLE_MAPS_GEOCODING_API_URL` | `https://maps.googleapis.com/maps/api/geocode/json` | URL Geocoding API |
| `APP_JOB_SERVICE_TOKEN` | `default-service-token` | Token de comunicação com serviço Job |
| `APP_API_HEALTHCHECK_URL` | `http://localhost:3001/api/health` | URL de healthcheck |

## Início rápido

1. **Configure o projeto localmente:**
    ```bash
    # Clone o repositório (se ainda não tiver)
    git clone <url-do-repositorio>
    cd app/api
    
    # Setup completo (instala Prettier e hooks git)
    make setup
    
    # Configure as variáveis de ambiente
    cp .env.example .env
    # Edite .env e configure as variáveis obrigatórias
    ```

2. **Configure os hooks git (se não usou make setup):**
    ```bash
    # Instalar hooks manualmente
    make install-hooks
    
    # Ou configurar manualmente
    mkdir -p .git/hooks
    echo '#!/bin/sh
    echo "🔍 Verificando formatação do código..."
    npm run format:check
    if [ $? -ne 0 ]; then
      echo "❌ Código não formatado. Execute \"npm run format\" e tente novamente."
      echo "💡 Ou execute \"make format\" para formatar automaticamente."
      exit 1
    fi
    echo "✅ Formatação verificada com sucesso!"' > .git/hooks/pre-push
    chmod +x .git/hooks/pre-push
    ```

3. **Inicie o serviço:**
    ```bash
    # Build e iniciar
    make build && make start
    
    # Ou em modo desenvolvimento local
    make dev
    ```

4. **Acesse a API:**
    - Healthcheck: `http://localhost:3001/api/health`
    - Documentação: `http://localhost:3001/api` (quando disponível)

## Configuração Local Detalhada

### 1. Setup do Projeto
```bash
# Entrar no diretório do projeto
cd app/api

# Setup completo (recomendado)
make setup

# Ou passo a passo:
make setup-prettier  # Configura Prettier
make install-hooks   # Instala hooks git
```

### 2. Configuração do Pre-push
O hook pre-push irá:
- Verificar se o código está formatado com Prettier
- Bloquear o push se houver arquivos não formatados
- Exibir instruções para corrigir o problema

### 3. Formatação Automática
```bash
# Formatar todos os arquivos
make format

# Ou via npm
npm run format

# Verificar formatação sem alterar
make check-format
npm run format:check
```

### 4. Teste dos Hooks
```bash
# Testar hook manualmente
.git/hooks/pre-push

# Fazer um commit de teste
echo "test" > test.txt
git add test.txt
git commit -m "test"
git push origin main  # Deve ser bloqueado se houver formatação incorreta
```

### 5. Desabilitar Hooks (se necessário)
```bash
# Remover hooks temporariamente
rm .git/hooks/pre-push
rm .git/hooks/pre-commit

# Reinstalar depois
make install-hooks
```

## Principais funcionalidades

- **Autenticação Google SSO** - Integração completa com OAuth 2.0
- **Gmail API** - Envio de e-mails transacionais
- **OpenRouter IA** - Processamento com modelos de linguagem
- **Google Maps** - Validação e geocodificação
- **JWT Tokens** - Autenticação stateless segura
- **Healthchecks** - Monitoramento completo do serviço

## Endpoints principais

- `GET /api/health` - Verificação de saúde do serviço
- `POST /api/auth/google` - Autenticação Google SSO
- `POST /api/auth/refresh` - Refresh token JWT
- `POST /api/email/send` - Envio de e-mails via Gmail
- `POST /api/ai/process` - Processamento com IA

## Desenvolvimento

### Instalação de dependências
```bash
npm install
```

### Execução em modo desenvolvimento
```bash
npm run start:dev
```

### Build para produção
```bash
npm run build
npm run start:prod
```

### Testes
```bash
npm run test
npm run test:e2e
npm run test:cov
```

### Lint e formatação
```bash
npm run lint
npm run format
```

## Docker

### Build da imagem
```bash
docker build -t api .
```

### Execução com Docker Compose
```bash
docker compose -f docker-compose.yml up -d
```

### Logs
```bash
docker compose -f docker-compose.yml logs -f
```

## Troubleshooting

### Conexão com banco de dados
- Verifique se o serviço DB está rodando na porta 5432
- Confirme as credenciais no arquivo .env
- Teste conectividade: `telnet localhost 5432`

### Autenticação Google
- Configure Client ID e Secret no Google Cloud Console
- Adicione URLs de redirecionamento autorizadas
- Verifique se as variáveis estão corretas no .env

### Gmail API
- Habilite Gmail API no Google Cloud Console
- Configure OAuth 2.0 credentials
- Gere refresh token para acesso contínuo

## Makefile targets

### Comandos principais
- `make build` - Build da imagem Docker
- `make start` - Iniciar o serviço
- `make stop` - Parar o serviço
- `make restart` - Reiniciar o serviço
- `make logs` - Ver logs do serviço
- `make clean` - Remover containers e imagens

### Comandos de desenvolvimento
- `make dev` - Iniciar em modo desenvolvimento local
- `make test` - Executar testes
- `make lint` - Executar lint
- `make format` - Formatar código
- `make shell` - Acessar shell do container

### Comandos de manutenção
- `make health` - Verificar saúde do serviço
- `make status` - Ver status do container
- `make rebuild` - Rebuild completo (remove e build novamente)
- `make install` - Instalar dependências no container
- `make env-check` - Verificar variáveis de ambiente

### Comandos de informação
- `make help` - Exibir ajuda com todos os comandos
- `make info` - Exibir informações do serviço
- `make ports` - Verificar portas disponíveis

### Exemplos de uso
```bash
# Build e iniciar
make build && make start

# Ver logs
make logs

# Acessar container
make shell

# Verificar saúde
make health

# Rebuild completo
make rebuild
```

---

© Template Corporation — uso corporativo restrito.
