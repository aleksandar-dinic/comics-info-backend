//
//  CharacterUpdateUseCaseTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 28/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Logging
import NIO
import XCTest

final class CharacterUpdateUseCaseTests: XCTestCase, CreateCharacterProtocol, CreateSeriesProtocol, CreateComicProtocol {

    private var eventLoop: EventLoop!
    private var logger: Logger!
    private var sut: CharacterUpdateUseCase<CharacterUpdateRepositoryAPIWrapper>!
    private var table: String!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        DatabaseMock.removeAll()
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        logger = Logger(label: self.className)
        table = String.tableName(for: "TEST")
        sut = CharacterUpdateUseCaseFactoryMock(items: [:], on: eventLoop, logger: logger).makeUseCase()
    }

    override func tearDownWithError() throws {
        eventLoop = nil
        logger = nil
        sut = nil
        table = nil
    }
    
    func test_whenUpdateCharacter_characterIsUpdated() throws {
        // Given
        try createCharacter(CharacterMock.makeCharacter(name: "Old Name"))

        // When
        let feature = sut.update(CharacterMock.makeCharacter(), on: eventLoop, in: table)

        // Then
        XCTAssertNoThrow(try feature.wait())
    }

    func test_whenUpdateCharacterWithNotExistingSeriesID_throwsItemsNotFound() throws {
        // Given
        try createCharacter(CharacterMock.makeCharacter())
        let seriesID: Set<String> = ["-1"]
        var thrownError: Error?

        // When
        let feature = sut.update(CharacterMock.makeCharacter(seriesID: seriesID), on: eventLoop, in: table)
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

    func test_whenUpdateCharacterWithNotExistingComicsID_throwsItemsNotFound() throws {
        // Given
        try createCharacter(CharacterMock.makeCharacter())
        let comicsID: Set<String> = ["-1"]
        var thrownError: Error?

        // When
        let feature = sut.update(CharacterMock.makeCharacter(comicsID: comicsID), on: eventLoop, in: table)
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

    func test_whenUpdateCharacter_characterAndCharacterSummariesAreUpdated() throws {
        // Given
        let series = SeriesMock.makeSeries(id: "1")
        try createSeries(series)
        let comic = ComicMock.makeComic(id: "1")
        try createComic(comic)

        try createCharacter(CharacterMock.makeCharacter(seriesID: [series.id], comicsID: [comic.id]))

        // When
        let feature = sut.update(CharacterMock.makeCharacter(name: "New Name"), on: eventLoop, in: table)

        // Then
        XCTAssertNoThrow(try feature.wait())
    }

    func test_whenUpdateCharacterWithSeriesIDAndComicsID_characterAndCharacterSummariesAreUpdated() throws {
        // Given
        let series = SeriesMock.makeSeries(id: "1")
        try createSeries(series)
        let comic = ComicMock.makeComic(id: "1")
        try createComic(comic)

        try createCharacter(CharacterMock.makeCharacter())

        // When
        let feature = sut.update(CharacterMock.makeCharacter(name: "New Name", seriesID: [series.id], comicsID: [comic.id]), on: eventLoop, in: table)

        // Then
        XCTAssertNoThrow(try feature.wait())
    }

    func test_whenUpdateCharacter_existingSummariesAreUpdated() throws {
        // Given
        let series = SeriesMock.makeSeries(id: "1")
        try createSeries(series)
        let character = CharacterMock.makeCharacter(
            popularity: 0,
            name: "Old Name",
            thumbnail: "Old Thumbnail",
            description: "Old Description",
            seriesID: [series.id]
        )
        try createCharacter(character)

        // When
        let newCharacter = CharacterMock.makeCharacter(
            popularity: 1,
            name: "New Name",
            thumbnail: "New Thumbnail",
            description: "New Description"
        )
        let feature = sut.update(newCharacter, on: eventLoop, in: table)

        // Then
        XCTAssertNoThrow(try feature.wait())
        if let data = DatabaseMock.items["Series#1|Character#1"],
           let characterSummary = try? JSONDecoder().decode(CharacterSummary<Series>.self, from: data){
            XCTAssertEqual(characterSummary.popularity, newCharacter.popularity)
            XCTAssertEqual(characterSummary.name, newCharacter.name)
            XCTAssertEqual(characterSummary.thumbnail, newCharacter.thumbnail)
            XCTAssertEqual(characterSummary.description, newCharacter.description)
        } else {
            XCTFail("CharacterSummary<Series> with ID: Series#1|Character#1 doesn't exist")
        }
    }

}
