#!/usr/bin/env bash
export GO111MODULE=on

go get github.com/micro/micro
go build greeting.go
