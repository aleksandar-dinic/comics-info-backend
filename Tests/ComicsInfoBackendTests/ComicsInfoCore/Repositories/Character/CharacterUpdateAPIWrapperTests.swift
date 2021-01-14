//
//  CharacterUpdateAPIWrapperTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 21/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest

final class CharacterUpdateAPIWrapperTests: XCTestCase, CreateCharacterProtocol, CreateSeriesProtocol, CreateComicProtocol {

    private var sut: CharacterUpdateAPIWrapper!
    private var table: String!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        DatabaseMock.removeAll()
        sut = CharacterUpdateAPIWrapperMock.make(items: [:])
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
        let features = sut.getSummaryFutures(for: character, from: table)
        var items = [DatabaseUpdateItem]()
        for feature in features {
            items.append(contentsOf: try feature.wait())
        }

        // Then
        XCTAssertEqual(items.count, 4)
        XCTAssertTrue(
            items.contains(where: {
                $0.key["itemID"]?.value as? String == "character#\(character.id)" &&
                $0.key["summaryID"]?.value as? String  == "series#\(series.id)" &&
                $0.attributes["itemName"] as? String == "character"
            })
        )
        XCTAssertTrue(
            items.contains(where: {
                $0.key["itemID"]?.value as? String == "series#\(series.id)" &&
                $0.key["summaryID"]?.value as? String == "character#\(character.id)" &&
                $0.attributes["itemName"] as? String == "series"
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
                $0.key["summaryID"]?.value as? String == "character#\(character.id)" &&
                $0.attributes["itemName"] as? String == "comic"
            })
        )
    }

    func test_whenAppendItemSummary_returnsItemsSummary() throws {
        // Given
        let comic = ComicMock.makeComic()
        let character = CharacterMock.makeCharacter(comicsID: [comic.id])
        var dbItems = [DatabaseUpdateItem]()

        // When
        let items = sut.appendItemSummary([comic], item: character, dbItems: &dbItems, tableName: table)

        // Then
        XCTAssertEqual(items.count, 1)
        XCTAssertTrue(
            items.contains(where: {
                $0.key["itemID"]?.value as? String == "comic#\(comic.id)" &&
                $0.key["summaryID"]?.value as? String == "character#\(character.id)" &&
                $0.attributes["itemName"] as? String == "comic"
            })
        )
    }

    // MARK: - Update

    func test_whenUpdateCharacter_characterIsUpdated() throws {
        // Given
        try createCharacter(CharacterMock.makeCharacter(name: "Old Name"))

        // When
        let feature = sut.update(CharacterMock.makeCharacter(), in: table)

        // Then
        XCTAssertNoThrow(try feature.wait())
    }

    func test_whenUpdateCharacterWithNotExistingSeriesID_throwsItemsNotFound() throws {
        // Given
        try createCharacter(CharacterMock.makeCharacter())
        let seriesID: Set<String> = ["-1"]
        var thrownError: Error?

        // When
        let feature = sut.update(CharacterMock.makeCharacter(seriesID: seriesID), in: table)
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

    func test_whenUpdateCharacterWithNotExistingComicsID_throwsItemsNotFound() throws {
        // Given
        try createCharacter(CharacterMock.makeCharacter())
        let comicsID: Set<String> = ["-1"]
        var thrownError: Error?

        // When
        let feature = sut.update(CharacterMock.makeCharacter(comicsID: comicsID), in: table)
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

    func test_whenUpdateCharacter_characterAndCharacterSummariesAreUpdated() throws {
        // Given
        let series = SeriesMock.makeSeries(id: "1")
        try createSeries(series)
        let comic = ComicMock.makeComic(id: "1")
        try createComic(comic)

        try createCharacter(CharacterMock.makeCharacter(seriesID: [series.id], comicsID: [comic.id]))

        // When
        let feature = sut.update(CharacterMock.makeCharacter(name: "New Name"), in: table)

        // Then
        XCTAssertNoThrow(try feature.wait())
    }

    func test_whenUpdateCharacterWithSeriesIDAndComicsID_characterAndCharacterSummariesAreUpdated() throws {
        // Given
        let series = SeriesMock.makeSeries(id: "1")
        try createSeries(series)
        let comic = ComicMock.makeComic(id: "1")
        try createComic(comic)

        try createCharacter(CharacterMock.makeCharacter())

        // When
        let feature = sut.update(CharacterMock.makeCharacter(name: "New Name", seriesID: [series.id], comicsID: [comic.id]), in: table)

        // Then
        XCTAssertNoThrow(try feature.wait())
    }

}
