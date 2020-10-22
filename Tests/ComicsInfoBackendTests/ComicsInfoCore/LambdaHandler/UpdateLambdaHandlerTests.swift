//
//  UpdateLambdaHandlerTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 08/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Logging
import NIO
import XCTest

final class UpdateLambdaHandlerTests: XCTestCase, LambdaMockFactory, CreateCharacterProtocol {

    private var eventLoop: EventLoop!
    private var request: Request!
    private var logger: Logger!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        DatabaseMock.removeAll()
        try createCharacter(CharacterMock.makeCharacter())
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        request = Request(pathParameters: nil, body: CharacterMock.requestBody)
        logger = Logger(label: self.className)
    }

    override func tearDownWithError() throws {
        eventLoop = nil
        request = nil
        logger = nil
    }

    func test_whenHandle_responseStatusIsOk() throws {
        // Given
        let useCase = CharacterUseCaseFactoryMock(on: eventLoop, logger: logger).makeUseCase()
        let updateResponseWrapper = CharacterUpdateResponseWrapper(characterUseCase: useCase)
        let sut = UpdateLambdaHandler(
            makeLambdaInitializationContext(logger: logger, on: eventLoop),
            updateResponseWrapper: updateResponseWrapper
        )

        // When
        let responseFuture = sut.handle(context: makeLambdaContext(logger: logger, on: eventLoop), event: request)

        // Then
        let response = try responseFuture.wait()
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.ok.code)
    }

}
