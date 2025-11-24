FROM node:18-alpine

WORKDIR /app

COPY package*.json ./

# Install dependencies
RUN npm install

COPY . .

# Build Next.js
RUN npm run build

EXPOSE 3000

CMD ["npm", "start"]