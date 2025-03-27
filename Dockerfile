# 🔧 Etapa 1: Build da aplicação Go
FROM golang:1.23-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY . .

RUN go build -o go-api ./cmd/api/main.go

FROM alpine:latest

RUN apk --no-cache add nginx

WORKDIR /app

COPY --from=builder /app/go-api /app/go-api

COPY nginx.conf /etc/nginx/nginx.conf

COPY .env .env

RUN mkdir -p /run/nginx

EXPOSE 80

CMD /app/go-api & nginx -g 'daemon off;'
