//
//  SeriesUpdateUseCaseTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 28/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Logging
import NIO
import XCTest

final class SeriesUpdateUseCaseTests: XCTestCase, CreateCharacterProtocol, CreateSeriesProtocol, CreateComicProtocol {

    private var eventLoop: EventLoop!
    private var logger: Logger!
    private var sut: SeriesUpdateUseCase<SeriesUpdateRepositoryAPIWrapper>!
    private var table: String!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        DatabaseMock.removeAll()
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        logger = Logger(label: self.className)
        table = String.tableName(for: "TEST")
        sut = SeriesUpdateUseCaseFactoryMock(on: eventLoop, logger: logger).makeUseCase()
    }

    override func tearDownWithError() throws {
        eventLoop = nil
        logger = nil
        sut = nil
        table = nil
    }

    func test_whenUpdateSeries_seriesIsUpdated() throws {
        // Given
        try createSeries(SeriesMock.makeSeries(title: "Old Title"))

        // When
        let feature = sut.update(SeriesMock.makeSeries(), on: eventLoop, in: table)

        // Then
        XCTAssertNoThrow(try feature.wait())
    }

    func test_whenUpdateSeriesWithNotExistingCharacterID_throwsItemsNotFound() throws {
        // Given
        try createSeries(SeriesMock.makeSeries())
        let charactersID: Set<String> = ["-1"]
        var thrownError: Error?

        // When
        let feature = sut.update(SeriesMock.makeSeries(charactersID: charactersID), on: eventLoop, in: table)
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

    func test_whenUpdateSeriesWithNotExistingComicsID_throwsItemsNotFound() throws {
        // Given
        try createSeries(SeriesMock.makeSeries())
        let comicsID: Set<String> = ["-1"]
        var thrownError: Error?

        // When
        let feature = sut.update(SeriesMock.makeSeries(comicsID: comicsID), on: eventLoop, in: table)
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

    func test_whenUpdateSeries_seriesAndSeriesSummariesAreUpdated() throws {
        // Given
        let character = CharacterMock.makeCharacter(id: "1")
        try createCharacter(character)
        let comic = ComicMock.makeComic(id: "1")
        try createComic(comic)

        try createSeries(SeriesMock.makeSeries(charactersID: [character.id], comicsID: [comic.id]))

        // When
        let feature = sut.update(SeriesMock.makeSeries(title: "New Title"), on: eventLoop, in: table)

        // Then
        XCTAssertNoThrow(try feature.wait())
    }

    func test_whenUpdateSeriesWithCharactersIDAndComicsID_seriesAndSeriesSummariesAreUpdated() throws {
        // Given
        let character = CharacterMock.makeCharacter(id: "1")
        try createCharacter(character)
        let comic = ComicMock.makeComic(id: "1")
        try createComic(comic)

        try createSeries(SeriesMock.makeSeries())

        // When
        let feature = sut.update(SeriesMock.makeSeries(title: "New Title", charactersID: [character.id], comicsID: [comic.id]), on: eventLoop, in: table)

        // Then
        XCTAssertNoThrow(try feature.wait())
    }
    
}
