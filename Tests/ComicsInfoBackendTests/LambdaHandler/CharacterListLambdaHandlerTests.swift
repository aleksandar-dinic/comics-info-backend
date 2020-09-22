//
//  CharacterListLambdaHandlerTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 20/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import CharacterInfo
@testable import ComicsInfoCore
import XCTest
import NIO
import Logging

final class CharacterListLambdaHandlerTests: XCTestCase, LambdaFactory {

    private var eventLoop: EventLoop!
    private var request: Request!
    private var logger: Logger!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        request = Request(pathParameters: nil, body: nil)
        logger = Logger(label: self.className)
    }

    override func tearDownWithError() throws {
        eventLoop = nil
        request = nil
        logger = nil
    }

    func test_whenHandle_responseStatusIsOK() throws {
        // Given
        let sut = CharacterListLambdaHandler(context: makeLambdaInitializationContext(logger: logger, on: eventLoop))

        // When
        let responseFuture = sut.handle(context: makeLambdaContext(logger: logger, on: eventLoop), event: request)

        // Then
        let response = try responseFuture.wait()
        XCTAssertEqual(response.statusCode.code, ComicsInfoCore.HTTPResponseStatus.ok.code)
    }

}
