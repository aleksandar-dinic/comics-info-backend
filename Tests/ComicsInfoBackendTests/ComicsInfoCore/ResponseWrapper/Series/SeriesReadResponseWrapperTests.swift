//
//  SeriesReadResponseWrapperTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 21/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest
import NIO

final class SeriesReadResponseWrapperTests: XCTestCase, CreateSeriesProtocol {

    private typealias Cache = InMemoryCacheProvider<Series>

    private var eventLoop: EventLoop!
    private var sut: SeriesReadResponseWrapper<SeriesRepositoryAPIWrapper, Cache>!
    private var environment: String!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        DatabaseMock.removeAll()
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
        let request = Request(pathParameters: nil, body: nil)

        // When
        let feature = sut.handleRead(on: eventLoop, request: request, environment: environment)
        let response = try feature.wait()

        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.badRequest.code)
    }

    func test_whenHandleReadWithInvalidPathParameters_statusIsBadRequest() throws {
        // Given
        let request = Request(pathParameters: ["invalidID": "-1"], body: nil)

        // When
        let feature = sut.handleRead(on: eventLoop, request: request, environment: environment)
        let response = try feature.wait()

        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.badRequest.code)
    }

    func test_whenHandleReadWithoutItems_statusIsNotFound() throws {
        // Given
        let request = Request(pathParameters: ["id": "1"], body: nil)

        // When
        let feature = sut.handleRead(on: eventLoop, request: request, environment: environment)
        let response = try feature.wait()

        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.notFound.code)
    }


    func test_whenHandleList_statusIsOk() throws {
        // Given
        try createSeries(SeriesMock.makeSeries())
        let request = Request(pathParameters: ["id": "1"], body: nil)

        // When
        let feature = sut.handleRead(on: eventLoop, request: request, environment: environment)
        let response = try feature.wait()

        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.ok.code)
    }

}
