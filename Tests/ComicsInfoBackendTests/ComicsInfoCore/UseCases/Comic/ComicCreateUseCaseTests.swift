//
//  ComicCreateUseCaseTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 28/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import NIO
import XCTest

final class ComicCreateUseCaseTests: XCTestCase, CreateCharacterProtocol, CreateSeriesProtocol {

    private var eventLoop: EventLoop!
    private var sut: ComicCreateUseCase!
    private var table: String!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        MockDB.removeAll()
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        sut = ComicCreateUseCaseFactoryMock(on: eventLoop).makeUseCase()
        table = String.tableName(for: "TEST")
    }

    override func tearDownWithError() throws {
        eventLoop = nil
        sut = nil
        table = nil
    }

    func test_whenCrateComic_comicIsCreated() throws {
        // Given
        let criteria = CreateItemCriteria(item: ComicFactory.make(), on: eventLoop, in: table)
        
        // When
        let feature = sut.create(with: criteria)

        // Then
        XCTAssertNoThrow(try feature.wait())
    }
    
    func test_whenCrateComicWithNotExistingCharacterID_throwsItemsNotFound() throws {
        // Given
        let charactersID: Set<String> = ["-1"]
        let criteria = CreateItemCriteria(
            item: ComicFactory.make(charactersID: charactersID),
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

    func test_whenCrateComicWithNotExistingSeriesID_throwsItemsNotFound() throws {
        // Given
        let seriesID: Set<String> = ["-1"]
        let criteria = CreateItemCriteria(
            item: ComicFactory.make(seriesID: seriesID),
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

    func test_whenCrateComicWithCharactersIDAndSeriesID_comicAndComicSummariesAreCreated() throws {
        // Given
        let character = CharacterFactory.make(id: "CharacterID")
        try createCharacter(character)
        let series = SeriesFactory.make(id: "SeriesID")
        try createSeries(series)
        let criteria = CreateItemCriteria(
            item: ComicFactory.make(id: "ComicID", charactersID: [character.id], seriesID: [series.id]),
            on: eventLoop,
            in: table
        )

        // When
        let feature = sut.create(with: criteria)

        // Then
        XCTAssertNoThrow(try feature.wait())
        XCTAssertNotNil(MockDB["Comic#ComicID"])
        XCTAssertNotNil(MockDB["Character#CharacterID|Comic#ComicID"])
        XCTAssertNotNil(MockDB["Series#SeriesID|Comic#ComicID"])
    }

    func test_whenCrateComicWithOneNotExistingSeriesID_throwsItemNotFound() throws {
        // Given
        let series = SeriesFactory.make(id: "1")
        try createSeries(series)
        let comic = ComicFactory.make(seriesID: [series.id, "-1"])
        let criteria = CreateItemCriteria(item: comic, on: eventLoop, in: table)
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
            XCTAssertTrue(itemType == Series.self)
        } else {
            XCTFail("Expected '.itemsNotFound' but got \(error)")
        }
    }

    func test_whenCrateComicWithOneNotExistingCharacterID_throwsItemNotFound() throws {
        // Given
        let character = CharacterFactory.make(id: "1")
        try createCharacter(character)
        let comic = ComicFactory.make(charactersID: [character.id, "-1"])
        let criteria = CreateItemCriteria(item: comic, on: eventLoop, in: table)
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

}
