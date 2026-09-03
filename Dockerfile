# Step 1: Build the SPA
FROM node:22 AS build
WORKDIR /app
COPY package*.json ./

RUN npm ci

COPY . .
RUN npm run build

# Step 2: Serve the SPA using Nginx
FROM nginx:stable-alpine
COPY --from=build /app/build /usr/share/nginx/html

# Configure Nginx for SPA fallback (redirect all routes to index.html)
RUN printf 'server {\n listen 80;\n server_name _;\n root /usr/share/nginx/html;\n location / {\n  try_files $uri $uri/ /index.html;\n }\n}\n' > /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]