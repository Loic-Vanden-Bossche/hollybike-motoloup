# Stage 1: build the app
FROM oven/bun:1.2.10 AS builder
WORKDIR /app
COPY . .

# Stage 2: serve the static files
FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf