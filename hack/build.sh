#!/bin/bash

set -e -x -u

# makes builds reproducible
export CGO_ENABLED=0
repro_flags="-ldflags=-buildid= -trimpath"

go fmt ./cmd/... ./pkg/...
go mod vendor
go mod tidy

go build $repro_flags -mod=vendor -o controller ./cmd/controller/...
ls -la ./controller

# compile tests, but do not run them: https://github.com/golang/go/issues/15513#issuecomment-839126426
go test --exec=echo ./... >/dev/null

ytt -f config/ >/dev/null

echo SUCCESS
