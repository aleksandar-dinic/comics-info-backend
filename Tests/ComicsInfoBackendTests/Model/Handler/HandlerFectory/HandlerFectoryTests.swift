//
//  HandlerFectoryTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 01/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class HandlerFectoryTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testMakeHandler_whenIsNotMocked_isNil() {
        // Given
        let sut = HandlerFectory(mocked: false)

        // When
        let handler = sut.makeHandler(path: "/characters", method: .GET)

        // Then
        XCTAssertNil(handler)
    }

    func testMakeHandler_whenPathIsInvalid_isNil() {
        // Given
        let sut = HandlerFectory(mocked: true)

        // When
        let handler = sut.makeHandler(path: "invalid", method: .GET)

        // Then
        XCTAssertNil(handler)
    }

}
