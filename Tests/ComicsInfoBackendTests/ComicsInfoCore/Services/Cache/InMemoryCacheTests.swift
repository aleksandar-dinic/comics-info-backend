//
//  InMemoryCacheTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 16/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class InMemoryCacheTests: XCTestCase {

    private var sut: InMemoryCache<String, String>!

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testIsEmpty_whenDefaultInit_isTrue() {
        // When
        sut = InMemoryCache<String, String>()

        // Then
        XCTAssertTrue(sut.isEmpty)
    }

    func testIsEmpty_whenInitWithData_isFalse() {
        // Given
        let data = ["Character1": "Character 1 Name", "Character2": "Character 2 Name"]

        // When
        sut = InMemoryCache<String, String>(storage: data)

        // Then
        XCTAssertFalse(sut.isEmpty)
    }

    func testValues_whenInitWithData_isEqualToGivenValues() {
        // Given
        let data = ["Character1": "Character 1 Name", "Character2": "Character 2 Name"]

        // When
        sut = InMemoryCache<String, String>(storage: data)

        // Then
        XCTAssertEqual(sut.values, Array(data.values))
    }

}
