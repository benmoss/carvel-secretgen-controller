#!/bin/bash

set -ex


if [ "$(docker ps --filter=name=tailymount -q)" = "" ]; then \
  minikube mount $(pwd):$(pwd) & # need to mount the source into the minikube-docker first, and leave that mounting proc running in the background.
  sleep 1
  docker build -t buildimage -f Dockerfile.tail .; \
  docker run --mount type=bind,source=$(pwd),target=/go/src/github.com/vmware-tanzu/carvel-secretgen-controller/ \
  --name tailymount -d buildimage; \
fi;

# helpful ldflags reference: https://www.digitalocean.com/community/tutorials/using-ldflags-to-set-version-information-for-go-applications
docker exec tailymount /go/src/github.com/vmware-tanzu/carvel-secretgen-controller/hack/dev-container-build.sh \
  && ytt -f config/ | kbld -f- | kapp deploy -a sg -f- -c -y
