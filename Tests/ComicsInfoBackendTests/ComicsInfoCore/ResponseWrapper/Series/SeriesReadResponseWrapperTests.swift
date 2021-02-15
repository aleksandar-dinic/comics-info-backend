//
//  SeriesReadResponseWrapperTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 21/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import Domain
@testable import ComicsInfoCore
import XCTest
import NIO

final class SeriesReadResponseWrapperTests: XCTestCase {

    private var eventLoop: EventLoop!
    private var sut: SeriesReadResponseWrapper!
    private var environment: String!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        MockDB.removeAll()
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        let useCase = SeriesUseCaseFactoryMock(on: eventLoop).makeUseCase()
        sut = SeriesReadResponseWrapper(seriesUseCase: useCase)
        environment = "TEST"
    }

    override func tearDownWithError() throws {
        eventLoop = nil
        sut = nil
        environment = nil
    }

    func test_whenHandleReadWithoutPathParameters_statusIsBadRequest() throws {
        // Given
        let request = Request()

        // When
        let feature = sut.handleRead(on: eventLoop, request: request, environment: environment, logger: nil)
        let response = try feature.wait()

        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.badRequest.code)
    }

    func test_whenHandleReadWithInvalidPathParameters_statusIsBadRequest() throws {
        // Given
        let request = Request(pathParameters: ["invalidID": "-1"])

        // When
        let feature = sut.handleRead(on: eventLoop, request: request, environment: environment, logger: nil)
        let response = try feature.wait()

        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.badRequest.code)
    }

    func test_whenHandleReadWithoutItems_statusIsNoContent() throws {
        // Given
        let request = Request(pathParameters: ["id": "1"])

        // When
        let feature = sut.handleRead(on: eventLoop, request: request, environment: environment, logger: nil)
        let response = try feature.wait()

        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.noContent.code)
    }


    func test_whenHandleList_statusIsOk() throws {
        // Given
        try createSeries(SeriesFactory.make())
        let request = Request(pathParameters: ["id": "1"])

        // When
        let feature = sut.handleRead(on: eventLoop, request: request, environment: environment, logger: nil)
        let response = try feature.wait()

        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.ok.code)
    }

}

// Fields

extension SeriesReadResponseWrapperTests: CreateCharacterProtocol, CreateSeriesProtocol, CreateComicProtocol  {

    func test_whenHandleReadWithInvalidFields_statusIsBadRequest() throws {
        // Given
        let items = SeriesFactory.makeDatabaseItems()
        let useCase = SeriesUseCaseFactoryMock(items: items, on: eventLoop).makeUseCase()
        sut = SeriesReadResponseWrapper(seriesUseCase: useCase)
        let request = Request(pathParameters: ["id": "1"], queryParameters: ["fields": "invalid"])

        // When
        let feature = sut.handleRead(on: eventLoop, request: request, environment: environment, logger: nil)
        let response = try feature.wait()
        
        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.badRequest.code)
    }
    
    func test_whenHandleReadWithoutFields_responseItemIsWithoutSummaries() throws {
        // Given
        let character = CharacterFactory.make(id: "1")
        try createCharacter(character)
        let comic = ComicFactory.make(id: "1")
        try createComic(comic)
        let series = SeriesFactory.make(charactersID: [character.id], comicsID: [comic.id])
        try createSeries(series)
        
        let request = Request(pathParameters: ["id": "1"])

        // When
        let feature = sut.handleRead(on: eventLoop, request: request, environment: environment, logger: nil)
        let response = try feature.wait()
        
        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.ok.code)
        let data = try XCTUnwrap(response.body?.data(using: .utf8))
        let item = try JSONDecoder().decode(Domain.Series.self, from: data)
        XCTAssertNil(item.characters)
        XCTAssertNil(item.comics)
    }
    
    func test_whenHandleReadWithFieldsCharacters_responseItemIsWithCharactersSummaries() throws {
        // Given
        let character = CharacterFactory.make(id: "1")
        try createCharacter(character)
        let comic = ComicFactory.make(id: "1")
        try createComic(comic)
        let series = SeriesFactory.make(charactersID: [character.id], comicsID: [comic.id])
        try createSeries(series)
        
        let request = Request(pathParameters: ["id": "1"], queryParameters: ["fields": "characters"])

        // When
        let feature = sut.handleRead(on: eventLoop, request: request, environment: environment, logger: nil)
        let response = try feature.wait()
        
        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.ok.code)
        let data = try XCTUnwrap(response.body?.data(using: .utf8))
        let item = try JSONDecoder().decode(Domain.Series.self, from: data)
        XCTAssertNotNil(item.characters)
        XCTAssertNil(item.comics)
    }
    
    func test_whenHandleReadWithFieldsComics_responseItemIsWithComicsSummaries() throws {
        // Given
        let character = CharacterFactory.make(id: "1")
        try createCharacter(character)
        let comic = ComicFactory.make(id: "1")
        try createComic(comic)
        let series = SeriesFactory.make(charactersID: [character.id], comicsID: [comic.id])
        try createSeries(series)
        
        let request = Request(pathParameters: ["id": "1"], queryParameters: ["fields": "comics"])

        // When
        let feature = sut.handleRead(on: eventLoop, request: request, environment: environment, logger: nil)
        let response = try feature.wait()
        
        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.ok.code)
        let data = try XCTUnwrap(response.body?.data(using: .utf8))
        let item = try JSONDecoder().decode(Domain.Series.self, from: data)
        XCTAssertNil(item.characters)
        XCTAssertNotNil(item.comics)
    }
    
    func test_whenHandleReadWithFieldsCharactersAndComics_responseItemIsWithCharactersAndComicsSummaries() throws {
        // Given
        let character = CharacterFactory.make(id: "1")
        try createCharacter(character)
        let comic = ComicFactory.make(id: "1")
        try createComic(comic)
        let series = SeriesFactory.make(charactersID: [character.id], comicsID: [comic.id])
        try createSeries(series)
        
        let request = Request(pathParameters: ["id": "1"], queryParameters: ["fields": "characters,comics"])

        // When
        let feature = sut.handleRead(on: eventLoop, request: request, environment: environment, logger: nil)
        let response = try feature.wait()
        
        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.ok.code)
        let data = try XCTUnwrap(response.body?.data(using: .utf8))
        let item = try JSONDecoder().decode(Domain.Series.self, from: data)
        XCTAssertNotNil(item.characters)
        XCTAssertNotNil(item.comics)
    }
    
    func test_whenHandleReadWithFieldsCharactersComicsAndInvalid_statusIsBadRequest() throws {
        // Given
        let character = CharacterFactory.make(id: "1")
        try createCharacter(character)
        let comic = ComicFactory.make(id: "1")
        try createComic(comic)
        let series = SeriesFactory.make(charactersID: [character.id], comicsID: [comic.id])
        try createSeries(series)
        
        let request = Request(pathParameters: ["id": "1"], queryParameters: ["fields": "characters,comics,invalid"])

        // When
        let feature = sut.handleRead(on: eventLoop, request: request, environment: environment, logger: nil)
        let response = try feature.wait()
        
        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.badRequest.code)
    }

}
