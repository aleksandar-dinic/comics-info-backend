//
//  LambdaHandlerFactory+ComicTests.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 07/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicInfo
@testable import ComicsInfoCore
import AWSLambdaRuntimeCore
import Logging
import NIO
import XCTest

final class LambdaHandlerFactory_ComicTests: XCTestCase, LambdaMockFactory {

    private var eventLoop: EventLoop!
    private var logger: Logger!
    private var context: Lambda.InitializationContext!

    override func setUpWithError() throws {
        _ = LocalServer(enabled: true)
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        logger = Logger(label: self.className)
        context = makeLambdaInitializationContext(logger: logger, on: eventLoop)
    }

    override func tearDownWithError() throws {
        eventLoop = nil
        logger = nil
        context = nil
    }

    func test_whenMakeReadLambdaHandler_isReadLambdaHandler() throws {
        // Given

        // When
        let sut = LambdaHandlerFactory.makeReadLambdaHandler(context)

        // Then
        XCTAssert(sut is ReadLambdaHandler)
    }

    func test_whenMakeListLambdaHandler_isListLambdaHandler() throws {
        // Given

        // When
        let sut = LambdaHandlerFactory.makeListLambdaHandler(context)

        // Then
        XCTAssert(sut is ListLambdaHandler)
    }

    func test_whenMakeCreateLambdaHandler_isCreateLambdaHandler() throws {
        // Given
        typealias UseCase = ComicUseCase<ComicRepositoryAPIWrapper, InMemoryCacheProvider<Comic>>

        // When
        let sut = LambdaHandlerFactory.makeCreateLambdaHandler(context)

        // Then
        XCTAssert(sut is CreateLambdaHandler<UseCase>)
    }

    func test_whenMakeUpdateLambdaHandler_isUpdateLambdaHandler() throws {
        // Given

        // When
        let sut = LambdaHandlerFactory.makeUpdateLambdaHandler(context)

        // Then
        XCTAssert(sut is UpdateLambdaHandler)
    }


}
