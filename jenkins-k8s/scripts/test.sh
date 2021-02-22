#!/usr/bin/env bash
export GO111MODULE=on

go test greeting.go greeting_test.go
