//
//  LocalServerTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 20/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import CharacterInfo
import XCTest

final class LocalServerTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func test_isEnabledIsTrue() {
        // When
        _ = LocalServer()

        // Then
        XCTAssertFalse(LocalServer.isEnabled)
    }

    func test_isEnabledIsFalse() {
        // When
        _ = LocalServer(enabled: true)

        // Then
        XCTAssertTrue(LocalServer.isEnabled)
    }

}
