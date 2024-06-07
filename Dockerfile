# Build stage
FROM node:20-alpine as build

# Set the working directory to /app
WORKDIR /app

# Copy package.json 
COPY package*.json ./

# Install pnpm globally
RUN npm install -g pnpm

# Copy the rest of the application to the container
COPY ./ ./

# Install dependencies
RUN pnpm install

RUN pnpm build

# Production stage
FROM node:20-alpine

# Set the working directory to /app
WORKDIR /app

# Install serve globally
RUN npm i --global serve

COPY --from=build /app/package*.json ./
COPY --from=build /app/dist ./

CMD ["npm", "run", "start:prod"]