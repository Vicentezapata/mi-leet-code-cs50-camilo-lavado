# Stage 1: build
FROM golang:latest AS builder
WORKDIR /build
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o localcode ./cmd/server/main.go

# Stage 2: runtime
# Needs docker-cli to spawn containers via the host socket
FROM alpine:3.21
RUN apk add --no-cache docker-cli ca-certificates
WORKDIR /app
COPY --from=builder /build/localcode ./
COPY assets/ ./assets/
COPY db/ ./db/
COPY content/ ./content/
EXPOSE 8080
CMD ["./localcode"]
