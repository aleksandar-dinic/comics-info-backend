//
//  CharacterCreateUseCaseTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 28/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Logging
import NIO
import XCTest

final class CharacterCreateUseCaseTests: XCTestCase, CreateSeriesProtocol, CreateComicProtocol {

    private var eventLoop: EventLoop!
    private var logger: Logger!
    private var sut: CharacterCreateUseCase<CharacterCreateRepositoryAPIWrapper>!
    private var table: String!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        DatabaseMock.removeAll()
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        logger = Logger(label: self.className)
        sut = CharacterCreateUseCaseFactoryMock(on: eventLoop, logger: logger).makeUseCase()
        table = String.tableName(for: "TEST")
    }

    override func tearDownWithError() throws {
        eventLoop = nil
        logger = nil
        sut = nil
        table = nil
    }

    func test_whenCrateCharacter_characterIsCreated() throws {
        // Given

        // When
        let feature = sut.create(CharacterMock.makeCharacter(), on: eventLoop, in: table)

        // Then
        XCTAssertNoThrow(try feature.wait())
    }
    
    func test_whenCrateCharacterWithNotExistingSeriesID_throwsItemsNotFound() throws {
        // Given
        let seriesID: Set<String> = ["-1"]
        var thrownError: Error?

        // When
        let feature = sut.create(CharacterMock.makeCharacter(seriesID: seriesID), on: eventLoop, in: table)
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

    func test_whenCrateCharacterWithNotExistingComicsID_throwsItemsNotFound() throws {
        // Given
        let comicsID: Set<String> = ["-1"]
        var thrownError: Error?

        // When
        let feature = sut.create(CharacterMock.makeCharacter(comicsID: comicsID), on: eventLoop, in: table)
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

    func test_whenCrateCharacterWithSeriesIDAndComicsID_characterAndCharacterSummariesAreCreated() throws {
        // Given
        let series = SeriesMock.makeSeries(id: "1")
        try createSeries(series)
        let comic = ComicMock.makeComic(id: "1")
        try createComic(comic)

        // When
        let feature = sut.create(
            CharacterMock.makeCharacter(seriesID: [series.id], comicsID: [comic.id]),
            on: eventLoop,
            in: table
        )

        // Then
        XCTAssertNoThrow(try feature.wait())
        XCTAssertNotNil(DatabaseMock.items["Character#1"])
        XCTAssertNotNil(DatabaseMock.items["Series#1|Character#1"])
        XCTAssertNotNil(DatabaseMock.items["Comic#1|Character#1"])
    }

    func test_whenCrateCharacterWithOneNotExistingSeriesID_throwsItemsNotFound() throws {
        // Given
        let series = SeriesMock.makeSeries(id: "1")
        try createSeries(series)
        let character = CharacterMock.makeCharacter(seriesID: [series.id, "-1"])
        var thrownError: Error?

        // When
        let feature = sut.create(character, on: eventLoop, in: table)
        XCTAssertThrowsError(try feature.wait()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .itemsNotFound(let itemID, let itemType) = error as? APIError {
            XCTAssertEqual(itemID, ["-1"])
            XCTAssertTrue(itemType == Series.self)
        } else {
            XCTFail("Expected '.itemsNotFound' but got \(error)")
        }
    }

    func test_whenCrateCharacterWithOneNotExistingComicID_throwsItemsNotFound() throws {
        // Given
        let comic = ComicMock.makeComic(id: "1")
        try createComic(comic)
        let character = CharacterMock.makeCharacter(comicsID: [comic.id, "-1"])
        var thrownError: Error?

        // When
        let feature = sut.create(character, on: eventLoop, in: table)
        XCTAssertThrowsError(try feature.wait()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .itemsNotFound(let itemID, let itemType) = error as? APIError {
            XCTAssertEqual(itemID, ["-1"])
            XCTAssertTrue(itemType == Comic.self)
        } else {
            XCTFail("Expected '.itemsNotFound' but got \(error)")
        }
    }

}
