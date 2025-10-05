# Stage 1: Frontend (React/Vite)
FROM node:20-alpine AS frontend
WORKDIR /web
COPY web/ ./
RUN yarn install --frozen-lockfile
RUN yarn build

# Backend (Go)
FROM golang:1.25-alpine AS backend
WORKDIR /app
RUN apk add --no-cache git
COPY . .
COPY --from=frontend /web/dist ./server/router/frontend/dist
RUN go mod download
RUN go build -o memos ./bin/memos

# Stage 3: Final runtime image
FROM alpine:3.19
WORKDIR /app
RUN addgroup -S memos && adduser -S memos -G memos
COPY --from=backend /app/memos /app/memos
RUN chown -R memos:memos /app
USER memos
EXPOSE 8081
CMD ["/app/memos"]
