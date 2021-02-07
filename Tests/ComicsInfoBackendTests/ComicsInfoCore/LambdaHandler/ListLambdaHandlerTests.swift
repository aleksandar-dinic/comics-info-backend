//
//  ListLambdaHandlerTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 20/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import XCTest
import NIO
import Logging

final class ListLambdaHandlerTests: XCTestCase, LambdaMockFactory {

    private var eventLoop: EventLoop!
    private var request: Request!
    private var logger: Logger!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        request = Request()
        logger = Logger(label: self.className)
        DatabaseMock.removeAll()
    }

    override func tearDownWithError() throws {
        eventLoop = nil
        request = nil
        logger = nil
    }

    func test_whenHandle_responseStatusIsOK() throws {
        // Given
        let items = CharacterFactory.makeDatabaseItems()
        let useCase = CharacterUseCaseFactoryMock(items: items, on: eventLoop, logger: logger).makeUseCase()
        let listResponseWrapper = CharacterListResponseWrapper(characterUseCase: useCase)
        let sut = ListLambdaHandler(
            makeLambdaInitializationContext(logger: logger, on: eventLoop),
            listResponseWrapper: listResponseWrapper
        )

        // When
        let responseFuture = sut.handle(
            context: makeLambdaContext(logger: logger, on: eventLoop),
            event: request
        )

        // Then
        let response = try responseFuture.wait()
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.ok.code)
    }

}
