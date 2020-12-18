//
//  CharacterCreateAPIWrapperTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 20/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class CharacterCreateAPIWrapperTests: XCTestCase, CreateSeriesProtocol, CreateComicProtocol {

    private var sut: CharacterCreateAPIWrapper!
    private var table: String!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        DatabaseMock.removeAll()
        sut = CharacterCreateAPIWrapperMock.make()
        table = String.tableName(for: "TEST")
    }

    override func tearDownWithError() throws {
        sut = nil
        table = nil
    }

    func test_whenGetSummaryFutures_returnsAllSummaries() throws {
        // Given
        let comic = ComicMock.makeComic()
        try createComic(comic)
        let series = SeriesMock.makeSeries()
        try createSeries(series)
        let character = CharacterMock.makeCharacter(seriesID: [series.id], comicsID: [comic.id])

        // When
        let features = sut.getSummaryFutures(for: character, in: table)
        var items = [DatabasePutItem]()
        for feature in features {
            items.append(contentsOf: try feature.wait())
        }

        // Then
        XCTAssertEqual(items.count, 4)
        XCTAssertTrue(
            items.contains(where: {
                $0.attributes["itemID"] as? String == "character#\(character.id)" &&
                $0.attributes["summaryID"] as? String == "series#\(series.id)" &&
                $0.attributes["itemName"] as? String == "character"
            })
        )
        XCTAssertTrue(
            items.contains(where: {
                $0.attributes["itemID"] as? String == "series#\(series.id)" &&
                $0.attributes["summaryID"] as? String == "character#\(character.id)" &&
                $0.attributes["itemName"] as? String == "series"
            })
        )
        XCTAssertTrue(
            items.contains(where: {
                $0.attributes["itemID"] as? String == "character#\(character.id)" &&
                $0.attributes["summaryID"] as? String == "comic#\(comic.id)" &&
                $0.attributes["itemName"] as? String == "character"
            })
        )
        XCTAssertTrue(
            items.contains(where: {
                $0.attributes["itemID"] as? String == "comic#\(comic.id)" &&
                $0.attributes["summaryID"] as? String == "character#\(character.id)" &&
                $0.attributes["itemName"] as? String == "comic"
            })
        )
    }

    func test_whenAppendItemSummary_returnsItemsSummary() throws {
        // Given
        let comic = ComicMock.makeComic()
        let character = CharacterMock.makeCharacter(comicsID: [comic.id])
        var dbItems = [DatabasePutItem]()

        // When
        let items = sut.appendItemSummary([comic], item: character, dbItems: &dbItems, tableName: table)

        // Then
        XCTAssertEqual(items.count, 1)
        XCTAssertTrue(
            items.contains(where: {
                $0.attributes["itemID"] as? String == "comic#\(comic.id)" &&
                $0.attributes["summaryID"] as? String == "character#\(character.id)" &&
                $0.attributes["itemName"] as? String == "comic"
            })
        )
    }

    // MARK: - Create

    func test_whenCrateCharacter_characterIsCreated() throws {
        // Given

        // When
        let feature = sut.create(CharacterMock.makeCharacter(), in: table)

        // Then
        XCTAssertNoThrow(try feature.wait())
    }

    func test_whenCrateTheSameCharacterTwice_throwsItemAlreadyExists() throws {
        // Given
        var feature = sut.create(CharacterMock.makeCharacter(), in: table)
        try feature.wait()
        var thrownError: Error?

        // When
        feature = sut.create(CharacterMock.makeCharacter(), in: table)
        XCTAssertThrowsError(try feature.wait()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .itemAlreadyExists(let itemID, let itemType) = error as? APIError {
            XCTAssertEqual(itemID, "character#1|character#1")
            XCTAssertTrue(itemType == Character.self)
        } else {
            XCTFail("Expected '.itemAlreadyExists' but got \(error)")
        }
    }

    func test_whenCrateCharacterWithNotExistingSeriesID_throwsItemsNotFound() throws {
        // Given
        let seriesID: Set<String> = ["-1"]
        var thrownError: Error?

        // When
        let feature = sut.create(CharacterMock.makeCharacter(seriesID: seriesID), in: table)
        XCTAssertThrowsError(try feature.wait()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .itemsNotFound(let itemIDs, let itemType) = error as? APIError {
            XCTAssertEqual(itemIDs, ["-1"])
            XCTAssertTrue(itemType == Series.self)
        } else {
            XCTFail("Expected '.itemsNotFound' but got \(error)")
        }
    }

    func test_whenCrateCharacterWithNotExistingComicsID_throwsItemsNotFound() throws {
        // Given
        let comicsID: Set<String> = ["-1"]
        var thrownError: Error?

        // When
        let feature = sut.create(CharacterMock.makeCharacter(comicsID: comicsID), in: table)
        XCTAssertThrowsError(try feature.wait()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .itemsNotFound(let itemIDs, let itemType) = error as? APIError {
            XCTAssertEqual(itemIDs, ["-1"])
            XCTAssertTrue(itemType == Comic.self)
        } else {
            XCTFail("Expected '.itemsNotFound' but got \(error)")
        }
    }

    func test_whenCrateCharacterWithSeriesIDAndComicsID_characterAndCharacterSummariesAreCreated() throws {
        // Given
        let series = SeriesMock.makeSeries(id: "1")
        try createSeries(series)
        let comic = ComicMock.makeComic(id: "1")
        try createComic(comic)

        // When
        let feature = sut.create(CharacterMock.makeCharacter(seriesID: [series.id], comicsID: [comic.id]), in: table)

        // Then
        XCTAssertNoThrow(try feature.wait())
    }

    func test_whenCrateCharacterWithOneNotExistingSeriesID_throwsItemNotFound() throws {
        // Given
        let series = SeriesMock.makeSeries(id: "1")
        try createSeries(series)
        let character = CharacterMock.makeCharacter(seriesID: [series.id, "-1"])
        var thrownError: Error?

        // When
        let feature = sut.create(character, in: table)
        XCTAssertThrowsError(try feature.wait()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .itemNotFound(let itemID, let itemType) = error as? APIError {
            XCTAssertEqual(itemID, "-1")
            XCTAssertTrue(itemType == Series.self)
        } else {
            XCTFail("Expected '.itemNotFound' but got \(error)")
        }
    }

    func test_whenCrateCharacterWithOneNotExistingComicID_throwsItemNotFound() throws {
        // Given
        let comic = ComicMock.makeComic(id: "1")
        try createComic(comic)
        let character = CharacterMock.makeCharacter(comicsID: [comic.id, "-1"])
        var thrownError: Error?

        // When
        let feature = sut.create(character, in: table)
        XCTAssertThrowsError(try feature.wait()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .itemNotFound(let itemID, let itemType) = error as? APIError {
            XCTAssertEqual(itemID, "-1")
            XCTAssertTrue(itemType == Comic.self)
        } else {
            XCTFail("Expected '.itemNotFound' but got \(error)")
        }
    }

}
