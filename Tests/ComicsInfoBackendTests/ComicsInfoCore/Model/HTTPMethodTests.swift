//
//  HTTPMethodTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 10/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class HTTPMethodTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testHTTPMethodGETRawValue_isEqualGET() {
        // Given
        let sut = HTTPMethod.GET

        // Then
        XCTAssertEqual(sut.rawValue, "GET")
    }

    func testHTTPMethodPOSTRawValue_isEqualPOST() {
        // Given
        let sut = HTTPMethod.POST

        // Then
        XCTAssertEqual(sut.rawValue, "POST")
    }

    func testHTTPMethodPUTRawValue_isEqualPUT() {
        // Given
        let sut = HTTPMethod.PUT

        // Then
        XCTAssertEqual(sut.rawValue, "PUT")
    }

    func testHTTPMethodPATCHRawValue_isEqualPATCH() {
        // Given
        let sut = HTTPMethod.PATCH

        // Then
        XCTAssertEqual(sut.rawValue, "PATCH")
    }

    func testHTTPMethodDELETERawValue_isEqualDELETE() {
        // Given
        let sut = HTTPMethod.DELETE

        // Then
        XCTAssertEqual(sut.rawValue, "DELETE")
    }

    func testHTTPMethodOPTIONSRawValue_isEqualOPTIONS() {
        // Given
        let sut = HTTPMethod.OPTIONS

        // Then
        XCTAssertEqual(sut.rawValue, "OPTIONS")
    }

    func testHTTPMethodHEADRawValue_isEqualHEAD() {
        // Given
        let sut = HTTPMethod.HEAD

        // Then
        XCTAssertEqual(sut.rawValue, "HEAD")
    }

}
