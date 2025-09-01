FROM node:20-alpine

# Install build dependencies
RUN apk add --no-cache git python3 make g++

# Set working directory
WORKDIR /app

# Clone the Happy fork
RUN git clone https://github.com/LymanBE/happy-fork.git /app

# Install dependencies
RUN npm install --legacy-peer-deps --ignore-scripts
RUN npm install -g patch-package
RUN npx patch-package || true

# Build for web
RUN npm run build:web || true

# Expose port
EXPOSE 3000

# Start the application
CMD ["npm", "run", "web"]