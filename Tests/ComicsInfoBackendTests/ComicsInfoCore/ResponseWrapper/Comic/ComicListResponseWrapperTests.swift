//
//  ComicListResponseWrapperTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 21/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest
import NIO

final class ComicListResponseWrapperTests: XCTestCase {

    private var eventLoop: EventLoop!
    private var sut: ComicListResponseWrapper!
    private var environment: String!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        MockDB.removeAll()
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        environment = "TEST"
    }

    override func tearDownWithError() throws {
        eventLoop = nil
        sut = nil
        environment = nil
    }

    func test_whenHandleListWithoutItems_statusIsNoContent() throws {
        // Given
        let useCase = ComicUseCaseFactoryMock(on: eventLoop).makeUseCase()
        sut = ComicListResponseWrapper(comicUseCase: useCase)
        let request = Request(queryParameters: ["seriesID": "1"])

        // When
        let feature = sut.handleList(on: eventLoop, request: request, environment: environment, logger: nil)
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
        sut = ComicListResponseWrapper(comicUseCase: useCase)
        let request = Request(queryParameters: ["seriesID": "1"])

        // When
        let feature = sut.handleList(on: eventLoop, request: request, environment: environment, logger: nil)
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
//        sut = ComicListResponseWrapper(comicUseCase: useCase)
//        let request = Request()
//
//        // When
//        let feature = sut.handleList(on: eventLoop, request: request, environment: environment, logger: nil)
//        let response = try feature.wait()
//
//        // Then
//        XCTAssertEqual(
//            response.statusCode.code,
//            ComicsInfoCore.HTTPResponseStatus.methodNotAllowed.code
//        )
//    }

}
