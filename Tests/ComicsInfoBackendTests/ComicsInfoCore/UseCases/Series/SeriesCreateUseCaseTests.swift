//
//  SeriesCreateUseCaseTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 28/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import NIO
import XCTest

final class SeriesCreateUseCaseTests: XCTestCase, CreateCharacterProtocol, CreateComicProtocol {

    private var eventLoop: EventLoop!
    private var sut: SeriesCreateUseCase!
    private var table: String!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        MockDB.removeAll()
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        sut = SeriesCreateUseCaseFactoryMock(on: eventLoop).makeUseCase()
        table = String.tableName(for: "TEST")
    }

    override func tearDownWithError() throws {
        eventLoop = nil
        sut = nil
        table = nil
    }

    func test_whenCrateComic_comicIsCreated() throws {
        // Given
        let criteria = CreateItemCriteria(item: SeriesFactory.make(), on: eventLoop, in: table)

        // When
        let feature = sut.create(with: criteria)

        // Then
        XCTAssertNoThrow(try feature.wait())
    }
    
    func test_whenCrateSeriesWithNotExistingCharacterID_throwsItemsNotFound() throws {
        // Given
        let charactersID: Set<String> = ["-1"]
        let criteria = CreateItemCriteria(
            item: SeriesFactory.make(charactersID: charactersID),
            on: eventLoop,
            in: table
        )
        var thrownError: Error?

        // When
        let feature = sut.create(with: criteria)
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

    func test_whenCrateSeriesWithNotExistingComicsID_throwsItemsNotFound() throws {
        // Given
        let comicsID: Set<String> = ["-1"]
        let criteria = CreateItemCriteria(
            item: SeriesFactory.make(comicsID: comicsID),
            on: eventLoop,
            in: table
        )
        var thrownError: Error?

        // When
        let feature = sut.create(with: criteria)
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

    func test_whenCrateSeriesWithCharactersIDAndComicsID_seriesAndSeriesSummariesAreCreated() throws {
        // Given
        let character = CharacterFactory.make(id: "CharacterID")
        try createCharacter(character)
        let comic = ComicFactory.make(id: "ComicID")
        try createComic(comic)
        let criteria = CreateItemCriteria(
            item: SeriesFactory.make(id: "SeriesID", charactersID: [character.id], comicsID: [comic.id]),
            on: eventLoop,
            in: table
        )

        // When
        let feature = sut.create(with: criteria)

        // Then
        XCTAssertNoThrow(try feature.wait())
        XCTAssertNotNil(MockDB["Series#SeriesID"])
        XCTAssertNotNil(MockDB["Character#CharacterID|Series#SeriesID"])
        XCTAssertNotNil(MockDB["Comic#ComicID|Series#SeriesID"])
    }

    func test_whenCrateSeriesWithOneNotExistingCharacterID_throwsItemNotFound() throws {
        // Given
        let character = CharacterFactory.make(id: "1")
        try createCharacter(character)
        let series = SeriesFactory.make(charactersID: [character.id, "-1"])
        let criteria = CreateItemCriteria(item: series, on: eventLoop, in: table)
        var thrownError: Error?

        // When
        let feature = sut.create(with: criteria)
        XCTAssertThrowsError(try feature.wait()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .itemsNotFound(let IDs, let itemType) = error as? ComicInfoError {
            XCTAssertEqual(IDs, ["-1"])
            XCTAssertTrue(itemType == Character.self)
        } else {
            XCTFail("Expected '.itemsNotFound' but got \(error)")
        }
    }

    func test_whenCrateSeriesWithOneNotExistingComicID_throwsItemNotFound() throws {
        // Given
        let comic = ComicFactory.make(id: "1")
        try createComic(comic)
        let series = SeriesFactory.make(comicsID: [comic.id, "-1"])
        let criteria = CreateItemCriteria(item: series, on: eventLoop, in: table)
        var thrownError: Error?

        // When
        let feature = sut.create(with: criteria)
        XCTAssertThrowsError(try feature.wait()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .itemsNotFound(let IDs, let itemType) = error as? ComicInfoError {
            XCTAssertEqual(IDs, ["-1"])
            XCTAssertTrue(itemType == Comic.self)
        } else {
            XCTFail("Expected '.itemsNotFound' but got \(error)")
        }
    }
    
}
