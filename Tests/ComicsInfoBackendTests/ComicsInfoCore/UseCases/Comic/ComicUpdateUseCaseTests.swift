//
//  ComicUpdateUseCaseTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 28/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Logging
import NIO
import XCTest

final class ComicUpdateUseCaseTests: XCTestCase, CreateCharacterProtocol, CreateSeriesProtocol, CreateComicProtocol {

    private var eventLoop: EventLoop!
    private var logger: Logger!
    private var sut: ComicUpdateUseCase<ComicUpdateRepositoryAPIWrapper>!
    private var table: String!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        DatabaseMock.removeAll()
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        logger = Logger(label: self.className)
        table = String.tableName(for: "TEST")
        sut = ComicUpdateUseCaseFactoryMock(on: eventLoop, logger: logger).makeUseCase()
    }

    override func tearDownWithError() throws {
        eventLoop = nil
        logger = nil
        sut = nil
        table = nil
    }

    func test_whenUpdateComic_comicIsUpdated() throws {
        // Given
        try createComic(ComicMock.makeComic(title: "Old Title"))

        // When
        let feature = sut.update(ComicMock.makeComic(), on: eventLoop, in: table)

        // Then
        XCTAssertNoThrow(try feature.wait())
    }

    func test_whenUpdateComicWithNotExistingSeriesID_throwsItemsNotFound() throws {
        // Given
        try createComic(ComicMock.makeComic())
        let seriesID: Set<String> = ["-1"]
        var thrownError: Error?

        // When
        let feature = sut.update(ComicMock.makeComic(seriesID: seriesID), on: eventLoop, in: table)
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

    func test_whenUpdateComicWithNotExistingCharactersID_throwsItemsNotFound() throws {
        // Given
        try createComic(ComicMock.makeComic())
        let charactersID: Set<String> = ["-1"]
        var thrownError: Error?

        // When
        let feature = sut.update(ComicMock.makeComic(charactersID: charactersID), on: eventLoop, in: table)
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

    func test_whenUpdateComic_comicAndComicSummariesAreUpdated() throws {
        // Given
        let character = CharacterMock.makeCharacter(id: "1")
        try createCharacter(character)
        let series = SeriesMock.makeSeries(id: "1")
        try createSeries(series)

        try createComic(ComicMock.makeComic(charactersID: [character.id], seriesID: [series.id]))

        // When
        let feature = sut.update(ComicMock.makeComic(title: "New Title"), on: eventLoop, in: table)

        // Then
        XCTAssertNoThrow(try feature.wait())
    }

    func test_whenUpdateComicWithCharactersIDAndSeriesID_comicAndComicSummariesAreUpdated() throws {
        // Given
        let character = CharacterMock.makeCharacter(id: "1")
        try createCharacter(character)
        let series = SeriesMock.makeSeries(id: "1")
        try createSeries(series)

        try createComic(ComicMock.makeComic())

        // When
        let feature = sut.update(ComicMock.makeComic(title: "New Title", charactersID: [character.id], seriesID: [series.id]), on: eventLoop, in: table)

        // Then
        XCTAssertNoThrow(try feature.wait())
    }
    
}
