GO_VERSION ?= 1.15.1
GVM_VERSION ?= 0.2.0
GVM_HOME = $(CURDIR)/go
BIN_DIR ?= $(CURDIR)/bin
ARCH = $(shell uname)
ARCH_L = $(shell uname|tr '[:upper:]' '[:lower:]')

INSTALL_GO = $(shell eval gvm --home=$(GVM_HOME) $(GO_VERSION))

#.SILENT:

.PHONY: help
help:
	@echo "Targets:"
	@echo ""
	@grep '^## @help' Makefile|cut -d ":" -f 2-3|( (sort|column -s ":" -t) || (sort|tr ":" "\t") || (tr ":" "\t"))

## Create a RSA 2048 private key and a x509 certificate.
domain.key:
	printf "[dn]\nCN=localhost\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:localhost\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth" > domain.ext
	openssl req \
	       -newkey rsa:2048 -nodes -sha256 -keyout domain_private.key \
	       -x509 -days 365 -out domain.crt \
				 -subj '/CN=localhost' -extensions EXT -config domain.ext
	openssl rsa -in domain_private.key -out domain.key

# create the directory for the tool binaries.
bin:
	mkdir -p $(BIN_DIR)

## install Go version manager.
bin/gvm: bin
	curl -sL -o $(BIN_DIR)/gvm https://github.com/andrewkroh/gvm/releases/download/v$(GVM_VERSION)/gvm-$(ARCH_L)-amd64
	chmod +x $(BIN_DIR)/gvm
	touch intall-gvm

## @help:build:Build the service.
.PHONY: build
build: bin/gvm domain.key
	$(INSTALL_GO); \
	go version;

## @help:clean:Clean the generated files.
.PHONY: clean
clean:
	rm domain.crt domain.ext domain.key domain_private.key
