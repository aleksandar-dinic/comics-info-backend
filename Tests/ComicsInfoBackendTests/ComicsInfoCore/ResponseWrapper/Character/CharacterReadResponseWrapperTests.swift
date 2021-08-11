//
//  CharacterReadResponseWrapperTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 21/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import Domain
@testable import ComicsInfoCore
import XCTest
import NIO

final class CharacterReadResponseWrapperTests: XCTestCase {

    private var eventLoop: EventLoop!
    private var sut: CharacterReadResponseWrapper!
    private var environment: String!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        MockDB.removeAll()
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        let useCase = CharacterUseCaseFactoryMock(items: [:], on: eventLoop).makeUseCase()
        sut = CharacterReadResponseWrapper(characterUseCase: useCase)
        environment = "TEST"
    }

    override func tearDownWithError() throws {
        eventLoop = nil
        sut = nil
        environment = nil
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

    func test_whenHandleRead_statusIsOk() throws {
        // Given
        let items = CharacterFactory.makeDatabaseItems()
        let useCase = CharacterUseCaseFactoryMock(items: items, on: eventLoop).makeUseCase()
        sut = CharacterReadResponseWrapper(characterUseCase: useCase)
        let request = Request(pathParameters: ["id": "1"])

        // When
        let feature = sut.handleRead(on: eventLoop, request: request, environment: environment, logger: nil)
        let response = try feature.wait()

        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.ok.code)
    }

}

// Fields

extension CharacterReadResponseWrapperTests: CreateCharacterProtocol, CreateSeriesProtocol, CreateComicProtocol {

    func test_whenHandleReadWithInvalidFields_statusIsBadRequest() throws {
        // Given
        let items = CharacterFactory.makeDatabaseItems()
        let useCase = CharacterUseCaseFactoryMock(items: items, on: eventLoop).makeUseCase()
        sut = CharacterReadResponseWrapper(characterUseCase: useCase)
        let request = Request(pathParameters: ["id": "1"], queryParameters: ["fields": "invalid"])

        // When
        let feature = sut.handleRead(on: eventLoop, request: request, environment: environment, logger: nil)
        let response = try feature.wait()
        
        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.badRequest.code)
    }
    
    func test_whenHandleReadWithoutFields_responseItemIsWithoutSummaries() throws {
        // Given
        let series = SeriesFactory.make(id: "1")
        try createSeries(series)
        let comic = ComicFactory.make(id: "1")
        try createComic(comic)
        let character = CharacterFactory.make(seriesID: [series.id], comicsID: [comic.id])
        try createCharacter(character)
        
        let request = Request(pathParameters: ["id": "1"])

        // When
        let feature = sut.handleRead(on: eventLoop, request: request, environment: environment, logger: nil)
        let response = try feature.wait()
        
        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.ok.code)
        let data = try XCTUnwrap(response.body?.data(using: .utf8))
        let item = try JSONDecoder().decode(Domain.Character.self, from: data)
        XCTAssertNil(item.series)
        XCTAssertNil(item.comics)
    }
    
    func test_whenHandleReadWithFieldsSeries_responseItemIsWithSeriesSummaries() throws {
        // Given
        let series = SeriesFactory.make(id: "1")
        try createSeries(series)
        let comic = ComicFactory.make(id: "1")
        try createComic(comic)
        let character = CharacterFactory.make(seriesID: [series.id], comicsID: [comic.id])
        try createCharacter(character)
        
        let request = Request(pathParameters: ["id": "1"], queryParameters: ["fields": "series"])

        // When
        let feature = sut.handleRead(on: eventLoop, request: request, environment: environment, logger: nil)
        let response = try feature.wait()
        
        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.ok.code)
        let data = try XCTUnwrap(response.body?.data(using: .utf8))
        let item = try JSONDecoder().decode(Domain.Character.self, from: data)
        XCTAssertNotNil(item.series)
        XCTAssertNil(item.comics)
    }
    
    func test_whenHandleReadWithFieldsComics_responseItemIsWithComicsSummaries() throws {
        // Given
        let series = SeriesFactory.make(id: "1")
        try createSeries(series)
        let comic = ComicFactory.make(id: "1")
        try createComic(comic)
        let character = CharacterFactory.make(seriesID: [series.id], comicsID: [comic.id])
        try createCharacter(character)
        
        let request = Request(pathParameters: ["id": "1"], queryParameters: ["fields": "comics"])

        // When
        let feature = sut.handleRead(on: eventLoop, request: request, environment: environment, logger: nil)
        let response = try feature.wait()
        
        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.ok.code)
        let data = try XCTUnwrap(response.body?.data(using: .utf8))
        let item = try JSONDecoder().decode(Domain.Character.self, from: data)
        XCTAssertNil(item.series)
        XCTAssertNotNil(item.comics)
    }
    
    func test_whenHandleReadWithFieldsSeriesAndComics_responseItemIsWithSeriesAndComicsSummaries() throws {
        // Given
        let series = SeriesFactory.make(id: "1")
        try createSeries(series)
        let comic = ComicFactory.make(id: "1")
        try createComic(comic)
        let character = CharacterFactory.make(seriesID: [series.id], comicsID: [comic.id])
        try createCharacter(character)
        
        let request = Request(pathParameters: ["id": "1"], queryParameters: ["fields": "series,comics"])

        // When
        let feature = sut.handleRead(on: eventLoop, request: request, environment: environment, logger: nil)
        let response = try feature.wait()
        
        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.ok.code)
        let data = try XCTUnwrap(response.body?.data(using: .utf8))
        let item = try JSONDecoder().decode(Domain.Character.self, from: data)
        XCTAssertNotNil(item.series)
        XCTAssertNotNil(item.comics)
    }
    
    func test_whenHandleReadWithFieldsSeriesComicsAndInvalid_statusIsBadRequest() throws {
        // Given
        let series = SeriesFactory.make(id: "1")
        try createSeries(series)
        let comic = ComicFactory.make(id: "1")
        try createComic(comic)
        let character = CharacterFactory.make(seriesID: [series.id], comicsID: [comic.id])
        try createCharacter(character)
        
        let request = Request(pathParameters: ["id": "1"], queryParameters: ["fields": "series,comics,invalid"])

        // When
        let feature = sut.handleRead(on: eventLoop, request: request, environment: environment, logger: nil)
        let response = try feature.wait()
        
        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.badRequest.code)
    }

}

// List

extension CharacterReadResponseWrapperTests {
    
    func test_whenHandleListWithoutItems_statusIsNoContent() throws {
        // Given

        // When
        let feature = sut.handleRead(on: eventLoop, request: Request(), environment: environment, logger: nil)
        let response = try feature.wait()

        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.noContent.code)
    }

    func test_whenHandleList_statusIsOk() throws {
        // Given
        try createCharacter(CharacterFactory.make())

        // When
        let feature = sut.handleRead(on: eventLoop, request: Request(), environment: environment, logger: nil)
        let response = try feature.wait()

        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.ok.code)
    }

}
