//
//  SeriesCreateUseCaseTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 28/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Logging
import NIO
import XCTest

final class SeriesCreateUseCaseTests: XCTestCase, CreateCharacterProtocol, CreateComicProtocol {

    private var eventLoop: EventLoop!
    private var logger: Logger!
    private var sut: SeriesCreateUseCase<SeriesCreateRepositoryAPIWrapper>!
    private var table: String!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        DatabaseMock.removeAll()
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        logger = Logger(label: self.className)
        sut = SeriesCreateUseCaseFactoryMock(on: eventLoop, logger: logger).makeUseCase()
        table = String.tableName(for: "TEST")
    }

    override func tearDownWithError() throws {
        eventLoop = nil
        logger = nil
        sut = nil
        table = nil
    }

    func test_whenCrateComic_comicIsCreated() throws {
        // Given

        // When
        let feature = sut.create(SeriesMock.makeSeries(), on: eventLoop, in: table)

        // Then
        XCTAssertNoThrow(try feature.wait())
    }
    
    func test_whenCrateSeriesWithNotExistingCharacterID_throwsItemsNotFound() throws {
        // Given
        let charactersID: Set<String> = ["-1"]
        var thrownError: Error?

        // When
        let feature = sut.create(SeriesMock.makeSeries(charactersID: charactersID), on: eventLoop, in: table)
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

    func test_whenCrateSeriesWithNotExistingComicsID_throwsItemsNotFound() throws {
        // Given
        let comicsID: Set<String> = ["-1"]
        var thrownError: Error?

        // When
        let feature = sut.create(SeriesMock.makeSeries(comicsID: comicsID), on: eventLoop, in: table)
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

    func test_whenCrateSeriesWithCharactersIDAndComicsID_seriesAndSeriesSummariesAreCreated() throws {
        // Given
        let character = CharacterMock.makeCharacter(id: "1")
        try createCharacter(character)
        let comic = ComicMock.makeComic(id: "1")
        try createComic(comic)

        // When
        let feature = sut.create(SeriesMock.makeSeries(charactersID: [character.id], comicsID: [comic.id]), on: eventLoop, in: table)

        // Then
        XCTAssertNoThrow(try feature.wait())
        XCTAssertNotNil(DatabaseMock.items["Series#1"])
        XCTAssertNotNil(DatabaseMock.items["Character#1|Series#1"])
        XCTAssertNotNil(DatabaseMock.items["Comic#1|Series#1"])
    }

    func test_whenCrateSeriesWithOneNotExistingCharacterID_throwsItemNotFound() throws {
        // Given
        let character = CharacterMock.makeCharacter(id: "1")
        try createCharacter(character)
        let series = SeriesMock.makeSeries(charactersID: [character.id, "-1"])
        var thrownError: Error?

        // When
        let feature = sut.create(series, on: eventLoop, in: table)
        XCTAssertThrowsError(try feature.wait()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .itemsNotFound(let IDs, let itemType) = error as? APIError {
            XCTAssertEqual(IDs, ["-1"])
            XCTAssertTrue(itemType == Character.self)
        } else {
            XCTFail("Expected '.itemsNotFound' but got \(error)")
        }
    }

    func test_whenCrateSeriesWithOneNotExistingComicID_throwsItemNotFound() throws {
        // Given
        let comic = ComicMock.makeComic(id: "1")
        try createComic(comic)
        let series = SeriesMock.makeSeries(comicsID: [comic.id, "-1"])
        var thrownError: Error?

        // When
        let feature = sut.create(series, on: eventLoop, in: table)
        XCTAssertThrowsError(try feature.wait()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .itemsNotFound(let IDs, let itemType) = error as? APIError {
            XCTAssertEqual(IDs, ["-1"])
            XCTAssertTrue(itemType == Comic.self)
        } else {
            XCTFail("Expected '.itemsNotFound' but got \(error)")
        }
    }
    
}
