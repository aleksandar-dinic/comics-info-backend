//
//  CreateLambdaHandlerTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 20/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Logging
import NIO
import XCTest

final class CreateLambdaHandlerTests: XCTestCase, LambdaMockFactory {

    private var eventLoop: EventLoop!
    private var request: Request!
    private var logger: Logger!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        request = Request()
        logger = Logger(label: self.className)
    }

    override func tearDownWithError() throws {
        eventLoop = nil
        request = nil
        logger = nil
    }

    func test_whenHandle_responseStatusIsBadRequest() throws {
        // Given
        let useCase = CharacterCreateUseCaseFactoryMock(on: eventLoop, logger: logger).makeUseCase()
        let sut = CreateLambdaHandler(
            makeLambdaInitializationContext(logger: logger, on: eventLoop),
            createResponseWrapper: CharacterCreateResponseWrapper(useCase: useCase)
        )

        // When
        let responseFuture = sut.handle(context: makeLambdaContext(logger: logger, on: eventLoop), event: request)

        // Then
        let response = try responseFuture.wait()
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.badRequest.code)
    }

}
