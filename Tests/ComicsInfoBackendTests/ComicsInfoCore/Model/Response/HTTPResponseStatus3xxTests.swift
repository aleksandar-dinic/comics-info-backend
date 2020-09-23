//
//  HTTPResponseStatus3xxTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 09/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class HTTPResponseStatus3xxTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testMultipleChoicesCode_IsEqual300() {
        // Given
        let sut = HTTPResponseStatus.multipleChoices

        // Then
        XCTAssertEqual(sut.code, 300)
    }

    func testMovedPermanentlyCode_IsEqual301() {
        // Given
        let sut = HTTPResponseStatus.movedPermanently

        // Then
        XCTAssertEqual(sut.code, 301)
    }

    func testFoundCode_IsEqual302() {
        // Given
        let sut = HTTPResponseStatus.found

        // Then
        XCTAssertEqual(sut.code, 302)
    }

    func testSeeOtherCode_IsEqual303() {
        // Given
        let sut = HTTPResponseStatus.seeOther

        // Then
        XCTAssertEqual(sut.code, 303)
    }

    func testNotModifiedCode_IsEqual304() {
        // Given
        let sut = HTTPResponseStatus.notModified

        // Then
        XCTAssertEqual(sut.code, 304)
    }

    func testUseProxyCode_IsEqual305() {
        // Given
        let sut = HTTPResponseStatus.useProxy

        // Then
        XCTAssertEqual(sut.code, 305)
    }

    func testTemporaryRedirectCode_IsEqual307() {
        // Given
        let sut = HTTPResponseStatus.temporaryRedirect

        // Then
        XCTAssertEqual(sut.code, 307)
    }

    func testPermanentRedirectCode_IsEqual308() {
        // Given
        let sut = HTTPResponseStatus.permanentRedirect

        // Then
        XCTAssertEqual(sut.code, 308)
    }

}
