//
//  ComicReadResponseWrapperTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 21/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import Domain
@testable import ComicsInfoCore
import XCTest
import NIO

final class ComicReadResponseWrapperTests: XCTestCase {

    private var eventLoop: EventLoop!
    private var sut: ComicReadResponseWrapper!
    private var environment: String!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        MockDB.removeAll()
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        let useCase = ComicUseCaseFactoryMock(on: eventLoop).makeUseCase()
        sut = ComicReadResponseWrapper(comicUseCase: useCase)
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
        let items = ComicFactory.makeDatabaseItems()
        let useCase = ComicUseCaseFactoryMock(items: items, on: eventLoop).makeUseCase()
        sut = ComicReadResponseWrapper(comicUseCase: useCase)
        let request = Request(pathParameters: ["id": "1"])

        // When
        let feature = sut.handleRead(on: eventLoop, request: request, environment: environment, logger: nil)
        let response = try feature.wait()

        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.ok.code)
    }

}

// Fields

extension ComicReadResponseWrapperTests: CreateCharacterProtocol, CreateSeriesProtocol, CreateComicProtocol  {

    func test_whenHandleReadWithInvalidFields_statusIsBadRequest() throws {
        // Given
        let items = ComicFactory.makeDatabaseItems()
        let useCase = ComicUseCaseFactoryMock(items: items, on: eventLoop).makeUseCase()
        sut = ComicReadResponseWrapper(comicUseCase: useCase)
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
        let series = SeriesFactory.make(id: "1")
        try createSeries(series)
        let comic = ComicFactory.make(charactersID: [character.id], seriesID: [series.id])
        try createComic(comic)
        
        let request = Request(pathParameters: ["id": "1"])

        // When
        let feature = sut.handleRead(on: eventLoop, request: request, environment: environment, logger: nil)
        let response = try feature.wait()
        
        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.ok.code)
        let data = try XCTUnwrap(response.body?.data(using: .utf8))
        let item = try JSONDecoder().decode(Domain.Comic.self, from: data)
        XCTAssertNil(item.characters)
        XCTAssertNil(item.series)
    }
    
    func test_whenHandleReadWithFieldsCharacters_responseItemIsWithCharactersSummaries() throws {
        // Given
        let character = CharacterFactory.make(id: "1")
        try createCharacter(character)
        let series = SeriesFactory.make(id: "1")
        try createSeries(series)
        let comic = ComicFactory.make(charactersID: [character.id], seriesID: [series.id])
        try createComic(comic)
        
        let request = Request(pathParameters: ["id": "1"], queryParameters: ["fields": "characters"])

        // When
        let feature = sut.handleRead(on: eventLoop, request: request, environment: environment, logger: nil)
        let response = try feature.wait()
        
        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.ok.code)
        let data = try XCTUnwrap(response.body?.data(using: .utf8))
        let item = try JSONDecoder().decode(Domain.Comic.self, from: data)
        XCTAssertNotNil(item.characters)
        XCTAssertNil(item.series)
    }
    
    func test_whenHandleReadWithFieldsSeries_responseItemIsWithSeriesSummaries() throws {
        // Given
        let character = CharacterFactory.make(id: "1")
        try createCharacter(character)
        let series = SeriesFactory.make(id: "1")
        try createSeries(series)
        let comic = ComicFactory.make(charactersID: [character.id], seriesID: [series.id])
        try createComic(comic)
        
        let request = Request(pathParameters: ["id": "1"], queryParameters: ["fields": "series"])

        // When
        let feature = sut.handleRead(on: eventLoop, request: request, environment: environment, logger: nil)
        let response = try feature.wait()
        
        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.ok.code)
        let data = try XCTUnwrap(response.body?.data(using: .utf8))
        let item = try JSONDecoder().decode(Domain.Comic.self, from: data)
        XCTAssertNil(item.characters)
        XCTAssertNotNil(item.series)
    }
    
    func test_whenHandleReadWithFieldsCharactersAndSeries_responseItemIsWithCharactersAndSeriesSummaries() throws {
        // Given
        let character = CharacterFactory.make(id: "1")
        try createCharacter(character)
        let series = SeriesFactory.make(id: "1")
        try createSeries(series)
        let comic = ComicFactory.make(charactersID: [character.id], seriesID: [series.id])
        try createComic(comic)
        
        let request = Request(pathParameters: ["id": "1"], queryParameters: ["fields": "characters,series"])

        // When
        let feature = sut.handleRead(on: eventLoop, request: request, environment: environment, logger: nil)
        let response = try feature.wait()
        
        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.ok.code)
        let data = try XCTUnwrap(response.body?.data(using: .utf8))
        let item = try JSONDecoder().decode(Domain.Comic.self, from: data)
        XCTAssertNotNil(item.characters)
        XCTAssertNotNil(item.series)
    }
    
    func test_whenHandleReadWithFieldsCharactersSeriesAndInvalid_statusIsBadRequest() throws {
        // Given
        let character = CharacterFactory.make(id: "1")
        try createCharacter(character)
        let series = SeriesFactory.make(id: "1")
        try createSeries(series)
        let comic = ComicFactory.make(charactersID: [character.id], seriesID: [series.id])
        try createComic(comic)
        
        let request = Request(pathParameters: ["id": "1"], queryParameters: ["fields": "characters,series,invalid"])

        // When
        let feature = sut.handleRead(on: eventLoop, request: request, environment: environment, logger: nil)
        let response = try feature.wait()
        
        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.badRequest.code)
    }

}

// List

extension ComicReadResponseWrapperTests {
    
    func test_whenHandleListWithoutItems_statusIsNoContent() throws {
        // Given
        let useCase = ComicUseCaseFactoryMock(on: eventLoop).makeUseCase()
        sut = ComicReadResponseWrapper(comicUseCase: useCase)
        let request = Request(queryParameters: ["seriesID": "1"])

        // When
        let feature = sut.handleRead(on: eventLoop, request: request, environment: environment, logger: nil)
        let response = try feature.wait()

        // Then
        XCTAssertEqual(
            response.statusCode.code,
            ComicsInfoCore.HTTPResponseStatus.noContent.code
        )
    }

    func test_whenHandleList_statusIsOk() throws {
        // Given
        let items = ComicFactory.makeDatabaseItems()
        let useCase = ComicUseCaseFactoryMock(items: items, on: eventLoop).makeUseCase()
        sut = ComicReadResponseWrapper(comicUseCase: useCase)
        let request = Request(queryParameters: ["seriesID": "1"])

        // When
        let feature = sut.handleRead(on: eventLoop, request: request, environment: environment, logger: nil)
        let response = try feature.wait()

        // Then
        XCTAssertEqual(
            response.statusCode.code,
            ComicsInfoCore.HTTPResponseStatus.ok.code
        )
    }
    
//    func test_whenHandleListWithoutSeriesID_statusIsMethodNotAllowed() throws {
//        // Given
//        let items = ComicFactory.makeDatabaseItems()
//        let useCase = ComicUseCaseFactoryMock(items: items, on: eventLoop).makeUseCase()
//        sut = ComicReadResponseWrapper(comicUseCase: useCase)
//        let request = Request()
//
//        // When
//        let feature = sut.handleRead(on: eventLoop, request: request, environment: environment, logger: nil)
//        let response = try feature.wait()
//
//        // Then
//        XCTAssertEqual(
//            response.statusCode.code,
//            ComicsInfoCore.HTTPResponseStatus.methodNotAllowed.code
//        )
//    }
    
}
