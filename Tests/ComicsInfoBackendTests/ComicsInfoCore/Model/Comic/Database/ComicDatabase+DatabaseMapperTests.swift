//
//  ComicDatabase+DatabaseMapperTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 15/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class ComicDatabase_DatabaseMapperTests: XCTestCase {

    private var databaseItem: DatabasePutItem!
    private var sut: ComicDatabase!

    override func setUpWithError() throws {
        databaseItem = DatabasePutItem(ComicMock.items, table: String.tableName(for: "TEST"))
    }

    override func tearDownWithError() throws {
        databaseItem = nil
        sut = nil
    }

    private func makeComicDatabaseFromDatabaseItem() throws -> ComicDatabase {
        try ComicDatabase(from: databaseItem)
    }

    // MARK: - Item ID

    func testItemID_whenInitFromDatabaseItem_isEqualToItemID() throws {
        // Given
        let itemID = "comic#1"
        databaseItem.attributes["itemID"] = itemID

        // When
        sut = try makeComicDatabaseFromDatabaseItem()

        // Then
        XCTAssertEqual(sut.itemID, itemID)
    }

    func testComicDatabase_whenInitFromDatabaseItemWithMissingItemID_throwsKeyNotFound() throws {
        // Given
        databaseItem.attributes["itemID"] = nil
        var thrownError: Error?

        // When
        XCTAssertThrowsError(try makeComicDatabaseFromDatabaseItem()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .keyNotFound(let key, _) = error as? DecodingError {
            XCTAssertEqual(key.stringValue, ComicDatabase.CodingKeys.itemID.stringValue)
        } else {
            XCTFail("Expected '.keyNotFound' but got \(error)")
        }
    }

    func testComicDatabase_whenInitFromDatabaseItemWithInvalidItemID_throwsInvalidItemID() throws {
        // Given
        databaseItem.attributes["itemID"] = "1"
        var thrownError: Error?

        // When
        XCTAssertThrowsError(try makeComicDatabaseFromDatabaseItem()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .invalidItemID(let itemID, let itemType) = error as? APIError {
            XCTAssertEqual(itemID, "1")
            XCTAssertEqual(itemType, "comic")
        } else {
            XCTFail("Expected '.invalidItemID' but got \(error)")
        }
    }

    // MARK: - Summary ID

    func testSummaryID_whenInitFromDatabaseItem_isEqualToSummaryID() throws {
        // Given
        let summaryID = "comic#1"
        databaseItem.attributes["summaryID"] = summaryID

        // When
        sut = try makeComicDatabaseFromDatabaseItem()

        // Then
        XCTAssertEqual(sut.summaryID, summaryID)
    }

    func testComicDatabase_whenInitFromDatabaseItemWithMissingSummaryID_throwsKeyNotFound() throws {
        // Given
        databaseItem.attributes["summaryID"] = nil
        var thrownError: Error?

        // When
        XCTAssertThrowsError(try makeComicDatabaseFromDatabaseItem()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .keyNotFound(let key, _) = error as? DecodingError {
            XCTAssertEqual(key.stringValue, ComicDatabase.CodingKeys.summaryID.stringValue)
        } else {
            XCTFail("Expected '.keyNotFound' but got \(error)")
        }
    }

    func testComicDatabase_whenInitFromDatabaseItemWithInvalidSummaryID_throwsInvalidSummaryID() throws {
        // Given
        databaseItem.attributes["summaryID"] = "1"
        var thrownError: Error?

        // When
        XCTAssertThrowsError(try makeComicDatabaseFromDatabaseItem()) {
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
        let itemName = "comic"
        databaseItem.attributes["itemName"] = itemName

        // When
        sut = try makeComicDatabaseFromDatabaseItem()

        // Then
        XCTAssertEqual(sut.itemName, itemName)
    }

    func testComicDatabase_whenInitFromDatabaseItemWithMissingItemName_throwsKeyNotFound() throws {
        // Given
        databaseItem.attributes["itemName"] = nil
        var thrownError: Error?

        // When
        XCTAssertThrowsError(try makeComicDatabaseFromDatabaseItem()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .keyNotFound(let key, _) = error as? DecodingError {
            XCTAssertEqual(key.stringValue, ComicDatabase.CodingKeys.itemName.stringValue)
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
        sut = try makeComicDatabaseFromDatabaseItem()

        // Then
        XCTAssertEqual(sut.popularity, popularity)
    }

    func testComicDatabase_whenInitFromDatabaseItemWithMissingPopularity_throwsKeyNotFound() throws {
        // Given
        databaseItem.attributes["popularity"] = nil
        var thrownError: Error?

        // When
        XCTAssertThrowsError(try makeComicDatabaseFromDatabaseItem()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .keyNotFound(let key, _) = error as? DecodingError {
            XCTAssertEqual(key.stringValue, ComicDatabase.CodingKeys.popularity.stringValue)
        } else {
            XCTFail("Expected '.keyNotFound' but got \(error)")
        }
    }

    // MARK: - Title

    func testTitle_whenInitFromDatabaseItem_isEqualToName() throws {
        // Given
        let title = "Comic Title"
        databaseItem.attributes["title"] = title

        // When
        sut = try makeComicDatabaseFromDatabaseItem()

        // Then
        XCTAssertEqual(sut.title, title)
    }

    func testComicDatabase_whenInitFromDatabaseItemWithMissingTitle_throwsKeyNotFound() throws {
        // Given
        databaseItem.attributes["title"] = nil
        var thrownError: Error?

        // When
        XCTAssertThrowsError(try makeComicDatabaseFromDatabaseItem()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .keyNotFound(let key, _) = error as? DecodingError {
            XCTAssertEqual(key.stringValue, ComicDatabase.CodingKeys.title.stringValue)
        } else {
            XCTFail("Expected '.keyNotFound' but got \(error)")
        }
    }
    
    // MARK: - Date Added

    func testDateAdded_whenInitFromDatabaseItem_isEqualToDateAdded() throws {
        // Given
        let dateAdded = Date()
        databaseItem.attributes["dateAdded"] = DateFormatter.defaultString(from: dateAdded)

        // When
        sut = try makeComicDatabaseFromDatabaseItem()

        // Then
        XCTAssertEqual(
            Calendar.current.dateComponents([.year, .month, .day], from: sut.dateAdded),
            Calendar.current.dateComponents([.year, .month, .day], from: dateAdded)
        )
    }
    
    // MARK: - Date Last Updated

    func testDateLastUpdated_whenInitFromDatabaseItem_isEqualToDateLastUpdated() throws {
        // Given
        let dateLastUpdated = Date()
        databaseItem.attributes["dateLastUpdated"] = DateFormatter.defaultString(from: dateLastUpdated)

        // When
        sut = try makeComicDatabaseFromDatabaseItem()

        // Then
        XCTAssertEqual(
            Calendar.current.dateComponents([.year, .month, .day], from: sut.dateLastUpdated),
            Calendar.current.dateComponents([.year, .month, .day], from: dateLastUpdated)
        )
    }

    // MARK: - Thumbnail

    func testThumbnail_whenInitFromDatabaseItem_isEqualToThumbnail() throws {
        // Given
        let thumbnail = "Comic Thumbnail"
        databaseItem.attributes["thumbnail"] = thumbnail

        // When
        sut = try makeComicDatabaseFromDatabaseItem()

        // Then
        XCTAssertEqual(sut.thumbnail, thumbnail)
    }

    // MARK: - Description

    func testDescription_whenInitFromDatabaseItem_isEqualToDescription() throws {
        // Given
        let description = "Comic Description"
        databaseItem.attributes["description"] = description

        // When
        sut = try makeComicDatabaseFromDatabaseItem()

        // Then
        XCTAssertEqual(sut.description, description)
    }

    // MARK: - Number

    func testNumber_whenInitFromDatabaseItem_isEqualToNumber() throws {
        // Given
        let number = "Comic Number"
        databaseItem.attributes["number"] = number

        // When
        sut = try makeComicDatabaseFromDatabaseItem()

        // Then
        XCTAssertEqual(sut.number, number)
    }
    
    // MARK: - Aliases

    func testAliases_whenInitFromDatabaseItem_isEqualToAliases() throws {
        // Given
        let aliases = ["Comic Aliases"]
        databaseItem.attributes["aliases"] = aliases

        // When
        sut = try makeComicDatabaseFromDatabaseItem()

        // Then
        XCTAssertEqual(sut.aliases, aliases)
    }

    // MARK: - Variant Description

    func testVariantDescription_whenInitFromDatabaseItem_isEqualToVariantDescription() throws {
        // Given
        let variantDescription = "Comic Variant Description"
        databaseItem.attributes["variantDescription"] = variantDescription

        // When
        sut = try makeComicDatabaseFromDatabaseItem()

        // Then
        XCTAssertEqual(sut.variantDescription, variantDescription)
    }

    // MARK: - Format

    func testFormat_whenInitFromDatabaseItem_isEqualToFormat() throws {
        // Given
        let format = "Comic Format"
        databaseItem.attributes["format"] = format

        // When
        sut = try makeComicDatabaseFromDatabaseItem()

        // Then
        XCTAssertEqual(sut.format, format)
    }

    // MARK: - Page Count

    func testPageCount_whenInitFromDatabaseItem_isEqualToPageCount() throws {
        // Given
        let pageCount = 1
        databaseItem.attributes["pageCount"] = pageCount

        // When
        sut = try makeComicDatabaseFromDatabaseItem()

        // Then
        XCTAssertEqual(sut.pageCount, pageCount)
    }

    // MARK: - Variants Identifier

    func testVariantsIdentifier_whenInitFromDatabaseItem_isEqualToVariantsIdentifier() throws {
        // Given
        let variantsIdentifier = ["Comic Variants Identifier"]
        databaseItem.attributes["variantsIdentifier"] = variantsIdentifier

        // When
        sut = try makeComicDatabaseFromDatabaseItem()

        // Then
        XCTAssertEqual(sut.variantsIdentifier, variantsIdentifier)
    }

    // MARK: - Collections Identifier

    func testCollectionsIdentifier_whenInitFromDatabaseItem_isEqualToCollectionsIdentifier() throws {
        // Given
        let collectionsIdentifier = ["Comic Collections Identifier"]
        databaseItem.attributes["collectionsIdentifier"] = collectionsIdentifier

        // When
        sut = try makeComicDatabaseFromDatabaseItem()

        // Then
        XCTAssertEqual(sut.collectionsIdentifier, collectionsIdentifier)
    }

    // MARK: - Collected Identifiers

    func testCollectedIdentifiers_whenInitFromDatabaseItem_isEqualToCollectedIdentifiers() throws {
        // Given
        let collectedIdentifiers = ["Comic Collected Identifiers"]
        databaseItem.attributes["collectedIdentifiers"] = collectedIdentifiers

        // When
        sut = try makeComicDatabaseFromDatabaseItem()

        // Then
        XCTAssertEqual(sut.collectedIdentifiers, collectedIdentifiers)
    }

    // MARK: - Images

    func testImages_whenInitFromDatabaseItem_isEqualToImages() throws {
        // Given
        let images = ["Comic Images"]
        databaseItem.attributes["images"] = images

        // When
        sut = try makeComicDatabaseFromDatabaseItem()

        // Then
        XCTAssertEqual(sut.images, images)
    }

    // MARK: - Published

    func testPublished_whenInitFromDatabaseItem_isEqualToPublished() throws {
        // Given
        let published = Date()
        databaseItem.attributes["published"] = DateFormatter.defaultString(from: published)

        // When
        sut = try makeComicDatabaseFromDatabaseItem()

        // Then
        let sutPublished = try XCTUnwrap(sut.published)
        XCTAssertEqual(
            Calendar.current.dateComponents([.year, .month, .day], from: sutPublished),
            Calendar.current.dateComponents([.year, .month, .day], from: published)
        )
    }

}
