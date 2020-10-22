//
//  SeriesCreateAPIWrapperTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 21/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class SeriesCreateAPIWrapperTests: XCTestCase, CreateCharacterProtocol, CreateComicProtocol {

    private var sut: SeriesCreateAPIWrapper!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        DatabaseMock.removeAll()
        sut = SeriesCreateAPIWrapperMock.make()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_whenGetSummaryFutures_returnsAllSummaries() throws {
        // Given
        let character = CharacterMock.makeCharacter()
        try createCharacter(character)
        let comic = ComicMock.makeComic()
        try createComic(comic)
        let series = SeriesMock.makeSeries(charactersID: [character.id], comicsID: [comic.id])

        // When
        let features = sut.getSummaryFutures(for: series)
        var items = [DatabasePutItem]()
        for feature in features {
            items.append(contentsOf: try feature.wait())
        }

        // Then
        XCTAssertEqual(items.count, 4)
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
                $0.attributes["summaryID"] as? String == "series#\(series.id)" &&
                $0.attributes["itemName"] as? String == "character"
            })
        )
        XCTAssertTrue(
            items.contains(where: {
                $0.attributes["itemID"] as? String == "series#\(series.id)" &&
                $0.attributes["summaryID"] as? String == "comic#\(comic.id)" &&
                $0.attributes["itemName"] as? String == "series"
            })
        )
        XCTAssertTrue(
            items.contains(where: {
                $0.attributes["itemID"] as? String == "comic#\(comic.id)" &&
                $0.attributes["summaryID"] as? String == "series#\(series.id)" &&
                $0.attributes["itemName"] as? String == "comic"
            })
        )
    }

    func test_whenAppendItemSummary_returnsItemsSummary() throws {
        // Given
        let comic = ComicMock.makeComic()
        let series = SeriesMock.makeSeries(comicsID: [comic.id])
        var dbItems = [DatabasePutItem]()

        // When
        let items = sut.appendItemSummary([comic], item: series, dbItems: &dbItems)

        // Then
        XCTAssertEqual(items.count, 1)
        XCTAssertTrue(
            items.contains(where: {
                $0.attributes["itemID"] as? String == "comic#\(comic.id)" &&
                $0.attributes["summaryID"] as? String == "series#\(series.id)" &&
                $0.attributes["itemName"] as? String == "comic"
            })
        )
    }

    // MARK: - Create

    func test_whenCrateSeries_seriesIsCreated() throws {
        // Given

        // When
        let feature = sut.create(SeriesMock.makeSeries())

        // Then
        XCTAssertNoThrow(try feature.wait())
    }

    func test_whenSeriesTheSameSeriesTwice_throwsItemAlreadyExists() throws {
        // Given
        var feature = sut.create(SeriesMock.makeSeries())
        try feature.wait()
        var thrownError: Error?

        // When
        feature = sut.create(SeriesMock.makeSeries())
        XCTAssertThrowsError(try feature.wait()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .itemAlreadyExists(let itemID, let itemType) = error as? APIError {
            XCTAssertEqual(itemID, "series#1|series#1")
            XCTAssertTrue(itemType == Series.self)
        } else {
            XCTFail("Expected '.itemAlreadyExists' but got \(error)")
        }
    }

    func test_whenCrateSeriesWithNotExistingCharacterID_throwsItemsNotFound() throws {
        // Given
        let charactersID: Set<String> = ["-1"]
        var thrownError: Error?

        // When
        let feature = sut.create(SeriesMock.makeSeries(charactersID: charactersID))
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

    func test_whenCrateSeriesWithNotExistingComicsID_throwsItemsNotFound() throws {
        // Given
        let comicsID: Set<String> = ["-1"]
        var thrownError: Error?

        // When
        let feature = sut.create(SeriesMock.makeSeries(comicsID: comicsID))
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

    func test_whenCrateSeriesWithCharactersIDAndComicsID_seriesAndSeriesSummariesAreCreated() throws {
        // Given
        let character = CharacterMock.makeCharacter(id: "1")
        try createCharacter(character)
        let comic = ComicMock.makeComic(id: "1")
        try createComic(comic)

        // When
        let feature = sut.create(SeriesMock.makeSeries(charactersID: [character.id], comicsID: [comic.id]))

        // Then
        XCTAssertNoThrow(try feature.wait())
    }

    func test_whenCrateSeriesWithOneNotExistingCharacterID_throwsItemNotFound() throws {
        // Given
        let character = CharacterMock.makeCharacter(id: "1")
        try createCharacter(character)
        let series = SeriesMock.makeSeries(charactersID: [character.id, "-1"])
        var thrownError: Error?

        // When
        let feature = sut.create(series)
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

    func test_whenCrateSeriesWithOneNotExistingComicID_throwsItemNotFound() throws {
        // Given
        let comic = ComicMock.makeComic(id: "1")
        try createComic(comic)
        let series = SeriesMock.makeSeries(comicsID: [comic.id, "-1"])
        var thrownError: Error?

        // When
        let feature = sut.create(series)
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
