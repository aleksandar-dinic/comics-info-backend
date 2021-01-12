// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ComicsInfoBackend",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .executable(
            name: "CharacterHandler",
            targets: ["CharacterHandler"]
        ),
        .executable(
            name: "ComicHandler",
            targets: ["ComicHandler"]
        ),
        .executable(
            name: "SeriesHandler",
            targets: ["SeriesHandler"]
        )
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(
            name: "Domain",
            url: "https://github.com/AleksandarDinic/comics-info-domain.git",
            from: "0.1.0"
        ),
        .package(
            url: "https://github.com/swift-server/swift-aws-lambda-runtime.git",
            .upToNextMajor(from:"0.2.0")
        ),
        .package(
            url: "https://github.com/soto-project/soto.git",
            from: "5.1.0"
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a
        // test suite.
        // Targets can depend on other targets in this package, and on products in packages
        // which this package depends on.
        .target(
            name: "CharacterHandler",
            dependencies: ["CharacterInfo", "ComicsInfoCore"]
        ),
        .target(
            name: "ComicHandler",
            dependencies: ["ComicInfo", "ComicsInfoCore"]
        ),
        .target(
            name: "SeriesHandler",
            dependencies: ["SeriesInfo", "ComicsInfoCore"]
        ),
        .target(
            name: "CharacterInfo",
            dependencies: [
                .target(name: "ComicsInfoCore"),
                .product(name: "Domain", package: "Domain"),
                .product(name: "SotoDynamoDB", package: "soto"),
                .product(name: "AWSLambdaEvents", package: "swift-aws-lambda-runtime"),
                .product(name: "AWSLambdaRuntime", package: "swift-aws-lambda-runtime")
            ]),
        .target(
            name: "ComicInfo",
            dependencies: [
                .target(name: "ComicsInfoCore"),
                .product(name: "Domain", package: "Domain"),
                .product(name: "SotoDynamoDB", package: "soto"),
                .product(name: "AWSLambdaEvents", package: "swift-aws-lambda-runtime"),
                .product(name: "AWSLambdaRuntime", package: "swift-aws-lambda-runtime")
            ]),
        .target(
            name: "SeriesInfo",
            dependencies: [
                .target(name: "ComicsInfoCore"),
                .product(name: "Domain", package: "Domain"),
                .product(name: "SotoDynamoDB", package: "soto"),
                .product(name: "AWSLambdaEvents", package: "swift-aws-lambda-runtime"),
                .product(name: "AWSLambdaRuntime", package: "swift-aws-lambda-runtime")
            ]),
        .target(
            name: "ComicsInfoCore",
            dependencies: [
                .product(name: "Domain", package: "Domain"),
                .product(name: "SotoDynamoDB", package: "soto"),
                .product(name: "AWSLambdaEvents", package: "swift-aws-lambda-runtime"),
                .product(name: "AWSLambdaRuntime", package: "swift-aws-lambda-runtime")
            ]),
        .testTarget(
            name: "ComicsInfoBackendTests",
            dependencies: ["CharacterInfo", "ComicsInfoCore"]
        )
    ]
)
