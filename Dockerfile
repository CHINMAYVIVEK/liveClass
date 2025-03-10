# Build stage
FROM golang:1.24-alpine AS builder

WORKDIR /app

# Install build dependencies
RUN apk add --no-cache git ca-certificates tzdata && \
    update-ca-certificates

# Copy go mod and sum files
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy source code
COPY . .

# Build the application with optimizations
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build \
    -ldflags="-w -s -X main.version=$(git describe --tags --always) -X main.buildTime=$(date +%FT%T%z)" \
    -o /app/bin/liveclass ./cmd/api

# Final stage
FROM alpine:latest

# Add non-root user
RUN addgroup -S app && adduser -S app -G app

# Install runtime dependencies
RUN apk add --no-cache ca-certificates tzdata

# Copy binary from builder
COPY --from=builder /app/bin/liveclass /app/liveclass

# Copy web assets and configs
COPY --from=builder /app/web /app/web
COPY --from=builder /app/configs /app/configs

# Set working directory
WORKDIR /app

# Use non-root user
USER app

# Set environment variables
ENV GO_ENV=production \
    TZ=UTC

# Expose port
EXPOSE 8080

# Run the application
CMD ["/app/liveclass"]

