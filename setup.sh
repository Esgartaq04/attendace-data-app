#!/bin/bash

# 1. Create Root Directory
echo "🏗️  Creating project directory..."
mkdir -p uic-event-app
cd uic-event-app

# 2. Setup Backend (Node/Fastify)
echo "🔙 Setting up Backend (Server)..."
mkdir -p server/config server/routes server/services
cd server

# Initialize Node.js project
npm init -y

# Install Backend Dependencies
npm install fastify pg redis dotenv
npm install --save-dev nodemon

# Create Backend Entry Point (index.js)
cat <<EOF > index.js
const fastify = require('fastify')({ logger: true });
const PORT = process.env.PORT || 8080;

// Health Check
fastify.get('/', async (request, reply) => {
  return { status: 'ok', service: 'uic-event-api' };
});

// Check-in Endpoint
fastify.post('/api/checkin', async (request, reply) => {
  const { userId, eventCode } = request.body;
  // Placeholder for logic
  return { success: true, message: \`User \${userId} checked into \${eventCode}\` };
});

const start = async () => {
  try {
    await fastify.listen({ port: PORT, host: '0.0.0.0' });
    console.log(\`Server running on port \${PORT}\`);
  } catch (err) {
    fastify.log.error(err);
    process.exit(1);
  }
};
start();
EOF

# Create Backend Dockerfile
cat <<EOF > Dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install --production
COPY . .
EXPOSE 8080
CMD [ "node", "index.js" ]
EOF

cd ..

# 3. Setup Frontend (Next.js)
echo "🎨 Setting up Frontend (Client)..."
# We use npx to create the app non-interactively
npx create-next-app@latest client \
  --js \
  --tailwind \
  --eslint \
  --app \
  --src-dir \
  --import-alias "@/*" \
  --use-npm \
  --no-git 

cd client

# Install Client Dependencies
# firebase: for auth/db
# html5-qrcode: for scanning
# qrcode.react: for displaying codes
# recharts: for the organizer reports
npm install firebase html5-qrcode qrcode.react recharts

# Create Frontend Dockerfile
cat <<EOF > Dockerfile
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM node:18-alpine AS runner
WORKDIR /app
ENV NODE_ENV production
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static
USER nextjs
EXPOSE 3000
ENV PORT 3000
CMD ["node", "server.js"]
EOF

# Update next.config.js for Docker standalone output
cat <<EOF > next.config.js
/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'standalone',
}

module.exports = nextConfig
EOF

cd ..

# 4. Create Root Docker Compose
echo "🐳 Creating Docker Compose..."
cat <<EOF > docker-compose.yml
version: '3.8'

services:
  client:
    build: ./client
    ports:
      - "3000:3000"
    environment:
      - NEXT_PUBLIC_API_URL=http://localhost:8080
    depends_on:
      - server

  server:
    build: ./server
    ports:
      - "8080:8080"
    environment:
      - DB_HOST=postgres
      - REDIS_HOST=redis
    depends_on:
      - postgres
      - redis

  postgres:
    image: postgres:15-alpine
    environment:
      POSTGRES_USER: uic_admin
      POSTGRES_PASSWORD: password123
      POSTGRES_DB: uic_events
    volumes:
      - postgres_data:/var/lib/postgresql/data

  redis:
    image: redis:alpine

volumes:
  postgres_data:
EOF

# 5. Create Docs Directory
echo "📚 Creating documentation folder..."
mkdir -p docs
touch docs/UIC_Event_App_Plan.md
touch docs/UIC_Event_App_Wireframes.md

echo "✅ Setup Complete! To run the project locally:"
echo "   cd uic-event-app"
echo "   docker-compose up --build"
