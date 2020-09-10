//
//  Response+ExtensionsTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 09/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
@testable import AWSLambdaEvents
import XCTest

final class Response_ExtensionsTests: XCTestCase {

    private var response: Response!
    private var sut: APIGateway.V2.Response!

    override func setUpWithError() throws {
        response = Response(
            statusCode: .ok,
            headers: ["Key": "Value"],
            multiValueHeaders: ["Key": ["Value"]],
            body: "Body",
            isBase64Encoded: false,
            cookies: ["Cookies"]
        )
        sut = APIGateway.V2.Response(with: response)
    }

    override func tearDownWithError() throws {
        response = nil
        sut = nil
    }

    func testResponseStatusCode_IsEqualToAPIGatewayV2ResponseStatusCode() {
        XCTAssertEqual(response.statusCode.code, sut.statusCode.code)
    }

    func testResponseHeaders_IsEqualToAPIGatewayV2ResponseHeaders() {
        XCTAssertEqual(response.headers, sut.headers)
    }

    func testResponseMultiValueHeaders_IsEqualToAPIGatewayV2ResponseMultiValueHeaders() {
        XCTAssertEqual(response.multiValueHeaders, sut.multiValueHeaders)
    }

    func testResponseBody_IsEqualToAPIGatewayV2ResponseBody() {
        XCTAssertEqual(response.body, sut.body)
    }

    func testResponseIsBase64Encoded_IsEqualToAPIGatewayV2ResponseIsBase64Encoded() {
        XCTAssertEqual(response.isBase64Encoded, sut.isBase64Encoded)
    }

    func testResponseCookies_IsEqualToAPIGatewayV2ResponseCookies() {
        XCTAssertEqual(response.cookies, sut.cookies)
    }

}
