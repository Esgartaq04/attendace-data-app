# Base image
FROM node:18-alpine

# Create app directory
WORKDIR /usr/src/app

# Install dependencies
COPY package*.json ./
COPY prisma ./prisma/

# Install npm packages
RUN npm install

# Generate Prisma Client
RUN npx prisma generate

# Bundle app source
COPY . .

# Build TypeScript
RUN npm run build

# Expose port
EXPOSE 5000

# Start command
CMD [ "npm", "start" ]