package main

import (
	"fmt"
  "flag"
	"context"
  "crypto/tls"
  "google.golang.org/grpc"
  "google.golang.org/grpc/codes"
  "google.golang.org/grpc/credentials"
  "google.golang.org/grpc/metadata"
  "google.golang.org/grpc/status"
	usersSvc "code/ch01_02/services/users"
)

var (
	errMissingMetadata = status.Errorf(codes.InvalidArgument, "missing metadata")
	errInvalidToken    = status.Errorf(codes.Unauthenticated, "invalid token")
)

var port = flag.Int("port", 50051, "the port to serve on")


func main() {
  flag.Parse()
  fmt.Printf("server starting on port %d...\n", *port)

  cert, err := tls.LoadX509KeyPair("domain.crt", "domain.key")
  if err != nil {
    log.Fatalf("failed to load key pair: %s", err)
  }
}
