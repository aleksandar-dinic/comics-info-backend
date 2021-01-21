//
//  ItemSummary+DatabaseItemTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 14/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class ItemSummary_DatabaseItemTests: XCTestCase {
    
    private var databaseItem: DatabasePutItem!
    private var sut: ItemSummary<Character>!

    override func setUpWithError() throws {
        databaseItem = DatabasePutItem(CharacterMock.items, table: .tableName(for: "TEST"))
    }

    override func tearDownWithError() throws {
        databaseItem = nil
        sut = nil
    }

    private func makeItemSummaryFromDatabaseItem() throws -> ItemSummary<Character> {
        try ItemSummary(from: databaseItem)
    }

    // MARK: - Item ID

    func testItemID_whenInitFromDatabaseItem_isEqualToItemID() throws {
        // Given
        let itemID = "series#1"
        databaseItem.attributes["itemID"] = itemID

        // When
        sut = try makeItemSummaryFromDatabaseItem()

        // Then
        XCTAssertEqual(sut.itemID, itemID)
    }

    func testItemDatabase_whenInitFromDatabaseItemWithMissingItemID_throwsKeyNotFound() throws {
        // Given
        databaseItem.attributes["itemID"] = nil
        var thrownError: Error?

        // When
        XCTAssertThrowsError(try makeItemSummaryFromDatabaseItem()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .keyNotFound(let key, _) = error as? DecodingError {
            XCTAssertEqual(key.stringValue, ItemSummary<Character>.CodingKeys.itemID.stringValue)
        } else {
            XCTFail("Expected '.keyNotFound' but got \(error)")
        }
    }

    // MARK: - Summary ID

    func testSummaryID_whenInitFromDatabaseItem_isEqualToSummaryID() throws {
        // Given
        let summaryID = "character#1"
        databaseItem.attributes["summaryID"] = summaryID

        // When
        sut = try makeItemSummaryFromDatabaseItem()

        // Then
        XCTAssertEqual(sut.summaryID, summaryID)
    }

    func testItemDatabase_whenInitFromDatabaseItemWithMissingSummaryID_throwsKeyNotFound() throws {
        // Given
        databaseItem.attributes["summaryID"] = nil
        var thrownError: Error?

        // When
        XCTAssertThrowsError(try makeItemSummaryFromDatabaseItem()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .keyNotFound(let key, _) = error as? DecodingError {
            XCTAssertEqual(key.stringValue, ItemSummary<Character>.CodingKeys.summaryID.stringValue)
        } else {
            XCTFail("Expected '.keyNotFound' but got \(error)")
        }
    }

    func testItemDatabase_whenInitFromDatabaseItemWithInvalidSummaryID_throwsInvalidSummaryID() throws {
        // Given
        databaseItem.attributes["summaryID"] = "1"
        var thrownError: Error?

        // When
        XCTAssertThrowsError(try makeItemSummaryFromDatabaseItem()) {
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
        let itemName = "series"
        databaseItem.attributes["itemName"] = itemName

        // When
        sut = try makeItemSummaryFromDatabaseItem()

        // Then
        XCTAssertEqual(sut.itemName, itemName)
    }

    func testItemDatabase_whenInitFromDatabaseItemWithMissingItemName_throwsKeyNotFound() throws {
        // Given
        databaseItem.attributes["itemName"] = nil
        var thrownError: Error?

        // When
        XCTAssertThrowsError(try makeItemSummaryFromDatabaseItem()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .keyNotFound(let key, _) = error as? DecodingError {
            XCTAssertEqual(key.stringValue, ItemSummary<Character>.CodingKeys.itemName.stringValue)
        } else {
            XCTFail("Expected '.keyNotFound' but got \(error)")
        }
    }
    
    // MARK: - Summary Name

    func testSummaryName_whenInitFromDatabaseItem_isEqualToSummaryName() throws {
        // Given
        let summaryName = "Item"
        databaseItem.attributes["summaryName"] = summaryName

        // When
        sut = try makeItemSummaryFromDatabaseItem()

        // Then
        XCTAssertEqual(sut.summaryName, summaryName)
    }

    func testItemDatabase_whenInitFromDatabaseItemWithMissingSummaryName_throwsKeyNotFound() throws {
        // Given
        databaseItem.attributes["summaryName"] = nil
        var thrownError: Error?

        // When
        XCTAssertThrowsError(try makeItemSummaryFromDatabaseItem()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .keyNotFound(let key, _) = error as? DecodingError {
            XCTAssertEqual(key.stringValue, ItemSummary<Character>.CodingKeys.summaryName.stringValue)
        } else {
            XCTFail("Expected '.keyNotFound' but got \(error)")
        }
    }
    
    // MARK: - Date Added

    func testItemDateAdded_whenInitFromDatabaseItem_isEqualToItemDateAdded() throws {
        // Given
        let dateAdded = Date()
        databaseItem.attributes["dateAdded"] = DateFormatter.defaultString(from: dateAdded)

        // When
        sut = try makeItemSummaryFromDatabaseItem()

        // Then
        XCTAssertEqual(
            Calendar.current.dateComponents([.year, .month, .day], from: sut.dateAdded),
            Calendar.current.dateComponents([.year, .month, .day], from: dateAdded)
        )
    }
    
    // MARK: - Date Last Updated

    func testItemDateLastUpdated_whenInitFromDatabaseItem_isEqualToItemDateLastUpdated() throws {
        // Given
        let dateLastUpdated = Date()
        databaseItem.attributes["dateLastUpdated"] = DateFormatter.defaultString(from: dateLastUpdated)

        // When
        sut = try makeItemSummaryFromDatabaseItem()

        // Then
        XCTAssertEqual(
            Calendar.current.dateComponents([.year, .month, .day], from: sut.dateLastUpdated),
            Calendar.current.dateComponents([.year, .month, .day], from: dateLastUpdated)
        )
    }

    // MARK: - Popularity

    func testPopularity_whenInitFromDatabaseItem_isEqualToPopularity() throws {
        // Given
        let popularity = 0
        databaseItem.attributes["popularity"] = popularity

        // When
        sut = try makeItemSummaryFromDatabaseItem()

        // Then
        XCTAssertEqual(sut.popularity, popularity)
    }

    func testItemDatabase_whenInitFromDatabaseItemWithMissingPopularity_throwsKeyNotFound() throws {
        // Given
        databaseItem.attributes["popularity"] = nil
        var thrownError: Error?

        // When
        XCTAssertThrowsError(try makeItemSummaryFromDatabaseItem()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .keyNotFound(let key, _) = error as? DecodingError {
            XCTAssertEqual(key.stringValue, ItemSummary<Character>.CodingKeys.popularity.stringValue)
        } else {
            XCTFail("Expected '.keyNotFound' but got \(error)")
        }
    }

    // MARK: - Name

    func testName_whenInitFromDatabaseItem_isEqualToName() throws {
        // Given
        let name = "Item Name"
        databaseItem.attributes["name"] = name

        // When
        sut = try makeItemSummaryFromDatabaseItem()

        // Then
        XCTAssertEqual(sut.name, name)
    }

    func testItemDatabase_whenInitFromDatabaseItemWithMissingName_throwsKeyNotFound() throws {
        // Given
        databaseItem.attributes["name"] = nil
        var thrownError: Error?

        // When
        XCTAssertThrowsError(try makeItemSummaryFromDatabaseItem()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .keyNotFound(let key, _) = error as? DecodingError {
            XCTAssertEqual(key.stringValue, ItemSummary<Character>.CodingKeys.name.stringValue)
        } else {
            XCTFail("Expected '.keyNotFound' but got \(error)")
        }
    }

    // MARK: - Thumbnail

    func testThumbnail_whenInitFromDatabaseItem_isEqualToThumbnail() throws {
        // Given
        let thumbnail = "Item Thumbnail"
        databaseItem.attributes["thumbnail"] = thumbnail

        // When
        sut = try makeItemSummaryFromDatabaseItem()

        // Then
        XCTAssertEqual(sut.thumbnail, thumbnail)
    }

    // MARK: - Description

    func testDescription_whenInitFromDatabaseItem_isEqualToDescription() throws {
        // Given
        let description = "Item Description"
        databaseItem.attributes["description"] = description

        // When
        sut = try makeItemSummaryFromDatabaseItem()

        // Then
        XCTAssertEqual(sut.description, description)
    }
    
    // MARK: - Count

    func testCount_whenInitFromDatabaseItem_isEqualToCount() throws {
        // Given
        let count = 1
        databaseItem.attributes["count"] = count

        // When
        sut = try makeItemSummaryFromDatabaseItem()

        // Then
        XCTAssertEqual(sut.count, count)
    }
    
    
}
