//
//  HTTPResponseStatus1xxTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 09/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class HTTPResponseStatus1xxTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testContinueCode_IsEqual100() {
        // Given
        let sut = HTTPResponseStatus.continue

        // Then
        XCTAssertEqual(sut.code, 100)
    }

    func testSwitchingProtocolsCode_IsEqual101() {
        // Given
        let sut = HTTPResponseStatus.switchingProtocols

        // Then
        XCTAssertEqual(sut.code, 101)
    }

    func testProcessingCode_IsEqual102() {
        // Given
        let sut = HTTPResponseStatus.processing

        // Then
        XCTAssertEqual(sut.code, 102)
    }

    func testEarlyHintsCode_IsEqual103() {
        // Given
        let sut = HTTPResponseStatus.earlyHints

        // Then
        XCTAssertEqual(sut.code, 103)
    }

}
