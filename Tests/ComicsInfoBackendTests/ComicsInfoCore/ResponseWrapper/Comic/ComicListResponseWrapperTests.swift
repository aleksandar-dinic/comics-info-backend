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

final class ComicListResponseWrapperTests: XCTestCase, CreateComicProtocol {

    private typealias Cache = InMemoryCacheProvider<Comic>

    private var eventLoop: EventLoop!
    private var sut: ComicListResponseWrapper<ComicRepositoryAPIWrapper, Cache>!
    private var environment: String!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        DatabaseMock.removeAll()
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        let useCase = ComicUseCaseFactoryMock(on: eventLoop).makeUseCase()
        sut = ComicListResponseWrapper(comicUseCase: useCase)
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
        let feature = sut.handleList(on: eventLoop, environment: environment)
        let response = try feature.wait()

        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.notFound.code)
    }

    func test_whenHandleList_statusIsOk() throws {
        // Given
        try createComic(ComicMock.makeComic())

        // When
        let feature = sut.handleList(on: eventLoop, environment: environment)
        let response = try feature.wait()

        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.ok.code)
    }

}
