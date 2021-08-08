//
//  DeleteLambdaHandlerTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 23/05/2021.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Logging
import NIO
import XCTest

final class DeleteLambdaHandlerTests: XCTestCase, LambdaMockFactory {

    private var eventLoop: EventLoop!
    private var request: Request!
    private var logger: Logger!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        logger = Logger(label: self.className)
    }

    override func tearDownWithError() throws {
        eventLoop = nil
        request = nil
        logger = nil
    }

    func test_whenHandle_responseStatusIsOk() throws {
        // Given
        request = Request(pathParameters: ["id": "CharacterID"])
        let items = CharacterFactory.makeDatabaseItems(ID: "CharacterID")
        let useCase = CharacterDeleteUseCaseFactoryMock(items: items, on: eventLoop).makeUseCase()
        let deleteResponseWrapper = CharacterDeleteResponseWrapper(useCase: useCase)
        let sut = DeleteLambdaHandler(
            makeLambdaInitializationContext(logger: logger, on: eventLoop),
            deleteResponseWrapper: deleteResponseWrapper
        )

        // When
        let responseFuture = sut.handle(context: makeLambdaContext(logger: logger, on: eventLoop), event: request)

        // Then
        let response = try responseFuture.wait()
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.ok.code)
    }

}
