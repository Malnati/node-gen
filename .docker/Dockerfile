# Use a imagem oficial do Node.js
FROM node:18-alpine

# Cria um diretório de trabalho
WORKDIR /app

# Adiciona um novo grupo e usuário
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Instala dependências para o node-gyp, Python e ferramentas de build
RUN apk add --no-cache python3 py3-pip make g++ && ln -sf python3 /usr/bin/python

# Copia o package.json e package-lock.json para o diretório de trabalho
COPY ../package*.json ./

# Instala as dependências da aplicação
RUN npm install --legacy-peer-deps

# Instalação de pacotes globais necessários
RUN npm install -g \
    @nestjs/cli \
    typescript \
    ts-node \
    prettier \
    rimraf

# Copia o restante do código da aplicação para o diretório de trabalho
COPY ../ ./

# Concede a permissão do diretório de trabalho ao novo usuário
RUN chown -R appuser:appgroup /app && chmod -R 777 /app

# Adiciona o comando de build para compilar a aplicação
RUN npm run build

# Define o usuário não root para rodar a aplicação
USER appuser

# Expõe a porta 3001 (já que sua aplicação está na 3001, não 3000)
EXPOSE 3001

# Comando para rodar a aplicação em modo de produção
CMD ["npm", "start"]
