#!/bin/bash
##===----------------------------------------------------------------------===##
##
## This source file is part of the SwiftAWSLambdaRuntime open source project
##
## Copyright (c) 2020 Apple Inc. and the SwiftAWSLambdaRuntime project authors
## Licensed under Apache License v2.0
##
##===----------------------------------------------------------------------===##

set -eu

executable=$1
workspace="$(pwd)/"

echo "-------------------------------------------------------------------------"
echo "preparing docker build image"
echo "-------------------------------------------------------------------------"
docker build -t swift-lambda-builder .
echo "done"

echo "-------------------------------------------------------------------------"
echo "building \"$executable\" lambda"
echo "-------------------------------------------------------------------------"
docker run \
        --rm \
        -v "$workspace":/src \
        -w /src swift-lambda-builder \
       bash -cl "swift build --product $executable -c release"
echo "done"

echo "-------------------------------------------------------------------------"
echo "packaging \"$executable\" lambda"
echo "-------------------------------------------------------------------------"
docker run \
        --rm \
        -v "$workspace":/src \
        -w /src swift-lambda-builder \
       bash -cl "./scripts/package.sh $executable"
echo "done"
