# Comics Info backend

<p align="center">
    <img src="https://img.shields.io/badge/Swift-5.2-orange.svg" alt="Swift 5.2"/>
    <img src="https://img.shields.io/badge/docker-Amazon Linux 2-blue.svg" alt="Docker" />
</p>

The backend part of the [Comics Info app](https://github.com/AleksandarDinic/comics-info). This app is responsible for storing, organizing, and managing data so that the client, [Comics Info app](https://github.com/AleksandarDinic/comics-info), can use it. The basic idea is to create [Swift](https://swift.org) Serverless REST API with [Amazon Web Services (AWS)](https://aws.amazon.com).

## Serverless architecture

This app uses [serverless architecture](https://martinfowler.com/articles/serverless.html) based on AWS. There are a lot of benefits of serverless architecture but the crucial one for this app is that we can focus just on our app and let AWS think about the underlying infrastructure (machines, VMs, containers, etc.).

We will need a couple of services from Amazon:

- **API Gateway**: A service that makes it easy to create, publish, maintain, monitor, and secure APIs. API Gateway will act as the single point of entry to our Lambda functions.
- **Lambda**: Let us run code without provisioning or managing servers. We pay only for the compute time our lambda consumes. The idea is to define a lambda for each API endpoint.
- **DynamoDB**: NoSQL database service that supports key-value and document data structure.

<img src=".github/assets/API gateway AWS Lambda DynamoDB.png">

## Requirements

- **Swift**: https://swift.org/download/
- **Docker**: https://docs.docker.com/docker-for-mac/install/
- **Amazon Web Service** account: https://aws.amazon.com 
- **AWS CLI**: https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-mac.html

## Getting started

Create a directory and open it.
``` bash
$ mkdir ComicsInfoBackend
$ cd ComicsInfoBackend
```
Create a new Swift project with the Swift Package Manager.
``` bash
$ swift package init --type executable
```

The first thing that we need to do is to add a dependency to [Swift AWS Lambda Runtime](https://github.com/swift-server/swift-aws-lambda-runtime). With that in place, we can handle the communication with the [Lambda Runtime Interface](https://docs.aws.amazon.com/lambda/latest/dg/runtimes-api.html). One more dependency that we need is [Swift AWS SDK](https://github.com/swift-aws/aws-sdk-swift) which provides native Swift API for us to interact with DynamoDB. In `Package.swift` in the `dependencies` section add the next line:

``` swift
.package(url: "https://github.com/swift-server/swift-aws-lambda-runtime.git", .upToNextMajor(from:"0.2.0")),
.package(url: "https://github.com/soto-project/soto.git", .upToNextMinor(from: "5.0.0-beta.1"))
```

After this, we also need to add the target’s dependencies:

``` swift
.product(name: "SotoDynamoDB", package: "soto"),
.product(name: "AWSLambdaRuntime", package: "swift-aws-lambda-runtime")
```

### Develop Lambda

In `main.swift` we can run our Lambda:
``` swift
import AWSLambdaRuntime

Lambda.run(ComicsInfoLambdaHandler.init)
```

`ComicsInfoLambdaHandler` is our dedicated struct who can handle all incoming requests.

``` swift
import AWSLambdaRuntime
import NIO

struct ComicsInfoLambdaHandler: EventLoopLambdaHandler {

    typealias In = Request
    typealias Out = Response

    private let database: Database

    init(context: Lambda.InitializationContext) {
        database = DatabaseFectory().makeDatabase(eventLoop: context.eventLoop)
    }

    func handle(
        context: Lambda.Context,
        event: Request
    ) -> EventLoopFuture<Response> {
        let handler = getHandler(for: event.context.http)

        switch handler {
        case let .characters(action):
            let provider = CharacterLambdaProvider(database: database, action: action)
            return provider.handle(on: context.eventLoop, event: event)

        case .series, .comics:
            let response = Response(statusCode: .notImplemented)
            return context.eventLoop.makeSucceededFuture(response)

        case .none:
            let response = Response(statusCode: .notFound)
            return context.eventLoop.makeSucceededFuture(response)
        }
    }

    private func getHandler(for http: HTTP) -> Handler? {
        HandlerFectory().makeHandler(
            path: http.path,
            method: HTTPMethod(rawValue: http.method.rawValue)
        )
    }

}
```

We can easily initialize `DynamoDB` but we can't easily write tests and run code locally with `DynamoDB`. Instead of initializing `DynamoDB` we will delegate that job to `DatabaseFectory` and if we are testing our code `DatabaseFectory` will make `DatabaseMock` for us, otherwise it will make `DynamoDB`.

The same principle suits `Handler`. `Lambda.env("_HANDLER")` returns the handler variable, but when we run code locally or in testing, this variable is nil. `HandlerFectory` helps us that we always get the correct handler.

`CharacterLambdaProvider` is the starting point where all the fun begins for our characters lambda. Series and Comics have not implemented yet, so we will leave it for later.

### Test Lambda locally

For testing lambda locally we need to add the environment variable `LOCAL_LAMBDA_SERVER_ENABLED` with the value `true` in the target build settings.

<img src=".github/assets/Add the environment variable LOCAL_LAMBDA.png">

When we compile and run our Lambda with Xcode we can see output like this in the console:

```console
2020-09-11T11:38:24+0200 info LocalLambdaServer : LocalLambdaServer started and listening on 127.0.0.1:7000, receiving events on /invoke
2020-09-11T11:38:24+0200 info Lambda : lambda lifecycle starting with Configuration
  General(logLevel: info))
  Lifecycle(id: 555917154204568, maxTimes: 0, stopSignal: TERM)
  RuntimeEngine(ip: 127.0.0.1, port: 7000, keepAlive: true, requestTimeout: nil
```

Now we are able to invoke Lambda simply by calling:

```bash
$ curl -i http://localhost:7000/invoke
```

The response looks like this:

```console
HTTP/1.1 404 Not Found
content-length: 0
```

Not exactly what we expected, but we will get there. The important thing at this moment is that our Lambda is running locally.

### Build code for the AWS Lambda Environment

Lambda will be executed on the Amazon Linux operating system. Because of that, we need to compile our code for this environment. To achieve this, we use Docker. Create a file to package at the root level called `Dockerfile` with the following content:

``` docker
 FROM swiftlang/swift:nightly-amazonlinux2
  
 RUN yum -y install \
     git \
     libuuid-devel \
     libicu-devel \
     libedit-devel \
     libxml2-devel \
     sqlite-devel \
     python-devel \
     ncurses-devel \
     curl-devel \
     openssl-devel \
     tzdata \
     libtool \
     jq \
     tar \
     zip

```

This will use the Swift Nightly image for Amazon Linux 2 from the SwiftLang docker repository, then add the required dependencies to build and run Swift. With this set, we can build and package our lambda for deployment on AWS Lambda with the following script.

```bash
$ ./scripts/build-and-package.sh
```

⚠️ Don't forget to set the file as executable using:

``` bash
$ chmod +x scripts/build-and-package.sh
```

More details about Swift on AWS Lambda you can find on the next link:

> https://fabianfett.de/getting-started-with-swift-aws-lambda-runtime.

### Deploy Lambda using AWS CLI

To install the AWS CLI we can run the next line:
``` bash
$ brew install awscli
```

To use the next script we also need to set up the AWS credentials in the user directory `~/.aws/credentials`. 
``` bash
$ ./scripts/deploy.sh
```

This script will build and package your lambda first, upload our code to the S3 bucket and update Lambda. Lambda and the S3 bucket must exist on AWS before running this script.

More information you can find on the next link:

> https://github.com/swift-server/swift-aws-lambda-runtime/blob/main/Examples/LambdaFunctions/README.md#deployment-instructions-using-aws-cli

To test `GET` request to `/characters/{identifier}` type:
``` bash
$ curl https://{gatewayid}.execute-api.{region}.amazonaws.com/characters/{identifier}
```

For `identifier` 1 in the database, we have a character with the name `Spider-Man`, and the response is:
``` json
{ "identifier":"1", "popularity":0, "name":"Spider-Man" }
```

Test `GET` request to `/characters`:
``` bash
$ curl https://{gatewayid}.execute-api.{region}.amazonaws.com/characters
```

If we have characters `Spider-Man` and `Captain America` in the database, the response will be:
``` json
[
    { "identifier":"1", "popularity":0, "name":"Spider-Man"},
    { "identifier":"2", "popularity":1, "name":"Captain America" }
]
```

## 📃 License

MIT License

Copyright (c) 2020 Aleksandar Dinic

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
