#!/bin/bash

docker-buildx create --name multiplatform-builder
docker-buildx use multiplatform-builder
docker-buildx inspect --bootstrap

# build for amd64 machine and push
# docker buildx build --platform linux/amd64 -t your-username/multiplatform-image:latest . --push
