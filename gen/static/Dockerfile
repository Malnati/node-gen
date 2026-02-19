# gen/static/Dockerfile
FROM node:20-bookworm-slim

WORKDIR /app

COPY package*.json ./
RUN npm install --legacy-peer-deps

COPY . .
RUN npm run build

ENV NODE_ENV=production
EXPOSE 3000

CMD ["node", "dist/main.js"]
