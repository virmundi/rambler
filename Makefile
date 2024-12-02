targets="windows/amd64,windows/386,darwin/arm64,darwin/amd64,darwin/386,linux/amd64,linux/386"
pkg="github.com/elwinar/rambler"
version=$(shell git describe --tags)
ldflags="-X main.VERSION=${version}"

default: build
all: build test

.PHONY: build
build: ## Build the binary for the local architecture
	go build --ldflags=${ldflags}

.PHONY: help
help: ## Get help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' ${MAKEFILE_LIST} | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-10s\033[0m %s\n", $$1, $$2}'

.PHONY: release
release: ## Build the release files
	xgo --dest release --targets=$(targets) --ldflags=$(ldflags) $(pkg)
	docker-compose run -w /src main sh -c 'apk add build-base && go build -o release/rambler-alpine-amd64 --ldflags=${ldflags}'

.PHONY: test
test: ## Test the project
	go test ./...
.PHONY: cross-build
cross-build: ## Build for Windows 64-bit, Linux 64-bit, macOS AMD64, and macOS ARM64
	GOOS=windows GOARCH=amd64 go build -o release/rambler-windows-amd64.exe -ldflags=${ldflags} ${pkg}
	GOOS=linux GOARCH=amd64 go build -o release/rambler-linux-amd64 -ldflags=${ldflags} ${pkg}
	GOOS=darwin GOARCH=amd64 go build -o release/rambler-darwin-amd64 -ldflags=${ldflags} ${pkg}
	GOOS=darwin GOARCH=arm64 go build -o release/rambler-darwin-arm64 -ldflags=${ldflags} ${pkg}
