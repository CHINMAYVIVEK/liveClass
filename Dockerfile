# Stage 1: Build the Go application
FROM golang:1.24-alpine AS builder

# Install git and certificates
RUN apk add --no-cache git ca-certificates

# Set working directory
WORKDIR /app

# Copy go.mod and go.sum, and download dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy all source code
COPY . .

# Build the application
RUN go build -o liveclass main.go

# Stage 2: Create a minimal runtime container
FROM alpine:latest

# Install certificates (required for HTTPS requests)
RUN apk --no-cache add ca-certificates

# Set working directory
WORKDIR /app

# Copy binary from builder
COPY --from=builder /app/liveclass .

# Copy templates and any other needed directories
COPY --from=builder /app/template ./template
COPY --from=builder /app/configs ./configs
COPY --from=builder /app/migrations ./migrations

# (Optional) Copy static folders if you serve static assets like CSS/JS
# COPY --from=builder /app/static ./static

# Expose the port the app runs on
EXPOSE 8080

# Run the binary
CMD ["./liveclass"]
