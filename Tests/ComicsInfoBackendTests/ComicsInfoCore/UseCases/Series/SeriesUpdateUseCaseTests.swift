//
//  SeriesUpdateUseCaseTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 28/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import NIO
import XCTest

final class SeriesUpdateUseCaseTests: XCTestCase, CreateCharacterProtocol, CreateSeriesProtocol, CreateComicProtocol {

    private var eventLoop: EventLoop!
    private var sut: SeriesUpdateUseCase!
    private var table: String!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        MockDB.removeAll()
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        table = String.tableName(for: "TEST")
        sut = SeriesUpdateUseCaseFactoryMock(on: eventLoop).makeUseCase()
    }

    override func tearDownWithError() throws {
        eventLoop = nil
        sut = nil
        table = nil
    }

    func test_whenUpdateSeries_seriesIsUpdated() throws {
        // Given
        try createSeries(SeriesFactory.make(title: "Old Title"))
        let criteria = UpdateItemCriteria(item: SeriesFactory.make(), on: eventLoop, in: table)

        // When
        let feature = sut.update(with: criteria)

        // Then
        XCTAssertNoThrow(try feature.wait())
    }

    func test_whenUpdateSeriesWithNotExistingCharacterID_throwsItemsNotFound() throws {
        // Given
        try createSeries(SeriesFactory.make())
        let charactersID: Set<String> = ["-1"]
        let criteria = UpdateItemCriteria(item: SeriesFactory.make(charactersID: charactersID), on: eventLoop, in: table)
        var thrownError: Error?

        // When
        let feature = sut.update(with: criteria)
        XCTAssertThrowsError(try feature.wait()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .itemsNotFound(let itemIDs, let itemType) = error as? ComicInfoError {
            XCTAssertEqual(itemIDs, ["-1"])
            XCTAssertTrue(itemType == Character.self)
        } else {
            XCTFail("Expected '.itemsNotFound' but got \(error)")
        }
    }

    func test_whenUpdateSeriesWithNotExistingComicsID_throwsItemsNotFound() throws {
        // Given
        try createSeries(SeriesFactory.make())
        let comicsID: Set<String> = ["-1"]
        let criteria = UpdateItemCriteria(item: SeriesFactory.make(comicsID: comicsID), on: eventLoop, in: table)
        var thrownError: Error?

        // When
        let feature = sut.update(with: criteria)
        XCTAssertThrowsError(try feature.wait()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .itemsNotFound(let itemIDs, let itemType) = error as? ComicInfoError {
            XCTAssertEqual(itemIDs, ["-1"])
            XCTAssertTrue(itemType == Comic.self)
        } else {
            XCTFail("Expected '.itemsNotFound' but got \(error)")
        }
    }

    func test_whenUpdateSeries_seriesAndSeriesSummariesAreUpdated() throws {
        // Given
        let character = CharacterFactory.make(id: "1")
        try createCharacter(character)
        let comic = ComicFactory.make(id: "1")
        try createComic(comic)

        try createSeries(SeriesFactory.make(charactersID: [character.id], comicsID: [comic.id]))
        let criteria = UpdateItemCriteria(item: SeriesFactory.make(title: "New Title"), on: eventLoop, in: table)

        // When
        let feature = sut.update(with: criteria)

        // Then
        XCTAssertNoThrow(try feature.wait())
    }

    func test_whenUpdateSeriesWithCharactersIDAndComicsID_seriesAndSeriesSummariesAreUpdated() throws {
        // Given
        let character = CharacterFactory.make(id: "1")
        try createCharacter(character)
        let comic = ComicFactory.make(id: "1")
        try createComic(comic)

        try createSeries(SeriesFactory.make())
        let criteria = UpdateItemCriteria(
            item: SeriesFactory.make(
                title: "New Title",
                charactersID: [character.id],
                comicsID: [comic.id]
            ),
            on: eventLoop,
            in: table
        )


        // When
        let feature = sut.update(with: criteria)

        // Then
        XCTAssertNoThrow(try feature.wait())
    }
    
    func test_whenUpdateSeries_existingSummariesAreUpdated() throws {
        // Given
        let character = CharacterFactory.make(id: "CharacterID")
        try createCharacter(character)
        let series = SeriesFactory.make(
            id: "SeriesID",
            popularity: 0,
            title: "Old Series Title",
            thumbnail: "Old Series Thumbnail",
            description: "Old Series Description",
            charactersID: [character.id]
        )
        try createSeries(series)

        // When
        let newSeries = SeriesFactory.make(
            id: "SeriesID",
            popularity: 1,
            title: "New Series Title",
            thumbnail: "New Series Thumbnail",
            description: "New Series Description"
        )
        let criteria = UpdateItemCriteria(item: newSeries, on: eventLoop, in: table)
        let feature = sut.update(with: criteria)

        // Then
        XCTAssertNoThrow(try feature.wait())
        if let data = MockDB["Series#SeriesID|Character#CharacterID"],
           let seriesSummary = try? JSONDecoder().decode(SeriesSummary.self, from: data) {
            XCTAssertEqual(seriesSummary.popularity, newSeries.popularity)
            XCTAssertEqual(seriesSummary.name, newSeries.name)
            XCTAssertEqual(seriesSummary.thumbnail, newSeries.thumbnail)
            XCTAssertEqual(seriesSummary.description, newSeries.description)
        } else {
            XCTFail("SeriesSummary with ID: Series#SeriesID|Character#CharacterID doesn't exist")
        }
    }
    
    func test_whenUpdateWithCharacterIDWhichAlreadyExists_throwSummariesAlreadyExist() throws {
        // Given
        let character = CharacterFactory.make(id: "CharacterID")
        try createCharacter(character)
        let series = SeriesFactory.make(id: "SeriesID", charactersID: [character.id])
        try createSeries(series)
        var thrownError: Error?

        // When
        let newSeries = SeriesFactory.make(id: "SeriesID", charactersID: [character.id])
        let criteria = UpdateItemCriteria(item: newSeries, on: eventLoop, in: table)
        let feature = sut.update(with: criteria)
        XCTAssertThrowsError(try feature.wait()) {
            thrownError = $0
        }
        
        // Then
        let error = try XCTUnwrap(thrownError)
        if case .summariesAlreadyExist(let IDs) = error as? ComicInfoError {
            XCTAssertEqual(IDs, ["Character#CharacterID"])
        } else {
            XCTFail("Expected '.summariesAlreadyExist' but got \(error)")
        }
    }
    
    func test_whenUpdateWithComicIDWhichAlreadyExists_throwSummariesAlreadyExist() throws {
        // Given
        let comic = ComicFactory.make(id: "ComicID")
        try createComic(comic)
        let series = SeriesFactory.make(id: "SeriesID", comicsID: [comic.id])
        try createSeries(series)
        var thrownError: Error?

        // When
        let newSeries = SeriesFactory.make(id: "SeriesID", comicsID: [comic.id])
        let criteria = UpdateItemCriteria(item: newSeries, on: eventLoop, in: table)
        let feature = sut.update(with: criteria)
        XCTAssertThrowsError(try feature.wait()) {
            thrownError = $0
        }
        
        // Then
        let error = try XCTUnwrap(thrownError)
        if case .summariesAlreadyExist(let IDs) = error as? ComicInfoError {
            XCTAssertEqual(IDs, ["Comic#ComicID"])
        } else {
            XCTFail("Expected '.summariesAlreadyExist' but got \(error)")
        }
    }
    
    func test_whenUpdateWithCharacterAndComicIDWhichAlreadyExists_throwSummariesAlreadyExist() throws {
        // Given
        let character = CharacterFactory.make(id: "CharacterID")
        try createCharacter(character)
        let comic = ComicFactory.make(id: "ComicID")
        try createComic(comic)
        let series = SeriesFactory.make(id: "SeriesID", charactersID: [character.id], comicsID: [comic.id])
        try createSeries(series)
        var thrownError: Error?

        // When
        let newSeries = SeriesFactory.make(id: "SeriesID", charactersID: [character.id], comicsID: [comic.id])
        let criteria = UpdateItemCriteria(item: newSeries, on: eventLoop, in: table)
        let feature = sut.update(with: criteria)
        XCTAssertThrowsError(try feature.wait()) {
            thrownError = $0
        }
        
        // Then
        let error = try XCTUnwrap(thrownError)
        if case .summariesAlreadyExist(let IDs) = error as? ComicInfoError {
            XCTAssertEqual(IDs.sorted(), ["Character#CharacterID", "Comic#ComicID"].sorted())
        } else {
            XCTFail("Expected '.summariesAlreadyExist' but got \(error)")
        }
    }
    
}
