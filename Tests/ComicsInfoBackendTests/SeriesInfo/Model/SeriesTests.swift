//
//  SeriesTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import SeriesInfo
import XCTest

final class SeriesTests: XCTestCase {

    private var thrownError: Error?

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
        thrownError = nil
    }

    func testSeries_whenInitFromItems_isNotNil() throws {
        // Given
        let items: [String: Any] = [
            "identifier": "1",
            "popularity": 0,
            "title": "Title",
            "charactersID": Set<String>(arrayLiteral: "1", "2")
        ]

        // When
        let sut = try Series(from: items)

        // Then
        XCTAssertNotNil(sut)
    }

    func testSeries_whenInitFromItemsWithoutIdentifier_throwKeyNotFound() throws {
        // Given
        let items: [String: Any] = [
            "popularity": 0,
            "title": "Title",
            "charactersID": Set<String>(arrayLiteral: "1", "2")
        ]

        // When
        XCTAssertThrowsError(try Series(from: items)) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .keyNotFound(let key, _) = error as? DecodingError {
            XCTAssertEqual(Series.CodingKeys.identifier.stringValue, key.stringValue)
        } else {
            XCTFail("Expected '.keyNotFound' but got \(error)")
        }
    }

    func testSeries_whenInitFromItemsWithoutPopularity_throwKeyNotFound() throws {
        // Given
        let items: [String: Any] = [
            "identifier": "1",
            "title": "Title",
            "charactersID": Set<String>(arrayLiteral: "1", "2")
        ]

        // When
        XCTAssertThrowsError(try Series(from: items)) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .keyNotFound(let key, _) = error as? DecodingError {
            XCTAssertEqual(Series.CodingKeys.popularity.stringValue, key.stringValue)
        } else {
            XCTFail("Expected '.keyNotFound' but got \(error)")
        }
    }

    func testSeries_whenInitFromItemsWithoutTitle_throwKeyNotFound() throws {
        // Given
        let items: [String: Any] = [
            "identifier": "1",
            "popularity": 0,
            "charactersID": Set<String>(arrayLiteral: "1", "2")
        ]

        // When
        XCTAssertThrowsError(try Series(from: items)) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .keyNotFound(let key, _) = error as? DecodingError {
            XCTAssertEqual(Series.CodingKeys.title.stringValue, key.stringValue)
        } else {
            XCTFail("Expected '.keyNotFound' but got \(error)")
        }
    }

    func testSeries_whenInitFromItemsWithoutCharactersID_throwKeyNotFound() throws {
        // Given
        let items: [String: Any] = [
            "identifier": "1",
            "popularity": 0,
            "title": "Title"
        ]

        // When
        XCTAssertThrowsError(try Series(from: items)) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .keyNotFound(let key, _) = error as? DecodingError {
            XCTAssertEqual(Series.CodingKeys.charactersID.stringValue, key.stringValue)
        } else {
            XCTFail("Expected '.keyNotFound' but got \(error)")
        }
    }

    func testSeries_whenInitFromItemsInvalidIdentifierType_throwTypeMismatch() throws {
        // Given
        let items: [String: Any] = [
            "identifier": 1,
            "popularity": 0,
            "title": "Title",
            "charactersID": Set<String>(arrayLiteral: "1", "2")
        ]

        // When
        XCTAssertThrowsError(try Series(from: items)) {
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

    func testSeries_whenInitFromItemsInvalidPopularityType_throwTypeMismatch() throws {
        // Given
        let items: [String: Any] = [
            "identifier": "1",
            "popularity": "0",
            "title": "Title",
            "charactersID": Set<String>(arrayLiteral: "1", "2")
        ]

        // When
        XCTAssertThrowsError(try Series(from: items)) {
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

    func testSeries_whenInitFromItemsInvalidTitleType_throwTypeMismatch() throws {
        // Given
        let items: [String: Any] = [
            "identifier": "1",
            "popularity": 0,
            "title": 1,
            "charactersID": Set<String>(arrayLiteral: "1", "2")
        ]

        // When
        XCTAssertThrowsError(try Series(from: items)) {
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

    func testSeries_whenInitFromItemsInvalidcharactersIDType_throwTypeMismatch() throws {
        // Given
        let items: [String: Any] = [
            "identifier": "1",
            "popularity": 0,
            "title": "Title",
            "charactersID": "1"
        ]

        // When
        XCTAssertThrowsError(try Series(from: items)) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .typeMismatch(let key, _) = error as? DecodingError {
            XCTAssertTrue(key == Set<String>.self)
        } else {
            XCTFail("Expected '.typeMismatch' but got \(error)")
        }
    }
}
