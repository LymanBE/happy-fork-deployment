FROM node:20-alpine

# Install build dependencies
RUN apk add --no-cache git python3 make g++

# Set working directory
WORKDIR /app

# Copy the Happy fork code from submodule
COPY happy-fork/ /app/

# Install dependencies
RUN npm install --legacy-peer-deps --ignore-scripts && \
    npm install -g patch-package && \
    npx patch-package || true

# No build step needed - Expo builds at runtime

# Expose port
EXPOSE 3000

# Start the application
CMD ["npm", "run", "web"]