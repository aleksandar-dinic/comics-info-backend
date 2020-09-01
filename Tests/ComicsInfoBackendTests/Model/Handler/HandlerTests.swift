//
//  HandlerTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 01/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class HandlerTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testHandler_whenInitializeWithInvalidRawValue_isNil() {
        // Given
        let rawValue = "invalid."

        // When
        let sut = Handler(rawValue: rawValue)

        // Then
        XCTAssertNil(sut)
    }

    func testHandler_whenInitializeWithInvalidRawValueHandler_isNil() {
        // Given
        let rawValue = "invalid.create"

        // When
        let sut = Handler(rawValue: rawValue)

        // Then
        XCTAssertNil(sut)
    }

    func testHandler_whenInitializeWithNilRawValue_isNil() {
        // Given
        let rawValue: String? = nil

        // When
        let sut = Handler(rawValue: rawValue)

        // Then
        XCTAssertNil(sut)
    }

}
