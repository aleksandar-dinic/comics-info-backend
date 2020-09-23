//
//  HTTPResponseStatus2xxTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 09/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class HTTPResponseStatus2xxTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testOkCode_IsEqual200() {
        // Given
        let sut = HTTPResponseStatus.ok

        // Then
        XCTAssertEqual(sut.code, 200)
    }

    func testCreatedCode_IsEqual201() {
        // Given
        let sut = HTTPResponseStatus.created

        // Then
        XCTAssertEqual(sut.code, 201)
    }

    func testAcceptedCode_IsEqual202() {
        // Given
        let sut = HTTPResponseStatus.accepted

        // Then
        XCTAssertEqual(sut.code, 202)
    }

    func testNonAuthoritativeInformationCode_IsEqual203() {
        // Given
        let sut = HTTPResponseStatus.nonAuthoritativeInformation

        // Then
        XCTAssertEqual(sut.code, 203)
    }

    func testNoContentCode_IsEqual204() {
        // Given
        let sut = HTTPResponseStatus.noContent

        // Then
        XCTAssertEqual(sut.code, 204)
    }

    func testResetContentCode_IsEqual205() {
        // Given
        let sut = HTTPResponseStatus.resetContent

        // Then
        XCTAssertEqual(sut.code, 205)
    }

    func testPartialContentCode_IsEqual206() {
        // Given
        let sut = HTTPResponseStatus.partialContent

        // Then
        XCTAssertEqual(sut.code, 206)
    }

    func testMultiStatusCode_IsEqual207() {
        // Given
        let sut = HTTPResponseStatus.multiStatus

        // Then
        XCTAssertEqual(sut.code, 207)
    }

    func testAlreadyReportedCode_IsEqual208() {
        // Given
        let sut = HTTPResponseStatus.alreadyReported

        // Then
        XCTAssertEqual(sut.code, 208)
    }

    func testImUsedCode_IsEqual226() {
        // Given
        let sut = HTTPResponseStatus.imUsed

        // Then
        XCTAssertEqual(sut.code, 226)
    }

}
