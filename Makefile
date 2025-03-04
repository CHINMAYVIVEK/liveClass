.PHONY: test lint fmt vet clean build run

# Default target
all: lint test build

# Run tests
test:
	go test -v -race -cover ./...

# Run linting checks
lint:
	golangci-lint run ./...

# Format code
fmt:
	go fmt ./...

# Run go vet
vet:
	go vet ./...

# Clean build artifacts
clean:
	go clean
	rm -f bin/*

# Build the application
build: clean
	go build -o bin/liveClass

# Run the application
run: build
	./bin/liveClass

# Install dependencies
deps:
	go mod tidy
	go mod verify
	go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest

# Run all checks
check: fmt vet lint test