set -ex

CGO_ENABLED=0 GOOS=linux go build -mod=vendor -ldflags="-X 'main.Version=$SGCTRL_VER' -buildid=" -trimpath -o controller ./cmd/controller/... && echo "Build succeeded"
