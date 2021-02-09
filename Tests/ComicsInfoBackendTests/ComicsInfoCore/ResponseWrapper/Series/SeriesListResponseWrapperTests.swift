//
//  SeriesListResponseWrapperTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 21/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest
import NIO

final class SeriesListResponseWrapperTests: XCTestCase, CreateSeriesProtocol {

    private typealias Cache = InMemoryCacheProvider<Series>

    private var eventLoop: EventLoop!
    private var sut: SeriesListResponseWrapper<GetDatabaseProvider, Cache>!
    private var environment: String!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        DatabaseMock.removeAll()
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        let useCase = SeriesUseCaseFactoryMock(on: eventLoop).makeUseCase()
        sut = SeriesListResponseWrapper(seriesUseCase: useCase)
        environment = "TEST"
    }

    override func tearDownWithError() throws {
        eventLoop = nil
        sut = nil
        environment = nil
    }

    func test_whenHandleListWithoutItems_statusIsNotFound() throws {
        // Given

        // When
        let feature = sut.handleList(on: eventLoop, request: Request(), environment: environment)
        let response = try feature.wait()

        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.notFound.code)
    }

    func test_whenHandleList_statusIsOk() throws {
        // Given
        try createSeries(SeriesFactory.make())

        // When
        let feature = sut.handleList(on: eventLoop, request: Request(), environment: environment)
        let response = try feature.wait()

        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.ok.code)
    }

}
