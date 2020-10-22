//
//  CharacterDatabase+DatabaseMapperTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 13/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class CharacterDatabase_DatabaseMapperTests: XCTestCase {

    private var databaseItem: DatabasePutItem!
    private var sut: CharacterDatabase!

    override func setUpWithError() throws {
        databaseItem = DatabasePutItem(CharacterMock.items, table: "character")
    }

    override func tearDownWithError() throws {
        databaseItem = nil
        sut = nil
    }

    private func makeCharacterDatabaseFromDatabaseItem() throws -> CharacterDatabase {
        try CharacterDatabase(from: databaseItem, tableName: "character")
    }

    // MARK: - Item ID

    func testItemID_whenInitFromDatabaseItem_isEqualToItemID() throws {
        // Given
        let itemID = "character#1"
        databaseItem.attributes["itemID"] = itemID

        // When
        sut = try makeCharacterDatabaseFromDatabaseItem()

        // Then
        XCTAssertEqual(sut.itemID, itemID)
    }

    func testCharacterDatabase_whenInitFromDatabaseItemWithMissingItemID_throwsKeyNotFound() throws {
        // Given
        databaseItem.attributes["itemID"] = nil
        var thrownError: Error?

        // When
        XCTAssertThrowsError(try makeCharacterDatabaseFromDatabaseItem()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .keyNotFound(let key, _) = error as? DecodingError {
            XCTAssertEqual(key.stringValue, CharacterDatabase.CodingKeys.itemID.stringValue)
        } else {
            XCTFail("Expected '.keyNotFound' but got \(error)")
        }
    }

    func testCharacterDatabase_whenInitFromDatabaseItemWithInvalidItemID_throwsInvalidItemID() throws {
        // Given
        databaseItem.attributes["itemID"] = "1"
        var thrownError: Error?

        // When
        XCTAssertThrowsError(try makeCharacterDatabaseFromDatabaseItem()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .invalidItemID(let itemID, let itemType) = error as? APIError {
            XCTAssertEqual(itemID, "1")
            XCTAssertEqual(itemType, "character")
        } else {
            XCTFail("Expected '.invalidItemID' but got \(error)")
        }
    }

    // MARK: - Summary ID

    func testSummaryID_whenInitFromDatabaseItem_isEqualToSummaryID() throws {
        // Given
        let summaryID = "character#1"
        databaseItem.attributes["summaryID"] = summaryID

        // When
        sut = try makeCharacterDatabaseFromDatabaseItem()

        // Then
        XCTAssertEqual(sut.summaryID, summaryID)
    }

    func testCharacterDatabase_whenInitFromDatabaseItemWithMissingSummaryID_throwsKeyNotFound() throws {
        // Given
        databaseItem.attributes["summaryID"] = nil
        var thrownError: Error?

        // When
        XCTAssertThrowsError(try makeCharacterDatabaseFromDatabaseItem()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .keyNotFound(let key, _) = error as? DecodingError {
            XCTAssertEqual(key.stringValue, CharacterDatabase.CodingKeys.summaryID.stringValue)
        } else {
            XCTFail("Expected '.keyNotFound' but got \(error)")
        }
    }

    func testCharacterDatabase_whenInitFromDatabaseItemWithInvalidSummaryID_throwsInvalidSummaryID() throws {
        // Given
        databaseItem.attributes["summaryID"] = "1"
        var thrownError: Error?

        // When
        XCTAssertThrowsError(try makeCharacterDatabaseFromDatabaseItem()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .invalidSummaryID(let itemID, let itemType) = error as? APIError {
            XCTAssertEqual(itemID, "1")
            XCTAssertEqual(itemType, "character")
        } else {
            XCTFail("Expected '.invalidItemID' but got \(error)")
        }
    }

    // MARK: - Item Name

    func testItemName_whenInitFromDatabaseItem_isEqualToItemName() throws {
        // Given
        let itemName = "character"
        databaseItem.attributes["itemName"] = itemName

        // When
        sut = try makeCharacterDatabaseFromDatabaseItem()

        // Then
        XCTAssertEqual(sut.itemName, itemName)
    }

    func testCharacterDatabase_whenInitFromDatabaseItemWithMissingItemName_throwsKeyNotFound() throws {
        // Given
        databaseItem.attributes["itemName"] = nil
        var thrownError: Error?

        // When
        XCTAssertThrowsError(try makeCharacterDatabaseFromDatabaseItem()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .keyNotFound(let key, _) = error as? DecodingError {
            XCTAssertEqual(key.stringValue, CharacterDatabase.CodingKeys.itemName.stringValue)
        } else {
            XCTFail("Expected '.keyNotFound' but got \(error)")
        }
    }

    // MARK: - Popularity

    func testPopularity_whenInitFromDatabaseItem_isEqualToPopularity() throws {
        // Given
        let popularity = 0
        databaseItem.attributes["popularity"] = popularity

        // When
        sut = try makeCharacterDatabaseFromDatabaseItem()

        // Then
        XCTAssertEqual(sut.popularity, popularity)
    }

    func testCharacterDatabase_whenInitFromDatabaseItemWithMissingPopularity_throwsKeyNotFound() throws {
        // Given
        databaseItem.attributes["popularity"] = nil
        var thrownError: Error?

        // When
        XCTAssertThrowsError(try makeCharacterDatabaseFromDatabaseItem()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .keyNotFound(let key, _) = error as? DecodingError {
            XCTAssertEqual(key.stringValue, CharacterDatabase.CodingKeys.popularity.stringValue)
        } else {
            XCTFail("Expected '.keyNotFound' but got \(error)")
        }
    }

    // MARK: - Name

    func testName_whenInitFromDatabaseItem_isEqualToName() throws {
        // Given
        let name = "Character Name"
        databaseItem.attributes["name"] = name

        // When
        sut = try makeCharacterDatabaseFromDatabaseItem()

        // Then
        XCTAssertEqual(sut.name, name)
    }

    func testCharacterDatabase_whenInitFromDatabaseItemWithMismatchNameType_throwsTypeMismatch() throws {
        // Given
        let name = 1
        databaseItem.attributes["name"] = name
        var thrownError: Error?

        // When
        XCTAssertThrowsError(try makeCharacterDatabaseFromDatabaseItem()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .typeMismatch(let type, _) = error as? DecodingError {
            XCTAssertTrue(type == String.self)
        } else {
            XCTFail("Expected '.typeMismatch' but got \(error)")
        }
    }

    func testCharacterDatabase_whenInitFromDatabaseItemWithMissingName_throwsKeyNotFound() throws {
        // Given
        databaseItem.attributes["name"] = nil
        var thrownError: Error?

        // When
        XCTAssertThrowsError(try makeCharacterDatabaseFromDatabaseItem()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .keyNotFound(let key, _) = error as? DecodingError {
            XCTAssertEqual(key.stringValue, CharacterDatabase.CodingKeys.name.stringValue)
        } else {
            XCTFail("Expected '.keyNotFound' but got \(error)")
        }
    }
    
    // MARK: - Thumbnail

    func testThumbnail_whenInitFromDatabaseItem_isEqualToThumbnail() throws {
        // Given
        let thumbnail = "Character Thumbnail"
        databaseItem.attributes["thumbnail"] = thumbnail

        // When
        sut = try makeCharacterDatabaseFromDatabaseItem()

        // Then
        XCTAssertEqual(sut.thumbnail, thumbnail)
    }

    // MARK: - Description

    func testDescription_whenInitFromDatabaseItem_isEqualToDescription() throws {
        // Given
        let description = "Character Description"
        databaseItem.attributes["description"] = description

        // When
        sut = try makeCharacterDatabaseFromDatabaseItem()

        // Then
        XCTAssertEqual(sut.description, description)
    }

}
