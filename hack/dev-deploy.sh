#!/bin/bash

set -e


if [ "$(docker ps --filter=name=tailymount -q)" = "" ]; then \
  docker build -t buildimage -f Dockerfile .; \
  docker run --mount type=bind,source=$(pwd),target=/go/src/github.com/vmware-tanzu/carvel-secretgen-controller/ \
  --name tailymount -d buildimage; \
fi;


./hack/build.sh && ytt -f config/ | kbld -f- | kapp deploy -a sg -f- -c -y
