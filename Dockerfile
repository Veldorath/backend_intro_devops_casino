# Dockerfile — casino-backend (Node/Express, puerto 3000)
# Multi-stage: 1) instala dependencias, 2) imagen final mínima sin dev-deps.
FROM node:20-slim AS deps
WORKDIR /app
COPY package*.json ./
RUN npm install --omit=dev

FROM node:20-slim AS runtime
ENV NODE_ENV=production
WORKDIR /app
# Copia node_modules ya resueltos y el código
COPY --from=deps /app/node_modules ./node_modules
COPY package*.json ./
COPY src/ ./src/
COPY db/ ./db/
# node:20-slim ya trae un usuario 'node' no root
USER node
EXPOSE 3000
CMD ["node", "src/server.js"]
