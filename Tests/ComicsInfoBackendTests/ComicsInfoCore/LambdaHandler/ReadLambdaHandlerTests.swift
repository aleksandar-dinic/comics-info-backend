//
//  ReadLambdaHandlerTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 20/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Logging
import NIO
import XCTest

final class ReadLambdaHandlerTests: XCTestCase, LambdaMockFactory {

    private var eventLoop: EventLoop!
    private var request: Request!
    private var logger: Logger!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        logger = Logger(label: self.className)
        MockDB.removeAll()
    }

    override func tearDownWithError() throws {
        eventLoop = nil
        request = nil
        logger = nil
    }

    func test_whenHandleRead_responseStatusIsOk() throws {
        // Given
        request = Request(pathParameters: ["id": "1"])
        let useCase = CharacterUseCaseFactoryMock(
            items: CharacterFactory.makeDatabaseItems(),
            on: eventLoop
        ).makeUseCase()
        let readResponseWrapper = CharacterReadResponseWrapper(characterUseCase: useCase)
        let sut = ReadLambdaHandler(
            makeLambdaInitializationContext(logger: logger, on: eventLoop),
            readResponseWrapper: readResponseWrapper
        )

        // When
        let responseFuture = sut.handle(context: makeLambdaContext(logger: logger, on: eventLoop), event: request)

        // Then
        let response = try responseFuture.wait()
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.ok.code)
    }
    
    func test_whenHandleList_responseStatusIsOK() throws {
        // Given
        request = Request()
        let items = CharacterFactory.makeDatabaseItems()
        let useCase = CharacterUseCaseFactoryMock(items: items, on: eventLoop).makeUseCase()
        let readResponseWrapper = CharacterReadResponseWrapper(characterUseCase: useCase)
        let sut = ReadLambdaHandler(
            makeLambdaInitializationContext(logger: logger, on: eventLoop),
            readResponseWrapper: readResponseWrapper
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
