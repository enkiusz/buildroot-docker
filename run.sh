#!/bin/sh

mkdir -p output

docker run -v $PWD/output:/output buildroot:2022.02 "$@"
