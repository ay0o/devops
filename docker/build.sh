#!/bin/bash

# Script to test the code, build the image and test the image.
# To test the code, a multi-stage "test" is required in the Dockerfile. Check docker/dockerfiles/python_with_tests for an example

set -e

[ -z $1 ] && echo "[ERROR] Missing image name" && exit 1

echo -e "=== Running Dockerfile linter ===\n"
docker run --rm -i -v "$(pwd)/ci/.hadolint.yaml":/.hadolint.yaml hadolint/hadolint < Dockerfile

echo -e "\n=== Running app tests ===\n"
docker build -t "$1_test" --target test .

echo -e "\n=== Building the final image ===\n"
docker build -f Dockerfile -t "$1" .

echo -e "\n=== Scanning the image ===\n"
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -u root bitnami/trivy "$1"
