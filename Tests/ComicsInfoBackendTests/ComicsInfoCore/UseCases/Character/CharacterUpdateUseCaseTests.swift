//
//  CharacterUpdateUseCaseTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 28/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import NIO
import XCTest

final class CharacterUpdateUseCaseTests: XCTestCase, CreateCharacterProtocol, CreateSeriesProtocol, CreateComicProtocol {

    private var eventLoop: EventLoop!
    private var sut: CharacterUpdateUseCase!
    private var table: String!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        MockDB.removeAll()
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        table = String.tableName(for: "TEST")
        sut = CharacterUpdateUseCaseFactoryMock(items: [:], on: eventLoop).makeUseCase()
    }

    override func tearDownWithError() throws {
        eventLoop = nil
        sut = nil
        table = nil
    }
    
    func test_whenUpdateCharacter_characterIsUpdated() throws {
        // Given
        try createCharacter(CharacterFactory.make(name: "Old Name"))
        let item = CharacterFactory.make(name: "New Name")
        let criteria = UpdateItemCriteria(item: item, oldSortValue: item.sortValue, on: eventLoop, in: table)

        // When
        let feature = sut.update(with: criteria)
        let character = try feature.wait()

        // Then
        XCTAssertEqual(character.name, item.name)
    }

    func test_whenUpdateCharacterWithNotExistingSeriesID_throwsItemsNotFound() throws {
        // Given
        try createCharacter(CharacterFactory.make())
        let seriesID: Set<String> = ["-1"]
        let item = CharacterFactory.make(seriesID: seriesID)
        let criteria = UpdateItemCriteria(item: item, oldSortValue: item.sortValue, on: eventLoop, in: table)
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

    func test_whenUpdateCharacterWithNotExistingComicsID_throwsItemsNotFound() throws {
        // Given
        try createCharacter(CharacterFactory.make())
        let comicsID: Set<String> = ["-1"]
        let item = CharacterFactory.make(comicsID: comicsID)
        let criteria = UpdateItemCriteria(item: item, oldSortValue: item.sortValue, on: eventLoop, in: table)
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

    func test_whenUpdateCharacter_characterAndCharacterSummariesAreUpdated() throws {
        // Given
        let series = SeriesFactory.make(id: "1")
        try createSeries(series)
        let comic = ComicFactory.make(id: "1")
        try createComic(comic)

        try createCharacter(CharacterFactory.make(seriesID: [series.id], comicsID: [comic.id]))
        let item = CharacterFactory.make(name: "New Name")
        let criteria = UpdateItemCriteria(item: item, oldSortValue: item.sortValue, on: eventLoop, in: table)

        // When
        let feature = sut.update(with: criteria)

        // Then
        XCTAssertNoThrow(try feature.wait())
    }

    func test_whenUpdateCharacterWithSeriesIDAndComicsID_characterAndCharacterSummariesAreUpdated() throws {
        // Given
        let series = SeriesFactory.make(id: "1")
        try createSeries(series)
        let comic = ComicFactory.make(id: "1")
        try createComic(comic)

        try createCharacter(CharacterFactory.make())
        let item = CharacterFactory.make(
            name: "New Name",
            seriesID: [series.id],
            comicsID: [comic.id]
        )
        let criteria = UpdateItemCriteria(item: item, oldSortValue: item.sortValue, on: eventLoop, in: table)

        // When
        let feature = sut.update(with: criteria)

        // Then
        XCTAssertNoThrow(try feature.wait())
    }

    func test_whenUpdateCharacter_existingSummariesAreUpdated() throws {
        // Given
        let series = SeriesFactory.make(id: "SeriesID")
        try createSeries(series)
        let character = CharacterFactory.make(
            id: "CharacterID",
            popularity: 0,
            name: "Old Character Name",
            thumbnail: "Old Character Thumbnail",
            description: "Old Character Description",
            seriesID: [series.id]
        )
        try createCharacter(character)

        // When
        let newCharacter = CharacterFactory.make(
            id: "CharacterID",
            popularity: 1,
            name: "New Character Name",
            thumbnail: "New Character Thumbnail",
            description: "New Character Description"
        )
        let criteria = UpdateItemCriteria(item: newCharacter, oldSortValue: newCharacter.sortValue, on: eventLoop, in: table)
        let feature = sut.update(with: criteria)

        // Then
        XCTAssertNoThrow(try feature.wait())
        if let data = MockDB["CharacterSummary#CharacterID|SeriesSummary#SeriesID"],
           let characterSummary = try? JSONDecoder().decode(CharacterSummary.self, from: data) {
            XCTAssertEqual(characterSummary.popularity, newCharacter.popularity)
            XCTAssertEqual(characterSummary.name, newCharacter.name)
            XCTAssertEqual(characterSummary.thumbnail, newCharacter.thumbnail)
            XCTAssertEqual(characterSummary.description, newCharacter.description)
        } else {
            XCTFail("CharacterSummary with ID: CharacterSummary#CharacterID|SeriesSummary#SeriesID doesn't exist")
        }
    }
    
    func test_whenUpdateCharacterWithoutRealName_realNameDidntChange() throws {
        // Given
        let series = SeriesFactory.make(id: "SeriesID")
        try createSeries(series)
        let character = CharacterFactory.make(
            id: "CharacterID",
            realName: "Character Real Name",
            seriesID: [series.id]
        )
        try createCharacter(character)

        // When
        let newCharacter = CharacterFactory.make(id: "CharacterID", realName: nil)
        let criteria = UpdateItemCriteria(item: newCharacter, oldSortValue: newCharacter.sortValue, on: eventLoop, in: table)
        let feature = sut.update(with: criteria)

        // Then
        XCTAssertNoThrow(try feature.wait())
        if let data = MockDB["Character#CharacterID"],
           let characterSummary = try? JSONDecoder().decode(Character.self, from: data) {
            XCTAssertEqual(characterSummary.realName, character.realName)
        } else {
            XCTFail("Character with ID: CharacterID doesn't exist")
        }
    }
    
    func test_whenUpdateCharacterRealName_realNameIsUpdated() throws {
        // Given
        let series = SeriesFactory.make(id: "SeriesID")
        try createSeries(series)
        let character = CharacterFactory.make(id: "CharacterID", seriesID: [series.id])
        try createCharacter(character)

        // When
        let newCharacter = CharacterFactory.make(id: "CharacterID", realName: "Real Name")
        let criteria = UpdateItemCriteria(item: newCharacter, oldSortValue: newCharacter.sortValue, on: eventLoop, in: table)
        let feature = sut.update(with: criteria)

        // Then
        XCTAssertNoThrow(try feature.wait())
        if let data = MockDB["Character#CharacterID"],
           let characterSummary = try? JSONDecoder().decode(Character.self, from: data) {
            XCTAssertEqual(characterSummary.realName, newCharacter.realName)
        } else {
            XCTFail("Character with ID: CharacterID doesn't exist")
        }
    }
    
    func test_whenUpdateSummaryFields_summariesIsUpdated() throws {
        // Given
        let series = SeriesFactory.make(id: "SeriesID")
        try createSeries(series)
        let character = CharacterFactory.make(id: "CharacterID", name: "Old Name", seriesID: [series.id])
        try createCharacter(character)

        // When
        let newCharacter = CharacterFactory.make(id: "CharacterID", name: "New Name")
        let criteria = UpdateItemCriteria(item: newCharacter, oldSortValue: newCharacter.sortValue, on: eventLoop, in: table)
        let feature = sut.update(with: criteria)

        // Then
        XCTAssertNoThrow(try feature.wait())
        if let data = MockDB["CharacterSummary#CharacterID|SeriesSummary#SeriesID"],
           let characterSummary = try? JSONDecoder().decode(CharacterSummary.self, from: data) {
            XCTAssertNotEqual(characterSummary.dateAdded, characterSummary.dateLastUpdated)
        } else {
            XCTFail("CharacterSummary with ID: CharacterSummary#CharacterID|SeriesSummary#SeriesID doesn't exist")
        }
    }
    
    func test_whenUpdateWithoutSummaryFields_summariesIsnotUpdated() throws {
        // Given
        let series = SeriesFactory.make(id: "SeriesID")
        try createSeries(series)
        let character = CharacterFactory.make(id: "CharacterID", seriesID: [series.id])
        try createCharacter(character)

        // When
        let newCharacter = CharacterFactory.make(id: "CharacterID", realName: "Real Name")
        let criteria = UpdateItemCriteria(item: newCharacter, oldSortValue: newCharacter.sortValue, on: eventLoop, in: table)
        let feature = sut.update(with: criteria)

        // Then
        XCTAssertNoThrow(try feature.wait())
        if let data = MockDB["CharacterSummary#CharacterID|SeriesSummary#SeriesID"],
           let characterSummary = try? JSONDecoder().decode(CharacterSummary.self, from: data) {
            XCTAssertEqual(characterSummary.dateAdded, characterSummary.dateLastUpdated)
        } else {
            XCTFail("CharacterSummary with ID: CharacterSummary#CharacterID|SeriesSummary#SeriesID doesn't exist")
        }
    }
    
    func test_whenUpdateWithSeriesIDWhichAlreadyExists_throwSummariesAlreadyExist() throws {
        // Given
        let series = SeriesFactory.make(id: "SeriesID")
        try createSeries(series)
        let character = CharacterFactory.make(id: "CharacterID", seriesID: [series.id])
        try createCharacter(character)
        var thrownError: Error?

        // When
        let newCharacter = CharacterFactory.make(id: "CharacterID", seriesID: [series.id])
        let criteria = UpdateItemCriteria(item: newCharacter, oldSortValue: newCharacter.sortValue, on: eventLoop, in: table)
        let feature = sut.update(with: criteria)
        XCTAssertThrowsError(try feature.wait()) {
            thrownError = $0
        }
        
        // Then
        let error = try XCTUnwrap(thrownError)
        if case .summariesAlreadyExist(let IDs) = error as? ComicInfoError {
            XCTAssertEqual(IDs, ["SeriesSummary#SeriesID"])
        } else {
            XCTFail("Expected '.summariesAlreadyExist' but got \(error)")
        }
    }
    
    func test_whenUpdateWithComicIDWhichAlreadyExists_throwSummariesAlreadyExist() throws {
        // Given
        let comic = ComicFactory.make(id: "ComicID")
        try createComic(comic)
        let character = CharacterFactory.make(id: "CharacterID", comicsID: [comic.id])
        try createCharacter(character)
        var thrownError: Error?

        // When
        let newCharacter = CharacterFactory.make(id: "CharacterID", comicsID: [comic.id])
        let criteria = UpdateItemCriteria(item: newCharacter, oldSortValue: newCharacter.sortValue, on: eventLoop, in: table)
        let feature = sut.update(with: criteria)
        XCTAssertThrowsError(try feature.wait()) {
            thrownError = $0
        }
        
        // Then
        let error = try XCTUnwrap(thrownError)
        if case .summariesAlreadyExist(let IDs) = error as? ComicInfoError {
            XCTAssertEqual(IDs, ["ComicSummary#ComicID"])
        } else {
            XCTFail("Expected '.summariesAlreadyExist' but got \(error)")
        }
    }
    
    func test_whenUpdateWithSeriesAndComicIDWhichAlreadyExists_throwSummariesAlreadyExist() throws {
        // Given
        let series = SeriesFactory.make(id: "SeriesID")
        try createSeries(series)
        let comic = ComicFactory.make(id: "ComicID")
        try createComic(comic)
        let character = CharacterFactory.make(id: "CharacterID", seriesID: [series.id], comicsID: [comic.id])
        try createCharacter(character)
        var thrownError: Error?

        // When
        let newCharacter = CharacterFactory.make(id: "CharacterID", seriesID: [series.id], comicsID: [comic.id])
        let criteria = UpdateItemCriteria(item: newCharacter, oldSortValue: newCharacter.sortValue, on: eventLoop, in: table)
        let feature = sut.update(with: criteria)
        XCTAssertThrowsError(try feature.wait()) {
            thrownError = $0
        }
        
        // Then
        let error = try XCTUnwrap(thrownError)
        if case .summariesAlreadyExist(let IDs) = error as? ComicInfoError {
            XCTAssertEqual(IDs.sorted(), ["SeriesSummary#SeriesID", "ComicSummary#ComicID"].sorted())
        } else {
            XCTFail("Expected '.summariesAlreadyExist' but got \(error)")
        }
    }

}
