# Use Node.js 16 as the base image
FROM node:16-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy package files first (for better caching)
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy the rest of the application code
COPY . .

# Expose port 8080 (backend runs on this port)
EXPOSE 8080

# Start the application
CMD ["npm", "start"]