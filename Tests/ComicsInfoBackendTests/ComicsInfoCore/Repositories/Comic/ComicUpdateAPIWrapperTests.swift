//
//  ComicUpdateAPIWrapperTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 22/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class ComicUpdateAPIWrapperTests: XCTestCase, CreateCharacterProtocol, CreateSeriesProtocol, CreateComicProtocol {

    private var sut: ComicUpdateAPIWrapper!
    private var table: String!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        DatabaseMock.removeAll()
        sut = ComicUpdateAPIWrapperMock.make(tables: [:])
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
        let features = sut.getSummaryFutures(for: comic, from: table)
        var items = [DatabaseUpdateItem]()
        for feature in features {
            items.append(contentsOf: try feature.wait())
        }

        // Then
        XCTAssertEqual(items.count, 4)
        XCTAssertTrue(
            items.contains(where: {
                $0.key["itemID"]?.value as? String == "comic#\(comic.id)" &&
                $0.key["summaryID"]?.value as? String == "character#\(character.id)" &&
                $0.attributes["itemName"] as? String == "comic"
            })
        )
        XCTAssertTrue(
            items.contains(where: {
                $0.key["itemID"]?.value as? String == "character#\(character.id)" &&
                $0.key["summaryID"]?.value as? String == "comic#\(comic.id)" &&
                $0.attributes["itemName"] as? String == "character"
            })
        )
        XCTAssertTrue(
            items.contains(where: {
                $0.key["itemID"]?.value as? String == "comic#\(comic.id)" &&
                $0.key["summaryID"]?.value as? String == "series#\(series.id)" &&
                $0.attributes["itemName"] as? String == "comic"
            })
        )
        XCTAssertTrue(
            items.contains(where: {
                $0.key["itemID"]?.value as? String == "series#\(series.id)" &&
                $0.key["summaryID"]?.value as? String == "comic#\(comic.id)" &&
                $0.attributes["itemName"] as? String == "series"
            })
        )
    }

    func test_whenAppendItemSummary_returnsItemsSummary() throws {
        // Given
        let character = CharacterMock.makeCharacter()
        let comic = ComicMock.makeComic(charactersID: [character.id])
        var dbItems = [DatabaseUpdateItem]()

        // When
        let items = sut.appendItemSummary([character], item: comic, dbItems: &dbItems, tableName: table)

        // Then
        XCTAssertEqual(items.count, 1)
        XCTAssertTrue(
            items.contains(where: {
                $0.key["itemID"]?.value as? String == "character#\(character.id)" &&
                $0.key["summaryID"]?.value as? String == "comic#\(comic.id)" &&
                $0.attributes["itemName"] as? String == "character"
            })
        )
    }

    // MARK: - Update

    func test_whenUpdateComic_comicIsUpdated() throws {
        // Given
        try createComic(ComicMock.makeComic(title: "Old Title"))

        // When
        let feature = sut.update(ComicMock.makeComic(), in: table)

        // Then
        XCTAssertNoThrow(try feature.wait())
    }

    func test_whenUpdateComicWithNotExistingSeriesID_throwsItemsNotFound() throws {
        // Given
        try createComic(ComicMock.makeComic())
        let seriesID: Set<String> = ["-1"]
        var thrownError: Error?

        // When
        let feature = sut.update(ComicMock.makeComic(seriesID: seriesID), in: table)
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

    func test_whenUpdateComicWithNotExistingCharactersID_throwsItemsNotFound() throws {
        // Given
        try createComic(ComicMock.makeComic())
        let charactersID: Set<String> = ["-1"]
        var thrownError: Error?

        // When
        let feature = sut.update(ComicMock.makeComic(charactersID: charactersID), in: table)
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

    func test_whenUpdateComic_comicAndComicSummariesAreUpdated() throws {
        // Given
        let character = CharacterMock.makeCharacter(id: "1")
        try createCharacter(character)
        let series = SeriesMock.makeSeries(id: "1")
        try createSeries(series)

        try createComic(ComicMock.makeComic(charactersID: [character.id], seriesID: [series.id]))

        // When
        let feature = sut.update(ComicMock.makeComic(title: "New Title"), in: table)

        // Then
        XCTAssertNoThrow(try feature.wait())
    }

    func test_whenUpdateComicWithCharactersIDAndSeriesID_comicAndComicSummariesAreUpdated() throws {
        // Given
        let character = CharacterMock.makeCharacter(id: "1")
        try createCharacter(character)
        let series = SeriesMock.makeSeries(id: "1")
        try createSeries(series)

        try createComic(ComicMock.makeComic())

        // When
        let feature = sut.update(ComicMock.makeComic(title: "New Title", charactersID: [character.id], seriesID: [series.id]), in: table)

        // Then
        XCTAssertNoThrow(try feature.wait())
    }

}
