//
//  ComicCreateAPIWrapperTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 21/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class ComicCreateAPIWrapperTests: XCTestCase, CreateCharacterProtocol, CreateSeriesProtocol {

    private var sut: ComicCreateAPIWrapper!
    private var table: String!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        DatabaseMock.removeAll()
        sut = ComicCreateAPIWrapperMock.make(tables: [:])
        table = String.tableName(for: "TEST")
    }

    override func tearDownWithError() throws {
        sut = nil
        table = nil
    }

    func test_whenGetSummaryFutures_returnsAllSummaries() throws {
        // Given
        let character = CharacterMock.makeCharacter()
        try createCharacter(character)
        let series = SeriesMock.makeSeries()
        try createSeries(series)
        let comic = ComicMock.makeComic(charactersID: [character.id], seriesID: [series.id])

        // When
        let features = sut.getSummaryFutures(for: comic, in: table)
        var items = [DatabasePutItem]()
        for feature in features {
            items.append(contentsOf: try feature.wait())
        }

        // Then
        XCTAssertEqual(items.count, 4)
        XCTAssertTrue(
            items.contains(where: {
                $0.attributes["itemID"] as? String == "comic#\(comic.id)" &&
                $0.attributes["summaryID"] as? String == "character#\(character.id)" &&
                $0.attributes["itemName"] as? String == "comic"
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
                $0.attributes["summaryID"] as? String == "series#\(series.id)" &&
                $0.attributes["itemName"] as? String == "comic"
            })
        )
        XCTAssertTrue(
            items.contains(where: {
                $0.attributes["itemID"] as? String == "series#\(series.id)" &&
                $0.attributes["summaryID"] as? String == "comic#\(comic.id)" &&
                $0.attributes["itemName"] as? String == "series"
            })
        )
    }

    func test_whenAppendItemSummary_returnsItemsSummary() throws {
        // Given
        let character = CharacterMock.makeCharacter()
        let comic = ComicMock.makeComic(charactersID: [character.id])
        var dbItems = [DatabasePutItem]()

        // When
        let items = sut.appendItemSummary([character], item: comic, dbItems: &dbItems, tableName: table)

        // Then
        XCTAssertEqual(items.count, 1)
        XCTAssertTrue(
            items.contains(where: {
                $0.attributes["itemID"] as? String == "character#\(character.id)" &&
                $0.attributes["summaryID"] as? String == "comic#\(comic.id)" &&
                $0.attributes["itemName"] as? String == "character"
            })
        )
    }

    // MARK: - Create

    func test_whenCrateComic_comicIsCreated() throws {
        // Given

        // When
        let feature = sut.create(ComicMock.makeComic(), in: table)

        // Then
        XCTAssertNoThrow(try feature.wait())
    }

    func test_whenComicTheSameComicTwice_throwsItemAlreadyExists() throws {
        // Given
        var feature = sut.create(ComicMock.makeComic(), in: table)
        try feature.wait()
        var thrownError: Error?

        // When
        feature = sut.create(ComicMock.makeComic(), in: table)
        XCTAssertThrowsError(try feature.wait()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .itemAlreadyExists(let itemID, let itemType) = error as? APIError {
            XCTAssertEqual(itemID, "comic#1|comic#1")
            XCTAssertTrue(itemType == Comic.self)
        } else {
            XCTFail("Expected '.itemAlreadyExists' but got \(error)")
        }
    }

    func test_whenCrateComicWithNotExistingCharacterID_throwsItemsNotFound() throws {
        // Given
        let charactersID: Set<String> = ["-1"]
        var thrownError: Error?

        // When
        let feature = sut.create(ComicMock.makeComic(charactersID: charactersID), in: table)
        XCTAssertThrowsError(try feature.wait()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .itemsNotFound(let itemIDs, let itemType) = error as? APIError {
            XCTAssertEqual(itemIDs, ["-1"])
            XCTAssertTrue(itemType == Character.self)
        } else {
            XCTFail("Expected '.itemsNotFound' but got \(error)")
        }
    }

    func test_whenCrateComicWithNotExistingSeriesID_throwsItemsNotFound() throws {
        // Given
        let seriesID: Set<String> = ["-1"]
        var thrownError: Error?

        // When
        let feature = sut.create(ComicMock.makeComic(seriesID: seriesID), in: table)
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

    func test_whenCrateComicWithCharactersIDAndSeriesID_comicAndComicSummariesAreCreated() throws {
        // Given
        let character = CharacterMock.makeCharacter(id: "1")
        try createCharacter(character)
        let series = SeriesMock.makeSeries(id: "1")
        try createSeries(series)

        // When
        let feature = sut.create(ComicMock.makeComic(charactersID: [character.id], seriesID: [series.id]), in: table)

        // Then
        XCTAssertNoThrow(try feature.wait())
    }

    func test_whenCrateComicWithOneNotExistingSeriesID_throwsItemNotFound() throws {
        // Given
        let series = SeriesMock.makeSeries(id: "1")
        try createSeries(series)
        let comic = ComicMock.makeComic(seriesID: [series.id, "-1"])
        var thrownError: Error?

        // When
        let feature = sut.create(comic, in: table)
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

    func test_whenCrateComicWithOneNotExistingCharacterID_throwsItemNotFound() throws {
        // Given
        let character = CharacterMock.makeCharacter(id: "1")
        try createCharacter(character)
        let comic = ComicMock.makeComic(charactersID: [character.id, "-1"])
        var thrownError: Error?

        // When
        let feature = sut.create(comic, in: table)
        XCTAssertThrowsError(try feature.wait()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .itemNotFound(let itemID, let itemType) = error as? APIError {
            XCTAssertEqual(itemID, "-1")
            XCTAssertTrue(itemType == Character.self)
        } else {
            XCTFail("Expected '.itemNotFound' but got \(error)")
        }
    }

}
