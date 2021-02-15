//
//  ComicUpdateUseCaseTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 28/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import NIO
import XCTest

final class ComicUpdateUseCaseTests: XCTestCase, CreateCharacterProtocol, CreateSeriesProtocol, CreateComicProtocol {

    private var eventLoop: EventLoop!
    private var sut: ComicUpdateUseCase!
    private var table: String!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        MockDB.removeAll()
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        table = String.tableName(for: "TEST")
        sut = ComicUpdateUseCaseFactoryMock(on: eventLoop).makeUseCase()
    }

    override func tearDownWithError() throws {
        eventLoop = nil
        sut = nil
        table = nil
    }

    func test_whenUpdateComic_comicIsUpdated() throws {
        // Given
        try createComic(ComicFactory.make(title: "Old Title"))
        let criteria = UpdateItemCriteria(item: ComicFactory.make(), on: eventLoop, in: table)

        // When
        let feature = sut.update(with: criteria)

        // Then
        XCTAssertNoThrow(try feature.wait())
    }

    func test_whenUpdateComicWithNotExistingSeriesID_throwsItemsNotFound() throws {
        // Given
        try createComic(ComicFactory.make())
        let seriesID: Set<String> = ["-1"]
        let criteria = UpdateItemCriteria(item: ComicFactory.make(seriesID: seriesID), on: eventLoop, in: table)
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
            XCTAssertTrue(itemType == Series.self)
        } else {
            XCTFail("Expected '.itemsNotFound' but got \(error)")
        }
    }

    func test_whenUpdateComicWithNotExistingCharactersID_throwsItemsNotFound() throws {
        // Given
        try createComic(ComicFactory.make())
        let charactersID: Set<String> = ["-1"]
        let criteria = UpdateItemCriteria(item: ComicFactory.make(charactersID: charactersID), on: eventLoop, in: table)
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

    func test_whenUpdateComic_comicAndComicSummariesAreUpdated() throws {
        // Given
        let character = CharacterFactory.make(id: "1")
        try createCharacter(character)
        let series = SeriesFactory.make(id: "1")
        try createSeries(series)

        try createComic(ComicFactory.make(charactersID: [character.id], seriesID: [series.id]))
        let criteria = UpdateItemCriteria(item: ComicFactory.make(title: "New Title"), on: eventLoop, in: table)

        // When
        let feature = sut.update(with: criteria)

        // Then
        XCTAssertNoThrow(try feature.wait())
    }

    func test_whenUpdateComicWithCharactersIDAndSeriesID_comicAndComicSummariesAreUpdated() throws {
        // Given
        let character = CharacterFactory.make(id: "1")
        try createCharacter(character)
        let series = SeriesFactory.make(id: "1")
        try createSeries(series)

        try createComic(ComicFactory.make())
        let criteria = UpdateItemCriteria(
            item: ComicFactory.make(title: "New Title", charactersID: [character.id], seriesID: [series.id]),
            on: eventLoop,
            in: table
        )

        // When
        let feature = sut.update(with: criteria)

        // Then
        XCTAssertNoThrow(try feature.wait())
    }
    
    func test_whenUpdateComic_existingSummariesAreUpdated() throws {
        // Given
        let series = SeriesFactory.make(id: "SeriesID")
        try createSeries(series)
        let comic = ComicFactory.make(
            id: "ComicID",
            popularity: 0,
            title: "Old Comic Title",
            thumbnail: "Old Comic Thumbnail",
            description: "Old Comic Description",
            seriesID: [series.id]
        )
        try createComic(comic)

        // When
        let newComic = ComicFactory.make(
            id: "ComicID",
            popularity: 1,
            title: "New Comic Title",
            thumbnail: "New Comic Thumbnail",
            description: "New Comic Description"
        )
        let criteria = UpdateItemCriteria(item: newComic, on: eventLoop, in: table)
        let feature = sut.update(with: criteria)

        // Then
        XCTAssertNoThrow(try feature.wait())
        if let data = MockDB["Comic#ComicID|Series#SeriesID"],
           let comicSummary = try? JSONDecoder().decode(ComicSummary.self, from: data) {
            XCTAssertEqual(comicSummary.popularity, newComic.popularity)
            XCTAssertEqual(comicSummary.name, newComic.name)
            XCTAssertEqual(comicSummary.thumbnail, newComic.thumbnail)
            XCTAssertEqual(comicSummary.description, newComic.description)
        } else {
            XCTFail("CoimcSummary with ID: Comic#ComicID|Series#SeriesID doesn't exist")
        }
    }
    
    func test_whenUpdateComic_characterSummaryForSeriesIsUpdated() throws {
        // Given
        let series = SeriesFactory.make(id: "SeriesID")
        try createSeries(series)
        let character = CharacterFactory.make(id: "CharacterID")
        try createCharacter(character)
        let comic = ComicFactory.make(id: "ComicID")
        try createComic(comic)

        // When
        let newComic = ComicFactory.make(
            id: "ComicID",
            charactersID: [character.id],
            seriesID: [series.id]
        )
        let criteria = UpdateItemCriteria(item: newComic, on: eventLoop, in: table)
        let feature = sut.update(with: criteria)

        // Then
        XCTAssertNoThrow(try feature.wait())
        if let data = MockDB["Character#CharacterID|Series#SeriesID"],
           let characterSummary = try? JSONDecoder().decode(CharacterSummary.self, from: data) {
            XCTAssertEqual(characterSummary.count, 1)
        } else {
            XCTFail("characterSummary with ID: Character#CharacterID|Series#SeriesID doesn't exist")
        }
    }
    
    func test_whenUpdateComic_characterSummaryForSeriesCountIsUpdated() throws {
        // Given
        let series = SeriesFactory.make(id: "SeriesID")
        try createSeries(series)
        let character = CharacterFactory.make(id: "CharacterID")
        try createCharacter(character)
        let comic = ComicFactory.make(id: "ComicID", charactersID: [character.id], seriesID: [series.id])
        try createComic(comic)
        
        let comic2 = ComicFactory.make(id: "ComicID2")
        try createComic(comic2)

        // When
        let newComic = ComicFactory.make(
            id: "ComicID2",
            charactersID: [character.id],
            seriesID: [series.id]
        )
        let criteria = UpdateItemCriteria(item: newComic, on: eventLoop, in: table)
        let feature = sut.update(with: criteria)

        // Then
        XCTAssertNoThrow(try feature.wait())
        if let data = MockDB["Character#CharacterID|Series#SeriesID"],
           let characterSummary = try? JSONDecoder().decode(CharacterSummary.self, from: data) {
            XCTAssertEqual(characterSummary.count, 2)
        } else {
            XCTFail("characterSummary with ID: Character#CharacterID|Series#SeriesID doesn't exist")
        }
    }
    
    func test_whenUpdateWithCharacterIDWhichAlreadyExists_throwSummariesAlreadyExist() throws {
        // Given
        let character = CharacterFactory.make(id: "CharacterID")
        try createCharacter(character)
        let comic = ComicFactory.make(id: "ComicID", charactersID: [character.id])
        try createComic(comic)
        var thrownError: Error?

        // When
        let newComic = ComicFactory.make(id: "ComicID", charactersID: [character.id])
        let criteria = UpdateItemCriteria(item: newComic, on: eventLoop, in: table)
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
    
    func test_whenUpdateWithSeriesIDWhichAlreadyExists_throwSummariesAlreadyExist() throws {
        // Given
        let series = SeriesFactory.make(id: "SeriesID")
        try createSeries(series)
        let comic = ComicFactory.make(id: "ComicID", seriesID: [series.id])
        try createComic(comic)
        var thrownError: Error?

        // When
        let newComic = ComicFactory.make(id: "ComicID", seriesID: [series.id])
        let criteria = UpdateItemCriteria(item: newComic, on: eventLoop, in: table)
        let feature = sut.update(with: criteria)
        XCTAssertThrowsError(try feature.wait()) {
            thrownError = $0
        }
        
        // Then
        let error = try XCTUnwrap(thrownError)
        if case .summariesAlreadyExist(let IDs) = error as? ComicInfoError {
            XCTAssertEqual(IDs, ["Series#SeriesID"])
        } else {
            XCTFail("Expected '.summariesAlreadyExist' but got \(error)")
        }
    }
    
    func test_whenUpdateWithCharacterAndSeriesIDWhichAlreadyExists_throwSummariesAlreadyExist() throws {
        // Given
        let character = CharacterFactory.make(id: "CharacterID")
        try createCharacter(character)
        let series = SeriesFactory.make(id: "SeriesID")
        try createSeries(series)
        let comic = ComicFactory.make(id: "ComicID", charactersID: [character.id], seriesID: [series.id])
        try createComic(comic)
        var thrownError: Error?

        // When
        let newComic = ComicFactory.make(id: "ComicID", charactersID: [character.id], seriesID: [series.id])
        let criteria = UpdateItemCriteria(item: newComic, on: eventLoop, in: table)
        let feature = sut.update(with: criteria)
        XCTAssertThrowsError(try feature.wait()) {
            thrownError = $0
        }
        
        // Then
        let error = try XCTUnwrap(thrownError)
        if case .summariesAlreadyExist(let IDs) = error as? ComicInfoError {
            XCTAssertEqual(IDs.sorted(), ["Character#CharacterID", "Series#SeriesID"].sorted())
        } else {
            XCTFail("Expected '.summariesAlreadyExist' but got \(error)")
        }
    }
    
}
