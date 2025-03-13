# === Stage 1: Build Stage ===
FROM node:19-alpine AS builder

# Create app directory & set default dir so that next commands executes in /usr/app dir, liked cd-ing into /usr/app to execute npm install
WORKDIR /usr/app

# Copy package.json, wildcard used so both package.json AND package-lock.json are copied
# slash '/' at the end of app is important, so it created an app directory, otherwise you'll get an error
COPY package*.json .

# Install app dependencies
RUN npm install

# Copy app files from src directory
COPY src ./src

# === Stage 2: Runtime Stage ===
FROM node:19-alpine

# Set working directory
WORKDIR /usr/app

# Copy only the built application from the builder stage
COPY --from=builder /usr/app/node_modules ./node_modules
COPY --from=builder /usr/app/src .

# Start the application
CMD ["node", "server.js"]