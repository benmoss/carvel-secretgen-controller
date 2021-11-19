set -x

killall minikube mount
docker stop tailymount
docker rm tailymount
