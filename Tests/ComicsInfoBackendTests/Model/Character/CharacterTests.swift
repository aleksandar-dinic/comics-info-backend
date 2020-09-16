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

    func testCharacter_whenInitFromItemsWithoutIdentifier_throwKeyNotFound() throws {
        // Given
        let items: [String: Any] = ["popularity": 0, "name": "Name"]

        // When
        XCTAssertThrowsError(try Character(from: items)) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .keyNotFound(let key, _) = error as? DecodingError {
            XCTAssertEqual(Character.CodingKeys.identifier.stringValue, key.stringValue)
        } else {
            XCTFail("Expected '.keyNotFound' but got \(error)")
        }
    }

    func testCharacter_whenInitFromItemsWithoutPopularity_throwKeyNotFound() throws {
        // Given
        let items: [String: Any] = ["identifier": "1", "name": "Name"]

        // When
        XCTAssertThrowsError(try Character(from: items)) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .keyNotFound(let key, _) = error as? DecodingError {
            XCTAssertEqual(Character.CodingKeys.popularity.stringValue, key.stringValue)
        } else {
            XCTFail("Expected '.keyNotFound' but got \(error)")
        }
    }

    func testCharacter_whenInitFromItemsWithoutName_throwKeyNotFound() throws {
        // Given
        let items: [String: Any] = ["identifier": "1", "popularity": 0]

        // When
        XCTAssertThrowsError(try Character(from: items)) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .keyNotFound(let key, _) = error as? DecodingError {
            XCTAssertEqual(Character.CodingKeys.name.stringValue, key.stringValue)
        } else {
            XCTFail("Expected '.keyNotFound' but got \(error)")
        }
    }

    func testCharacter_whenInitFromItemsInvalidIdentifierType_throwTypeMismatch() throws {
        // Given
        let items: [String: Any] = ["identifier": 1, "popularity": 0, "name": "Name"]

        // When
        XCTAssertThrowsError(try Character(from: items)) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .typeMismatch(let key, _) = error as? DecodingError {
            XCTAssertTrue(key == String.self)
        } else {
            XCTFail("Expected '.typeMismatch' but got \(error)")
        }
    }

    func testCharacter_whenInitFromItemsInvalidPopularityType_throwTypeMismatch() throws {
        // Given
        let items: [String: Any] = ["identifier": "1", "popularity": "0", "name": "Name"]

        // When
        XCTAssertThrowsError(try Character(from: items)) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .typeMismatch(let key, _) = error as? DecodingError {
            XCTAssertTrue(key == Int.self)
        } else {
            XCTFail("Expected '.typeMismatch' but got \(error)")
        }

    }

    func testCharacter_whenInitFromItemsInvalidNameType_throwTypeMismatch() throws {
        // Given
        let items: [String: Any] = ["identifier": "1", "popularity": 0, "name": 1]

        // When
        XCTAssertThrowsError(try Character(from: items)) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .typeMismatch(let key, _) = error as? DecodingError {
            XCTAssertTrue(key == String.self)
        } else {
            XCTFail("Expected '.typeMismatch' but got \(error)")
        }

    }

}
