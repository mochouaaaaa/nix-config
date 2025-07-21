# Variables
BINARY_NAME=jetbra-free
BIN_DIR=./bin
EMBED_FILE=internal/util/bindata.go
GO_BINDATA=go-bindata
SRC_DIRS=static/... templates/... cache/...

all: build

build: bindata-access
	go build -o ./bin/$(BINARY_NAME) cmd/main.go

run: build
	./bin/$(BINARY_NAME)

build-all: build-mac build-mac-arm build-windows build-win7 build-linux

build-mac: bindata-access
	GOOS=darwin GOARCH=amd64 go build -o $(BIN_DIR)/$(BINARY_NAME)-darwin-amd64 cmd/main.go

build-mac-arm: bindata-access
	GOOS=darwin GOARCH=arm64 go build -o $(BIN_DIR)/$(BINARY_NAME)-darwin-arm64 cmd/main.go

build-windows: bindata-access
	GOOS=windows GOARCH=amd64 go build -o $(BIN_DIR)/$(BINARY_NAME)-windows-amd64.exe cmd/main.go

build-win7: bindata-access
	GOOS=windows GOARCH=amd64 go build -ldflags="-extldflags=-subsystem=console,6.1" -o $(BIN_DIR)/$(BINARY_NAME)-windows7-amd64.exe cmd/main.go

build-linux: bindata-access
	GOOS=linux GOARCH=amd64 go build -o $(BIN_DIR)/$(BINARY_NAME)-linux-amd64 cmd/main.go

clean:
	rm -rf ./bin/

install-bindata:
	go install github.com/go-bindata/go-bindata/v3/go-bindata@latest

bindata-access:
	go-bindata -o internal/util/access.go -pkg util $(SRC_DIRS)
