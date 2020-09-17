// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ComicsInfoBackend",
    platforms: [
        .macOS(.v10_14)
    ],
    products: [
        .executable(name: "CharacterListHandler", targets: ["CharacterListHandler"]),
        .executable(name: "CharacterReadHandler", targets: ["CharacterReadHandler"]),
        .executable(name: "ComicListHandler", targets: ["ComicListHandler"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(
            name: "Domain",
            url: "https://github.com/AleksandarDinic/comics-info-domain.git",
            from: "0.0.1"
        ),
        .package(
            url: "https://github.com/swift-server/swift-aws-lambda-runtime.git",
            .upToNextMajor(from:"0.2.0")
        ),
        .package(
            url: "https://github.com/swift-aws/aws-sdk-swift.git",
            from: "5.0.0-alpha.4"
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a
        // test suite.
        // Targets can depend on other targets in this package, and on products in packages
        // which this package depends on.
        .target(name: "CharacterListHandler", dependencies: ["CharacterInfo", "ComicsInfoCore"]),
        .target(name: "CharacterReadHandler", dependencies: ["CharacterInfo", "ComicsInfoCore"]),
        .target(name: "ComicListHandler", dependencies: ["ComicsInfoCore"]),
        .target(
            name: "CharacterInfo",
            dependencies: [
                .product(name: "Domain", package: "Domain"),
                .product(name: "AWSDynamoDB", package: "aws-sdk-swift"),
                .product(name: "AWSLambdaRuntime", package: "swift-aws-lambda-runtime")
            ]),
        .target(
            name: "ComicsInfoCore",
            dependencies: [
                .product(name: "Domain", package: "Domain"),
                .product(name: "AWSDynamoDB", package: "aws-sdk-swift"),
                .product(name: "AWSLambdaRuntime", package: "swift-aws-lambda-runtime")
            ]),
        .testTarget(
            name: "ComicsInfoBackendTests",
            dependencies: [
                "CharacterInfo",
                "ComicsInfoCore"
            ])
    ]
)
