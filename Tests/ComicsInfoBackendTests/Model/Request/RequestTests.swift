//
//  RequestTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 10/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import AWSLambdaEvents
@testable import ComicsInfoCore
import XCTest

final class RequestTests: XCTestCase {

    private var apiGatewayV2Request: APIGateway.V2.Request!
    private var sut: Request!

    override func setUpWithError() throws {
        apiGatewayV2Request = makeAPIGatewayV2Request()
        sut = Request(from: apiGatewayV2Request)
    }

    override func tearDownWithError() throws {
        apiGatewayV2Request = nil
        sut = nil
    }

    func testRequestPathParameters_whenInitializeFromAPIGatewayV2Request_isEqualPathParameters() throws {
        XCTAssertEqual(sut.pathParameters, apiGatewayV2Request.pathParameters)
    }

}

extension RequestTests {

    private func makeAPIGatewayV2Request(
        pathParameters: [String: String] = ["Key": "Value"]
    ) -> APIGateway.V2.Request {
        APIGateway.V2.Request(
            version: "",
            routeKey: "",
            rawPath: "",
            rawQueryString: "",
            cookies: nil,
            headers: [:],
            queryStringParameters: nil,
            pathParameters: pathParameters,
            context: makeAPIGatewayV2RequestContext(),
            stageVariables: nil,
            body: nil,
            isBase64Encoded: false
        )
    }

    private func makeAPIGatewayV2RequestContext() -> APIGateway.V2.Request.Context {
        APIGateway.V2.Request.Context(
            accountId: "",
            apiId: "",
            domainName: "",
            domainPrefix: "",
            stage: "",
            requestId: "",
            http: makeAPIGatewayV2RequestContextHTTP(),
            authorizer: nil,
            time: "",
            timeEpoch: 0
        )
    }

    private func makeAPIGatewayV2RequestContextHTTP(
        method: AWSLambdaEvents.HTTPMethod = .GET
    ) -> APIGateway.V2.Request.Context.HTTP {
        APIGateway.V2.Request.Context.HTTP(
            method: method,
            path: "",
            protocol: "",
            sourceIp: "",
            userAgent: ""
        )
    }

}
