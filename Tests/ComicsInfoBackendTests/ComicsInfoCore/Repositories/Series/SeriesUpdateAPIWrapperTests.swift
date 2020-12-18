//
//  SeriesUpdateAPIWrapperTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 22/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class SeriesUpdateAPIWrapperTests: XCTestCase, CreateCharacterProtocol, CreateSeriesProtocol, CreateComicProtocol {

    private var sut: SeriesUpdateAPIWrapper!
    private var table: String!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        DatabaseMock.removeAll()
        sut = SeriesUpdateAPIWrapperMock.make()
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
        let comic = ComicMock.makeComic()
        try createComic(comic)
        let series = SeriesMock.makeSeries(charactersID: [character.id], comicsID: [comic.id])

        // When
        let features = sut.getSummaryFutures(for: series, from: table)
        var items = [DatabaseUpdateItem]()
        for feature in features {
            items.append(contentsOf: try feature.wait())
        }

        // Then
        XCTAssertEqual(items.count, 4)
        XCTAssertTrue(
            items.contains(where: {
                $0.key["itemID"]?.value as? String == "series#\(series.id)" &&
                $0.key["summaryID"]?.value as? String  == "character#\(character.id)" &&
                $0.attributes["itemName"] as? String == "series"
            })
        )
        XCTAssertTrue(
            items.contains(where: {
                $0.key["itemID"]?.value as? String == "character#\(character.id)" &&
                $0.key["summaryID"]?.value as? String == "series#\(series.id)" &&
                $0.attributes["itemName"] as? String == "character"
            })
        )
        XCTAssertTrue(
            items.contains(where: {
                $0.key["itemID"]?.value as? String == "series#\(series.id)" &&
                $0.key["summaryID"]?.value as? String == "comic#\(comic.id)" &&
                $0.attributes["itemName"] as? String == "series"
            })
        )
        XCTAssertTrue(
            items.contains(where: {
                $0.key["itemID"]?.value as? String == "comic#\(comic.id)" &&
                $0.key["summaryID"]?.value as? String == "series#\(series.id)" &&
                $0.attributes["itemName"] as? String == "comic"
            })
        )
    }

    func test_whenAppendItemSummary_returnsItemsSummary() throws {
        // Given
        let comic = ComicMock.makeComic()
        let series = SeriesMock.makeSeries(comicsID: [comic.id])
        var dbItems = [DatabaseUpdateItem]()

        // When
        let items = sut.appendItemSummary([comic], item: series, dbItems: &dbItems, tableName: table)

        // Then
        XCTAssertEqual(items.count, 1)
        XCTAssertTrue(
            items.contains(where: {
                $0.key["itemID"]?.value as? String == "comic#\(comic.id)" &&
                $0.key["summaryID"]?.value as? String == "series#\(series.id)" &&
                $0.attributes["itemName"] as? String == "comic"
            })
        )
    }

    // MARK: - Update

    func test_whenUpdateSeries_seriesIsUpdated() throws {
        // Given
        try createSeries(SeriesMock.makeSeries(title: "Old Title"))

        // When
        let feature = sut.update(SeriesMock.makeSeries(), in: table)

        // Then
        XCTAssertNoThrow(try feature.wait())
    }

    func test_whenUpdateSeriesWithNotExistingCharacterID_throwsItemsNotFound() throws {
        // Given
        try createSeries(SeriesMock.makeSeries())
        let charactersID: Set<String> = ["-1"]
        var thrownError: Error?

        // When
        let feature = sut.update(SeriesMock.makeSeries(charactersID: charactersID), in: table)
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

    func test_whenUpdateSeriesWithNotExistingComicsID_throwsItemsNotFound() throws {
        // Given
        try createSeries(SeriesMock.makeSeries())
        let comicsID: Set<String> = ["-1"]
        var thrownError: Error?

        // When
        let feature = sut.update(SeriesMock.makeSeries(comicsID: comicsID), in: table)
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

    func test_whenUpdateSeries_seriesAndSeriesSummariesAreUpdated() throws {
        // Given
        let character = CharacterMock.makeCharacter(id: "1")
        try createCharacter(character)
        let comic = ComicMock.makeComic(id: "1")
        try createComic(comic)

        try createSeries(SeriesMock.makeSeries(charactersID: [character.id], comicsID: [comic.id]))

        // When
        let feature = sut.update(SeriesMock.makeSeries(title: "New Title"), in: table)

        // Then
        XCTAssertNoThrow(try feature.wait())
    }

    func test_whenUpdateSeriesWithCharactersIDAndComicsID_seriesAndSeriesSummariesAreUpdated() throws {
        // Given
        let character = CharacterMock.makeCharacter(id: "1")
        try createCharacter(character)
        let comic = ComicMock.makeComic(id: "1")
        try createComic(comic)

        try createSeries(SeriesMock.makeSeries())

        // When
        let feature = sut.update(SeriesMock.makeSeries(title: "New Title", charactersID: [character.id], comicsID: [comic.id]), in: table)

        // Then
        XCTAssertNoThrow(try feature.wait())
    }

}
