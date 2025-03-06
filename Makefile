APP_NAME=liveClass
TAG=latest
GO_LINT=golangci/golangci-lint
GO_LINT_VERSION=v1.64.6
BINARY_DIR=bin
BINARY_PATH=$(BINARY_DIR)/$(APP_NAME)

.PHONY: all test lint fmt vet clean build run deps check dev air

# Default target
all: deps lint test build

# Run tests
test:
	go test -v -race -cover ./...

# Run linting checks
lint:
	@if ! command -v golangci-lint &> /dev/null; then \
		go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest; \
	fi
	golangci-lint run -v

# Format code
fmt:
	go fmt ./...

# Run go vet
vet:
	go vet ./...

# Clean build artifacts
clean:
	go clean
	rm -rf $(BINARY_DIR)

# Build the application
build: clean
	@mkdir -p $(BINARY_DIR)
	go build -o $(BINARY_PATH)

# Run the application
run: build
	$(BINARY_PATH)

# Install dependencies
deps:
	go mod download
	go mod tidy
	go mod verify

# Run all checks
check: fmt vet lint test

# Development with hot reload
dev: deps
	@if ! command -v air &> /dev/null; then \
		go install github.com/cosmtrek/air@latest; \
	fi
	air

# Create necessary directories
init:
	@mkdir -p $(BINARY_DIR)