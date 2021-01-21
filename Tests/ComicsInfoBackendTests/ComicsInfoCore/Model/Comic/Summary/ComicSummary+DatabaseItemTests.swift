//
//  ComicSummary+DatabaseItemTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 15/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class ComicSummary_DatabaseItemTests: XCTestCase {

    private var databaseItem: DatabasePutItem!
    private var sut: ComicSummary!

    override func setUpWithError() throws {
        databaseItem = DatabasePutItem(ComicMock.items, table: String.tableName(for: "TEST"))
    }

    override func tearDownWithError() throws {
        databaseItem = nil
        sut = nil
    }

    private func makeComicSummaryFromDatabaseItem() throws -> ComicSummary {
        try ComicSummary(from: databaseItem)
    }

    // MARK: - Item ID

    func testItemID_whenInitFromDatabaseItem_isEqualToItemID() throws {
        // Given
        let itemID = "series#1"
        databaseItem.attributes["itemID"] = itemID

        // When
        sut = try makeComicSummaryFromDatabaseItem()

        // Then
        XCTAssertEqual(sut.itemID, itemID)
    }

    func testComicDatabase_whenInitFromDatabaseItemWithMissingItemID_throwsKeyNotFound() throws {
        // Given
        databaseItem.attributes["itemID"] = nil
        var thrownError: Error?

        // When
        XCTAssertThrowsError(try makeComicSummaryFromDatabaseItem()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .keyNotFound(let key, _) = error as? DecodingError {
            XCTAssertEqual(key.stringValue, ComicSummary.CodingKeys.itemID.stringValue)
        } else {
            XCTFail("Expected '.keyNotFound' but got \(error)")
        }
    }

    // MARK: - Summary ID

    func testSummaryID_whenInitFromDatabaseItem_isEqualToSummaryID() throws {
        // Given
        let summaryID = "comic#1"
        databaseItem.attributes["summaryID"] = summaryID

        // When
        sut = try makeComicSummaryFromDatabaseItem()

        // Then
        XCTAssertEqual(sut.summaryID, summaryID)
    }

    func testComicDatabase_whenInitFromDatabaseItemWithMissingSummaryID_throwsKeyNotFound() throws {
        // Given
        databaseItem.attributes["summaryID"] = nil
        var thrownError: Error?

        // When
        XCTAssertThrowsError(try makeComicSummaryFromDatabaseItem()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .keyNotFound(let key, _) = error as? DecodingError {
            XCTAssertEqual(key.stringValue, ComicSummary.CodingKeys.summaryID.stringValue)
        } else {
            XCTFail("Expected '.keyNotFound' but got \(error)")
        }
    }

    func testComicDatabase_whenInitFromDatabaseItemWithInvalidSummaryID_throwsInvalidSummaryID() throws {
        // Given
        databaseItem.attributes["summaryID"] = "1"
        var thrownError: Error?

        // When
        XCTAssertThrowsError(try makeComicSummaryFromDatabaseItem()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .invalidSummaryID(let itemID, let itemType) = error as? APIError {
            XCTAssertEqual(itemID, "1")
            XCTAssertEqual(itemType, "comic")
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
        sut = try makeComicSummaryFromDatabaseItem()

        // Then
        XCTAssertEqual(sut.itemName, itemName)
    }

    func testComicDatabase_whenInitFromDatabaseItemWithMissingItemName_throwsKeyNotFound() throws {
        // Given
        databaseItem.attributes["itemName"] = nil
        var thrownError: Error?

        // When
        XCTAssertThrowsError(try makeComicSummaryFromDatabaseItem()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .keyNotFound(let key, _) = error as? DecodingError {
            XCTAssertEqual(key.stringValue, ComicSummary.CodingKeys.itemName.stringValue)
        } else {
            XCTFail("Expected '.keyNotFound' but got \(error)")
        }
    }
    
    // MARK: - Summary Name

    func testSummaryName_whenInitFromDatabaseItem_isEqualToSummaryName() throws {
        // Given
        let summaryName = "series"
        databaseItem.attributes["summaryName"] = summaryName

        // When
        sut = try makeComicSummaryFromDatabaseItem()

        // Then
        XCTAssertEqual(sut.summaryName, summaryName)
    }

    func testComicDatabase_whenInitFromDatabaseItemWithMissingSummaryName_throwsKeyNotFound() throws {
        // Given
        databaseItem.attributes["summaryName"] = nil
        var thrownError: Error?

        // When
        XCTAssertThrowsError(try makeComicSummaryFromDatabaseItem()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .keyNotFound(let key, _) = error as? DecodingError {
            XCTAssertEqual(key.stringValue, ComicSummary.CodingKeys.summaryName.stringValue)
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
        sut = try makeComicSummaryFromDatabaseItem()

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
        sut = try makeComicSummaryFromDatabaseItem()

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
        sut = try makeComicSummaryFromDatabaseItem()

        // Then
        XCTAssertEqual(sut.popularity, popularity)
    }

    func testComicDatabase_whenInitFromDatabaseItemWithMissingPopularity_throwsKeyNotFound() throws {
        // Given
        databaseItem.attributes["popularity"] = nil
        var thrownError: Error?

        // When
        XCTAssertThrowsError(try makeComicSummaryFromDatabaseItem()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .keyNotFound(let key, _) = error as? DecodingError {
            XCTAssertEqual(key.stringValue, ComicSummary.CodingKeys.popularity.stringValue)
        } else {
            XCTFail("Expected '.keyNotFound' but got \(error)")
        }
    }

    // MARK: - Title

    func testTitle_whenInitFromDatabaseItem_isEqualToTitle() throws {
        // Given
        let title = "Comic Title"
        databaseItem.attributes["name"] = title

        // When
        sut = try makeComicSummaryFromDatabaseItem()

        // Then
        XCTAssertEqual(sut.title, title)
    }

    func testComicDatabase_whenInitFromDatabaseItemWithMissingTitle_throwsKeyNotFound() throws {
        // Given
        databaseItem.attributes["title"] = nil
        var thrownError: Error?

        // When
        XCTAssertThrowsError(try makeComicSummaryFromDatabaseItem()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .keyNotFound(let key, _) = error as? DecodingError {
            XCTAssertEqual(key.stringValue, ComicSummary.CodingKeys.title.stringValue)
        } else {
            XCTFail("Expected '.keyNotFound' but got \(error)")
        }
    }

    // MARK: - Thumbnail

    func testThumbnail_whenInitFromDatabaseItem_isEqualToThumbnail() throws {
        // Given
        let thumbnail = "Comic Thumbnail"
        databaseItem.attributes["thumbnail"] = thumbnail

        // When
        sut = try makeComicSummaryFromDatabaseItem()

        // Then
        XCTAssertEqual(sut.thumbnail, thumbnail)
    }

    // MARK: - Description

    func testDescription_whenInitFromDatabaseItem_isEqualToDescription() throws {
        // Given
        let description = "Comic Description"
        databaseItem.attributes["description"] = description

        // When
        sut = try makeComicSummaryFromDatabaseItem()

        // Then
        XCTAssertEqual(sut.description, description)
    }

}
