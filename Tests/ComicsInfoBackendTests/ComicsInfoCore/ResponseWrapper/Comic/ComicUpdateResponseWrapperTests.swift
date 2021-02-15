//
//  ComicUpdateResponseWrapperTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 21/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import struct Logging.Logger
import XCTest
import NIO

final class ComicUpdateResponseWrapperTests: XCTestCase, CreateComicProtocol {

    private var eventLoop: EventLoop!
    private var sut: ComicUpdateResponseWrapper!
    private var logger: Logger!
    private var environment: String!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        MockDB.removeAll()
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        let useCase = ComicUpdateUseCaseFactoryMock(on: eventLoop).makeUseCase()
        sut = ComicUpdateResponseWrapper(comicUseCase: useCase)
        logger = Logger(label: "ComicUpdateResponseWrapperTests")
        environment = "TEST"
    }

    override func tearDownWithError() throws {
        eventLoop = nil
        sut = nil
        logger = nil
        environment = nil
    }

    func test_whenHandleUpdateWithoutBody_statusIsBadRequest() throws {
        // Given
        let request = Request()

        // When
        let feature = sut.handleUpdate(on: eventLoop, request: request, environment: environment, logger: logger)
        let response = try feature.wait()

        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.badRequest.code)
    }

    func test_whenHandleUpdateWithInvalidBody_statusIsBadRequest() throws {
        // Given
        let request = Request(body: "")

        // When
        let feature = sut.handleUpdate(on: eventLoop, request: request, environment: environment, logger: logger)
        let response = try feature.wait()

        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.badRequest.code)
    }

    func test_whenHandleUpdateNonExistingItem_statusIsNoContent() throws {
        // Given
        let request = Request(body: ComicFactory.requestBody)

        // When
        let feature = sut.handleUpdate(on: eventLoop, request: request, environment: environment, logger: logger)
        let response = try feature.wait()

        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.noContent.code)
    }

    func test_whenHandleUpdate_statusIsOk() throws {
        // Given
        let comic = ComicFactory.make(title: "Old Title")
        try createComic(comic)
        let request = Request(body: ComicFactory.requestBody)

        // When
        let feature = sut.handleUpdate(on: eventLoop, request: request, environment: environment, logger: logger)
        let response = try feature.wait()

        // Then
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.ok.code)
    }

}
