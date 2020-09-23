//
//  HTTPResponseStatus5xxTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 10/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class HTTPResponseStatus5xxTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testInternalServerErrorCode_IsEqual500() {
        // Given
        let sut = HTTPResponseStatus.internalServerError

        // Then
        XCTAssertEqual(sut.code, 500)
    }

    func testNotImplementedCode_IsEqual501() {
        // Given
        let sut = HTTPResponseStatus.notImplemented

        // Then
        XCTAssertEqual(sut.code, 501)
    }

    func testBadGatewayCode_IsEqual502() {
        // Given
        let sut = HTTPResponseStatus.badGateway

        // Then
        XCTAssertEqual(sut.code, 502)
    }

    func testServiceUnavailableCode_IsEqual503() {
        // Given
        let sut = HTTPResponseStatus.serviceUnavailable

        // Then
        XCTAssertEqual(sut.code, 503)
    }

    func testGatewayTimeoutCode_IsEqual504() {
        // Given
        let sut = HTTPResponseStatus.gatewayTimeout

        // Then
        XCTAssertEqual(sut.code, 504)
    }

    func testHttpVersionNotSupportedCode_IsEqual505() {
        // Given
        let sut = HTTPResponseStatus.httpVersionNotSupported

        // Then
        XCTAssertEqual(sut.code, 505)
    }

    func testVariantAlsoNegotiatesCode_IsEqual506() {
        // Given
        let sut = HTTPResponseStatus.variantAlsoNegotiates

        // Then
        XCTAssertEqual(sut.code, 506)
    }

    func testInsufficientStorageCode_IsEqual507() {
        // Given
        let sut = HTTPResponseStatus.insufficientStorage

        // Then
        XCTAssertEqual(sut.code, 507)
    }

    func testLoopDetectedCode_IsEqual508() {
        // Given
        let sut = HTTPResponseStatus.loopDetected

        // Then
        XCTAssertEqual(sut.code, 508)
    }

    func testNotExtendedCode_IsEqual510() {
        // Given
        let sut = HTTPResponseStatus.notExtended

        // Then
        XCTAssertEqual(sut.code, 510)
    }

    func testNetworkAuthenticationRequiredCode_IsEqual511() {
        // Given
        let sut = HTTPResponseStatus.networkAuthenticationRequired

        // Then
        XCTAssertEqual(sut.code, 511)
    }
    
}
