//
//  ComicCreateUseCaseTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 28/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Logging
import NIO
import XCTest

final class ComicCreateUseCaseTests: XCTestCase, CreateCharacterProtocol, CreateSeriesProtocol {

    private var eventLoop: EventLoop!
    private var logger: Logger!
    private var sut: ComicCreateUseCase<ComicCreateRepositoryAPIWrapper>!
    private var table: String!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        DatabaseMock.removeAll()
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        logger = Logger(label: self.className)
        sut = ComicCreateUseCaseFactoryMock(on: eventLoop, logger: logger).makeUseCase()
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
        let feature = sut.create(ComicMock.makeComic(), on: eventLoop, in: table)

        // Then
        XCTAssertNoThrow(try feature.wait())
    }
    
    func test_whenCrateComicWithNotExistingCharacterID_throwsItemsNotFound() throws {
        // Given
        let charactersID: Set<String> = ["-1"]
        var thrownError: Error?

        // When
        let feature = sut.create(ComicMock.makeComic(charactersID: charactersID), on: eventLoop, in: table)
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

    func test_whenCrateComicWithNotExistingSeriesID_throwsItemsNotFound() throws {
        // Given
        let seriesID: Set<String> = ["-1"]
        var thrownError: Error?

        // When
        let feature = sut.create(ComicMock.makeComic(seriesID: seriesID), on: eventLoop, in: table)
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

    func test_whenCrateComicWithCharactersIDAndSeriesID_comicAndComicSummariesAreCreated() throws {
        // Given
        let character = CharacterMock.makeCharacter(id: "1")
        try createCharacter(character)
        let series = SeriesMock.makeSeries(id: "1")
        try createSeries(series)

        // When
        let feature = sut.create(ComicMock.makeComic(charactersID: [character.id], seriesID: [series.id]), on: eventLoop, in: table)

        // Then
        XCTAssertNoThrow(try feature.wait())
        XCTAssertNotNil(DatabaseMock.items["Comic#1"])
        XCTAssertNotNil(DatabaseMock.items["Character#1|Comic#1"])
        XCTAssertNotNil(DatabaseMock.items["Series#1|Comic#1"])
    }

    func test_whenCrateComicWithOneNotExistingSeriesID_throwsItemNotFound() throws {
        // Given
        let series = SeriesMock.makeSeries(id: "1")
        try createSeries(series)
        let comic = ComicMock.makeComic(seriesID: [series.id, "-1"])
        var thrownError: Error?

        // When
        let feature = sut.create(comic, on: eventLoop, in: table)
        XCTAssertThrowsError(try feature.wait()) {
            thrownError = $0
        }

        // Then
        let error = try XCTUnwrap(thrownError)
        if case .itemsNotFound(let IDs, let itemType) = error as? APIError {
            XCTAssertEqual(IDs, ["-1"])
            XCTAssertTrue(itemType == Series.self)
        } else {
            XCTFail("Expected '.itemsNotFound' but got \(error)")
        }
    }

    func test_whenCrateComicWithOneNotExistingCharacterID_throwsItemNotFound() throws {
        // Given
        let character = CharacterMock.makeCharacter(id: "1")
        try createCharacter(character)
        let comic = ComicMock.makeComic(charactersID: [character.id, "-1"])
        var thrownError: Error?

        // When
        let feature = sut.create(comic, on: eventLoop, in: table)
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

}
