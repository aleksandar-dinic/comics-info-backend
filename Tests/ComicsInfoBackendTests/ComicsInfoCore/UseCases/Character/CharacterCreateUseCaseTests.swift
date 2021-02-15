//
//  CharacterCreateUseCaseTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 28/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import NIO
import XCTest

final class CharacterCreateUseCaseTests: XCTestCase, CreateSeriesProtocol, CreateComicProtocol {

    private var eventLoop: EventLoop!
    private var sut: CharacterCreateUseCase!
    private var table: String!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        MockDB.removeAll()
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        sut = CharacterCreateUseCaseFactoryMock(on: eventLoop).makeUseCase()
        table = String.tableName(for: "TEST")
    }

    override func tearDownWithError() throws {
        eventLoop = nil
        sut = nil
        table = nil
    }

    func test_whenCrateCharacter_characterIsCreated() throws {
        // Given
        let criteria = CreateItemCriteria(item: CharacterFactory.make(), on: eventLoop, in: table)

        // When
        let feature = sut.create(with: criteria)

        // Then
        XCTAssertNoThrow(try feature.wait())
    }
    
    func test_whenCrateCharacterWithNotExistingSeriesID_throwsItemsNotFound() throws {
        // Given
        let seriesID: Set<String> = ["-1"]
        let criteria = CreateItemCriteria(
            item: CharacterFactory.make(seriesID: seriesID),
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
            XCTAssertTrue(itemType == Series.self)
        } else {
            XCTFail("Expected '.itemsNotFound' but got \(error)")
        }
    }

    func test_whenCrateCharacterWithNotExistingComicsID_throwsItemsNotFound() throws {
        // Given
        let comicsID: Set<String> = ["-1"]
        let criteria = CreateItemCriteria(
            item: CharacterFactory.make(comicsID: comicsID),
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

    func test_whenCrateCharacterWithSeriesIDAndComicsID_characterAndCharacterSummariesAreCreated() throws {
        // Given
        let series = SeriesFactory.make(id: "SeriesID")
        try createSeries(series)
        let comic = ComicFactory.make(id: "ComicID")
        try createComic(comic)
        let criteria = CreateItemCriteria(
            item: CharacterFactory.make(id: "CharacterID", seriesID: [series.id], comicsID: [comic.id]),
            on: eventLoop,
            in: table
        )

        // When
        let feature = sut.create(with: criteria)

        // Then
        XCTAssertNoThrow(try feature.wait())
        XCTAssertNotNil(MockDB["Character#CharacterID"])
        XCTAssertNotNil(MockDB["Series#SeriesID|Character#CharacterID"])
        XCTAssertNotNil(MockDB["Comic#ComicID|Character#CharacterID"])
    }

    func test_whenCrateCharacterWithOneNotExistingSeriesID_throwsItemsNotFound() throws {
        // Given
        let series = SeriesFactory.make(id: "1")
        try createSeries(series)
        let character = CharacterFactory.make(seriesID: [series.id, "-1"])
        let criteria = CreateItemCriteria(item: character, on: eventLoop, in: table)
        var thrownError: Error?

        // When
        let feature = sut.create(with: criteria)
        XCTAssertThrowsError(try feature.wait()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .itemsNotFound(let itemID, let itemType) = error as? ComicInfoError {
            XCTAssertEqual(itemID, ["-1"])
            XCTAssertTrue(itemType == Series.self)
        } else {
            XCTFail("Expected '.itemsNotFound' but got \(error)")
        }
    }

    func test_whenCrateCharacterWithOneNotExistingComicID_throwsItemsNotFound() throws {
        // Given
        let comic = ComicFactory.make(id: "1")
        try createComic(comic)
        let character = CharacterFactory.make(comicsID: [comic.id, "-1"])
        let criteria = CreateItemCriteria(item: character, on: eventLoop, in: table)
        var thrownError: Error?

        // When
        let feature = sut.create(with: criteria)
        XCTAssertThrowsError(try feature.wait()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .itemsNotFound(let itemID, let itemType) = error as? ComicInfoError {
            XCTAssertEqual(itemID, ["-1"])
            XCTAssertTrue(itemType == Comic.self)
        } else {
            XCTFail("Expected '.itemsNotFound' but got \(error)")
        }
    }
    
}
