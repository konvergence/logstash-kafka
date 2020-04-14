#!/bin/bash

set -ex

#PARENT_DIR=$(basename "${PWD%/*}")
CURRENT_DIR="${PWD##*/}"
IMAGE_NAME="$CURRENT_DIR"
TAG="${1}"

REGISTRY="konvergence"

docker build --no-cache -t ${REGISTRY}/${IMAGE_NAME}:${TAG} -t ${REGISTRY}/${IMAGE_NAME}:latest .

#docker push ${REGISTRY}/${IMAGE_NAME}