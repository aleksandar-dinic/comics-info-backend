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

DIR="$(cd "$(dirname "$0")" && pwd)"
source $DIR/config.sh

workspace="$DIR/../.."

echo -e "\ndeploying $executable"

$DIR/build-and-package.sh "$executable"

echo "-------------------------------------------------------------------------"
echo "uploading \"$executable\" lambda to AWS S3"
echo "-------------------------------------------------------------------------"

#read -p "S3 bucket name to upload zip file (must exist in AWS S3): " s3_bucket
s3_bucket=${s3_bucket:-comics-info-backend} # default for easy testing

aws s3 cp ".build/lambda/$executable/lambda.zip" "s3://$s3_bucket/"

echo "-------------------------------------------------------------------------"
echo "updating AWS Lambda to use \"$executable\""
echo "-------------------------------------------------------------------------"

#read -p "Lambda Function name (must exist in AWS Lambda): " lambda_name

echo "-------------------------------------------------------------------------"
echo "updating ci-character AWS Lambda to use \"$executable\""
echo "-------------------------------------------------------------------------"
aws lambda update-function-code \
    --function "${lambda_name:-ci-character-create}" \
    --s3-bucket "$s3_bucket" \
    --s3-key lambda.zip
    
aws lambda update-function-code \
    --function "${lambda_name:-ci-character-read}" \
    --s3-bucket "$s3_bucket" \
    --s3-key lambda.zip
        
aws lambda update-function-code \
    --function "${lambda_name:-ci-character-list}" \
    --s3-bucket "$s3_bucket" \
    --s3-key lambda.zip

aws lambda update-function-code \
    --function "${lambda_name:-ci-character-update}" \
    --s3-bucket "$s3_bucket" \
    --s3-key lambda.zip

aws lambda update-function-code \
    --function "${lambda_name:-ci-character-delete}" \
    --s3-bucket "$s3_bucket" \
    --s3-key lambda.zip
    
echo "-------------------------------------------------------------------------"
echo "updating ci-series AWS Lambda to use \"$executable\""
echo "-------------------------------------------------------------------------"
aws lambda update-function-code \
    --function "${lambda_name:-ci-series-create}" \
    --s3-bucket "$s3_bucket" \
    --s3-key lambda.zip
    
aws lambda update-function-code \
    --function "${lambda_name:-ci-series-read}" \
    --s3-bucket "$s3_bucket" \
    --s3-key lambda.zip
        
aws lambda update-function-code \
    --function "${lambda_name:-ci-series-list}" \
    --s3-bucket "$s3_bucket" \
    --s3-key lambda.zip

aws lambda update-function-code \
    --function "${lambda_name:-ci-series-update}" \
    --s3-bucket "$s3_bucket" \
    --s3-key lambda.zip

aws lambda update-function-code \
    --function "${lambda_name:-ci-series-delete}" \
    --s3-bucket "$s3_bucket" \
    --s3-key lambda.zip
    
echo "-------------------------------------------------------------------------"
echo "updating ci-comic AWS Lambda to use \"$executable\""
echo "-------------------------------------------------------------------------"
aws lambda update-function-code \
    --function "${lambda_name:-ci-comic-create}" \
    --s3-bucket "$s3_bucket" \
    --s3-key lambda.zip
    
aws lambda update-function-code \
    --function "${lambda_name:-ci-comic-read}" \
    --s3-bucket "$s3_bucket" \
    --s3-key lambda.zip
        
aws lambda update-function-code \
    --function "${lambda_name:-ci-comic-list}" \
    --s3-bucket "$s3_bucket" \
    --s3-key lambda.zip

aws lambda update-function-code \
    --function "${lambda_name:-ci-comic-update}" \
    --s3-bucket "$s3_bucket" \
    --s3-key lambda.zip

aws lambda update-function-code \
    --function "${lambda_name:-ci-comic-delete}" \
    --s3-bucket "$s3_bucket" \
    --s3-key lambda.zip

echo "-------------------------------------------------------------------------"
echo "updating ci-feedback AWS Lambda to use \"$executable\""
echo "-------------------------------------------------------------------------"
aws lambda update-function-code \
    --function "${lambda_name:-ci-feedback-create}" \
    --s3-bucket "$s3_bucket" \
    --s3-key lambda.zip

echo "-------------------------------------------------------------------------"
echo "updating ci-my-characters AWS Lambda to use \"$executable\""
echo "-------------------------------------------------------------------------"
aws lambda update-function-code \
    --function "${lambda_name:-ci-my-characters-create}" \
    --s3-bucket "$s3_bucket" \
    --s3-key lambda.zip

aws lambda update-function-code \
    --function "${lambda_name:-ci-my-characters-read}" \
    --s3-bucket "$s3_bucket" \
    --s3-key lambda.zip

aws lambda update-function-code \
    --function "${lambda_name:-ci-my-characters-list}" \
    --s3-bucket "$s3_bucket" \
    --s3-key lambda.zip

aws lambda update-function-code \
    --function "${lambda_name:-ci-my-characters-update}" \
    --s3-bucket "$s3_bucket" \
    --s3-key lambda.zip

aws lambda update-function-code \
    --function "${lambda_name:-ci-my-characters-delete}" \
    --s3-bucket "$s3_bucket" \
    --s3-key lambda.zip
    
echo "-------------------------------------------------------------------------"
echo "updating ci-my-comics AWS Lambda to use \"$executable\""
echo "-------------------------------------------------------------------------"
aws lambda update-function-code \
    --function "${lambda_name:-ci-my-comics-create}" \
    --s3-bucket "$s3_bucket" \
    --s3-key lambda.zip

aws lambda update-function-code \
    --function "${lambda_name:-ci-my-comics-read}" \
    --s3-bucket "$s3_bucket" \
    --s3-key lambda.zip

aws lambda update-function-code \
    --function "${lambda_name:-ci-my-comics-list}" \
    --s3-bucket "$s3_bucket" \
    --s3-key lambda.zip

aws lambda update-function-code \
    --function "${lambda_name:-ci-my-comics-update}" \
    --s3-bucket "$s3_bucket" \
    --s3-key lambda.zip

aws lambda update-function-code \
    --function "${lambda_name:-ci-my-comics-delete}" \
    --s3-bucket "$s3_bucket" \
    --s3-key lambda.zip
