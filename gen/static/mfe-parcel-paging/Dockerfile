# gen/static/mfe-parcel-paging/Dockerfile
# Dockerfile template for MFE Parcel Paging

# Build stage
FROM node:18-alpine AS build
WORKDIR /app

# Copy package files
COPY package.json package-lock.json* ./

# Install dependencies
RUN npm ci --ignore-scripts

# Copy source
COPY . .

# Build the application
RUN npm run build

# Production stage with Nginx
FROM nginx:alpine

# Copy built assets
COPY --from=build /app/dist /usr/share/nginx/html

# Configure Nginx for SPA routing and MFE
# Port will be replaced during generation
RUN printf 'server {
  listen ${APP_PORT:-7200};
  
  location / {
    root /usr/share/nginx/html;
    index index.html;
    try_files $uri $uri/ /index.html;
    
    # CORS headers for MFE
    add_header Access-Control-Allow-Origin * always;
    add_header Access-Control-Allow-Methods "GET, POST, OPTIONS" always;
    add_header Access-Control-Allow-Headers "Content-Type, Authorization" always;
    
    # Cache static assets
    location ~* \\.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
      expires 1y;
      add_header Cache-Control "public, immutable";
    }
  }
  
  # Health check endpoint
  location /health {
    return 200 "OK";
    add_header Content-Type text/plain;
  }
}' > /etc/nginx/conf.d/default.conf

EXPOSE ${APP_PORT:-7200}

CMD ["nginx", "-g", "daemon off;"]
