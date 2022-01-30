// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ComicsInfoBackend",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(
            name: "ComicsInfoHandler",
            targets: ["ComicsInfoHandler"]
        )
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(
            name: "Domain",
            url: "https://github.com/AleksandarDinic/comics-info-domain.git",
            from: "0.5.1"
        ),
        .package(
            url: "https://github.com/swift-server/swift-aws-lambda-runtime.git",
            .exact("0.5.2")
        ),
        .package(
            url: "https://github.com/soto-project/soto.git",
            .exact("5.12.1")
        ),
        .package(
            url: "https://github.com/soto-project/soto-cognito-authentication-kit",
            .exact("3.2.2")
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a
        // test suite.
        // Targets can depend on other targets in this package, and on products in packages
        // which this package depends on.
        .executableTarget(
            name: "ComicsInfoHandler",
            dependencies: ["ComicsInfoCore"]
        ),
        .target(
            name: "ComicsInfoCore",
            dependencies: [
                .product(name: "Domain", package: "Domain"),
                .product(name: "SotoDynamoDB", package: "soto"),
                .product(name: "SotoSES", package: "soto"),
                .product(name: "AWSLambdaEvents", package: "swift-aws-lambda-runtime"),
                .product(name: "AWSLambdaRuntime", package: "swift-aws-lambda-runtime"),
                .product(name: "SotoCognitoAuthenticationKit", package: "soto-cognito-authentication-kit")
            ]),
        .testTarget(
            name: "ComicsInfoBackendTests",
            dependencies: ["ComicsInfoCore"]
        )
    ]
)
