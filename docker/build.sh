#!/usr/bin/env bash

function usage() {
    cat <<EOF
build docker image and upload to ecr.

Usage:
    $(basename ${0}) [frontend | backend] [ECR Repository URL]
EOF

return 0
}

if [[ $# -ne 2 ]] ; then
    usage
    exit 1
else
    target=$1
    ecr=$2
fi

$(aws ecr get-login --no-include-email --region ap-northeast-1)
docker build -t $target $target
docker tag $target:latest $ecr/staging-$target:latest
docker push $ecr/staging-$target:latest
