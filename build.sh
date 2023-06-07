#!/bin/sh

# Long Term Support version
buildroot_branch=2022.02

docker build --build-arg buildroot_branch=$buildroot_branch -t buildroot:$buildroot_branch .

