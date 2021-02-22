#!/usr/bin/env bash
PROTO_VERSION="3.11.3"
OS="linux"
ARCH="x86_64"
PROTO_FILENAME="protoc-${PROTO_VERSION}-${OS}-${ARCH}.zip"
PROTO_URL=https://github.com/protocolbuffers/protobuf/releases/download/v${PROTO_VERSION}/${PROTO_FILENAME}

if [ ! $(command -v protoc) ]; then
  curl -sSLo "${PROTO_URL}"
  unzip "${PROTO_FILENAME}" -d "${GOPATH}"
  go get github.com/golang/protobuf/protoc-gen-go
  go get github.com/micro/protoc-gen-micro
fi

protoc --proto_path=$GOPATH/src:services/ \
  --micro_out=services/ \
  --go_out=services/ \
  services/greeter.proto
