APP_NAME=liveClass
TAG=latest
GO_LINT=golangci/golangci-lint
GO_LINT_VERSION=v1.64.6
BINARY_DIR=bin
BINARY_PATH=$(BINARY_DIR)/$(APP_NAME)

.PHONY: all test lint fmt vet clean build run deps check dev air lint-fe lint-go lint-html lint-js

# Default target
all: deps lint test build

# Run all linting checks
lint: lint-go lint-fe

# Frontend linting (HTML and JS)
lint-fe: lint-html lint-js

# Go linting
lint-go:
	@if ! command -v golangci-lint &> /dev/null; then \
		go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest; \
	fi
	golangci-lint run -v

# HTML linting (includes HTMX attributes)
lint-html:
	@if ! command -v html-validate &> /dev/null; then \
		npm install -g html-validate; \
	fi
	@echo "Linting HTML files..."
	@find ./template -name "*.html" -exec html-validate {} \;

# JavaScript linting (includes Alpine.js)
lint-js:
	@if ! command -v eslint &> /dev/null; then \
		npm install -g eslint eslint-plugin-alpine; \
	fi
	@if [ ! -f .eslintrc.json ]; then \
		echo '{\
			"extends": ["eslint:recommended"],\
			"plugins": ["alpine"],\
			"env": {\
				"browser": true,\
				"es6": true\
			},\
			"parserOptions": {\
				"ecmaVersion": 2022\
			},\
			"rules": {\
				"alpine/no-undefined-properties": "error"\
			}\
		}' > .eslintrc.json; \
	fi
	@echo "Linting JavaScript files..."
	@find ./static -name "*.js" -exec eslint {} \;

# Install all dependencies
deps: deps-go deps-fe

# Install Go dependencies
deps-go:
	go mod download
	go mod tidy
	go mod verify

# Install frontend dependencies
deps-fe:
	@if ! command -v npm &> /dev/null; then \
		echo "Please install Node.js and npm first"; \
		exit 1; \
	fi
	@if [ ! -f package.json ]; then \
		npm init -y; \
	fi
	npm install --save-dev \
		eslint \
		eslint-plugin-alpine \
		html-validate

# Run tests
test:
	go test -v -race -cover ./...

# Format code
fmt: fmt-go fmt-fe

# Format Go code
fmt-go:
	go fmt ./...

# Format frontend code
fmt-fe:
	@if ! command -v prettier &> /dev/null; then \
		npm install -g prettier; \
	fi
	@echo "Formatting HTML files..."
	@find ./template -name "*.html" -exec prettier --write {} \;
	@echo "Formatting JavaScript files..."
	@find ./static -name "*.js" -exec prettier --write {} \;

# Run go vet
vet:
	go vet ./...

# Clean build artifacts
clean:
	go clean
	rm -rf $(BINARY_DIR)
	rm -rf node_modules

# Build the application
build: clean
	@mkdir -p $(BINARY_DIR)
	go build -o $(BINARY_PATH)

# Run the application
run: build
	$(BINARY_PATH)

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
	@mkdir -p static/js
	@mkdir -p template