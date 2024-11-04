# Use a imagem oficial do Node.js
FROM node:18-alpine

# Cria um diretório de trabalho
WORKDIR /app

# Instala dependências para o node-gyp, Python e ferramentas de build
RUN apk add --no-cache python3 py3-pip make g++ && ln -sf python3 /usr/bin/python postgresql-client

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

# Adiciona o comando de build para compilar a aplicação
RUN npm run build

# Expõe a porta 3001 (já que sua aplicação está na 3001, não 3000)
EXPOSE 3001

# Comando para rodar a aplicação em modo de produção
CMD ["npm", "start"]
