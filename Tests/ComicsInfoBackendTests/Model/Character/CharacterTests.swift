//
//  CharacterTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 01/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class CharacterTests: XCTestCase {

    private var thrownError: Error?

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
        thrownError = nil
    }

    func testCharacter_whenInitFromItems_IsNotNil() throws {
        // Given
        let items: [String: Any] = ["identifier": "1", "popularity": 0, "name": "Name"]

        // When
        let sut = try Character(from: items)

        // Then
        XCTAssertNotNil(sut)
    }

    func testCharacter_whenInitFromItemsWithoutIdentifier_throwKeyNotFound() {
        // Given
        let items: [String: Any] = ["popularity": 0, "name": "Name"]

        // When
        XCTAssertThrowsError(try Character(from: items)) {
            thrownError = $0
        }

        // Then
        XCTAssertEqual(thrownError as? APIError, .decodingError(.keyNotFound("identifier")))
    }

    func testCharacter_whenInitFromItemsWithoutPopularity_throwKeyNotFound() {
        // Given
        let items: [String: Any] = ["identifier": "1", "name": "Name"]

        // When
        XCTAssertThrowsError(try Character(from: items)) {
            thrownError = $0
        }

        // Then
        XCTAssertEqual(thrownError as? APIError, .decodingError(.keyNotFound("popularity")))
    }

    func testCharacter_whenInitFromItemsWithoutName_throwKeyNotFound() {
        // Given
        let items: [String: Any] = ["identifier": "1", "popularity": 0]

        // When
        XCTAssertThrowsError(try Character(from: items)) {
            thrownError = $0
        }

        // Then
        XCTAssertEqual(thrownError as? APIError, .decodingError(.keyNotFound("name")))
    }

    func testCharacter_whenInitFromItemsInvalidIdentifierType_throwTypeMismatch() {
        // Given
        let items: [String: Any] = ["identifier": 1, "popularity": 0, "name": "Name"]

        // When
        XCTAssertThrowsError(try Character(from: items)) {
            thrownError = $0
        }

        // Then
        XCTAssertEqual(
            thrownError as? APIError,
            .decodingError(.typeMismatch(forKey: "identifier"))
        )
    }

    func testCharacter_whenInitFromItemsInvalidPopularityType_throwTypeMismatch() {
        // Given
        let items: [String: Any] = ["identifier": "1", "popularity": "0", "name": "Name"]

        // When
        XCTAssertThrowsError(try Character(from: items)) {
            thrownError = $0
        }

        // Then
        XCTAssertEqual(
            thrownError as? APIError,
            .decodingError(.typeMismatch(forKey: "popularity"))
        )
    }

    func testCharacter_whenInitFromItemsInvalidNameType_throwTypeMismatch() {
        // Given
        let items: [String: Any] = ["identifier": "1", "popularity": 0, "name": 1]

        // When
        XCTAssertThrowsError(try Character(from: items)) {
            thrownError = $0
        }

        // Then
        XCTAssertEqual(
            thrownError as? APIError,
            .decodingError(.typeMismatch(forKey: "name"))
        )
    }

}
