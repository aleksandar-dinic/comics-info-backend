//
//  APIGatewayV2ResponseTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 18/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import AWSLambdaEvents
@testable import ComicsInfoCore
import XCTest

final class APIGatewayV2ResponseTests: XCTestCase {

    private var apiGatewayV2Response: APIGateway.V2.Response!
    private var response: Response!

    override func setUpWithError() throws {
        response = Response(
            statusCode: .ok,
            headers: ["Key": "Value"],
            multiValueHeaders: ["Key": ["Value"]],
            body: "body",
            isBase64Encoded: false,
            cookies: ["🍪"]
        )
        apiGatewayV2Response = APIGateway.V2.Response(from: response)
    }

    override func tearDownWithError() throws {
        apiGatewayV2Response = nil
        response = nil
    }

    func testAPIGatewayV2Response_whenInitFromResponse_statusCodeIsEqual() {
        XCTAssertEqual(apiGatewayV2Response.statusCode.code, response.statusCode.code)
    }

    func testAPIGatewayV2Response_whenInitFromResponse_headersIsEqual() {
        XCTAssertEqual(apiGatewayV2Response.headers, response.headers)
    }

    func testAPIGatewayV2Response_whenInitFromResponse_multiValueHeadersIsEqual() {
        XCTAssertEqual(apiGatewayV2Response.multiValueHeaders, response.multiValueHeaders)
    }

    func testAPIGatewayV2Response_whenInitFromResponse_bodyIsEqual() {
        XCTAssertEqual(apiGatewayV2Response.body, response.body)
    }

    func testAPIGatewayV2Response_whenInitFromResponse_isBase64EncodedIsEqual() {
        XCTAssertEqual(apiGatewayV2Response.isBase64Encoded, response.isBase64Encoded)
    }

    func testAPIGatewayV2Response_whenInitFromResponse_cookiesIsEqual() {
        XCTAssertEqual(apiGatewayV2Response.cookies, response.cookies)
    }

}
