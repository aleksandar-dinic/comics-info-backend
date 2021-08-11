//
//  LambdaHandlerFactoryTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 11/08/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

//@testable import ComicsInfo
//@testable import ComicsInfoCore
//import AWSLambdaRuntimeCore
//import XCTest
//import Logging
//import NIO
//
//final class LambdaHandlerFactoryTests: XCTestCase, LambdaMockFactory {
//
//    private var eventLoop: EventLoop!
//    private var logger: Logger!
//    private var context: Lambda.InitializationContext!
//
//    override func setUpWithError() throws {
//        _ = LocalServer(enabled: true)
//        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
//        logger = Logger(label: self.className)
//        context = makeLambdaInitializationContext(logger: logger, on: eventLoop)
//    }
//
//    override func tearDownWithError() throws {
//        eventLoop = nil
//        logger = nil
//        context = nil
//    }
//
//    func test_whenMakeReadLambdaHandler_isReadLambdaHandler() throws {
//        // Given
//
//        // When
//        let sut = LambdaHandlerFactory.makeReadLambdaHandler(context)
//
//        // Then
//        XCTAssert(sut is ReadLambdaHandler)
//    }
//
//    func test_whenMakeListLambdaHandler_isListLambdaHandler() throws {
//        // Given
//
//        // When
//        let sut = LambdaHandlerFactory.makeListLambdaHandler(context)
//
//        // Then
//        XCTAssert(sut is ListLambdaHandler)
//    }
//
//    func test_whenMakeCreateLambdaHandler_isCreateLambdaHandler() throws {
//        // Given
//
//        // When
//        let sut = CreateLambdaHandlerFactory.makeHandler(context)
//
//        // Then
//        XCTAssert(sut is CreateLambdaHandler)
//    }
//
//    func test_whenMakeUpdateLambdaHandler_isUpdateLambdaHandler() throws {
//        // Given
//
//        // When
//        let sut = UpdateLambdaHandlerFactory.makeHandler(context)
//
//        // Then
//        XCTAssert(sut is UpdateLambdaHandler)
//    }
//
//    func test_whenMakeDeleteLambdaHandler_isDeleteLambdaHandler() throws {
//        // Given
//
//        // When
//        let sut = DeleteLambdaHandlerFactory.makeHandler(context)
//
//        // Then
//        XCTAssert(sut is DeleteLambdaHandler)
//    }
//
//}

//@testable import ComicInfo
//@testable import ComicsInfoCore
//import AWSLambdaRuntimeCore
//import Logging
//import NIO
//import XCTest
//
//final class LambdaHandlerFactory_ComicTests: XCTestCase, LambdaMockFactory {
//
//    private var eventLoop: EventLoop!
//    private var logger: Logger!
//    private var context: Lambda.InitializationContext!
//
//    override func setUpWithError() throws {
//        _ = LocalServer(enabled: true)
//        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
//        logger = Logger(label: self.className)
//        context = makeLambdaInitializationContext(logger: logger, on: eventLoop)
//    }
//
//    override func tearDownWithError() throws {
//        eventLoop = nil
//        logger = nil
//        context = nil
//    }
//
//    func test_whenMakeReadLambdaHandler_isReadLambdaHandler() throws {
//        // Given
//
//        // When
//        let sut = LambdaHandlerFactory.makeReadLambdaHandler(context)
//
//        // Then
//        XCTAssert(sut is ReadLambdaHandler)
//    }
//
//    func test_whenMakeListLambdaHandler_isListLambdaHandler() throws {
//        // Given
//
//        // When
//        let sut = LambdaHandlerFactory.makeListLambdaHandler(context)
//
//        // Then
//        XCTAssert(sut is ListLambdaHandler)
//    }
//
//    func test_whenMakeCreateLambdaHandler_isCreateLambdaHandler() throws {
//        // Given
//
//        // When
//        let sut = LambdaCreateHandlerFactory.makeHandler(context)
//
//        // Then
//        XCTAssert(sut is CreateLambdaHandler)
//    }
//
//    func test_whenMakeUpdateLambdaHandler_isUpdateLambdaHandler() throws {
//        // Given
//
//        // When
//        let sut = LambdaUpdateHandlerFactory.makeHandler(context)
//
//        // Then
//        XCTAssert(sut is UpdateLambdaHandler)
//    }
//    
//    func test_whenMakeDeleteLambdaHandler_isDeleteLambdaHandler() throws {
//        // Given
//
//        // When
//        let sut = LambdaDeleteHandlerFactory.makeHandler(context)
//
//        // Then
//        XCTAssert(sut is DeleteLambdaHandler)
//    }
//
//}

//@testable import SeriesInfo
//@testable import ComicsInfoCore
//import AWSLambdaRuntimeCore
//import XCTest
//import Logging
//import NIO
//
//final class LambdaHandlerFactory_SeriesTests: XCTestCase, LambdaMockFactory {
//
//    private var eventLoop: EventLoop!
//    private var logger: Logger!
//    private var context: Lambda.InitializationContext!
//
//    override func setUpWithError() throws {
//        _ = LocalServer(enabled: true)
//        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
//        logger = Logger(label: self.className)
//        context = makeLambdaInitializationContext(logger: logger, on: eventLoop)
//    }
//
//    override func tearDownWithError() throws {
//        eventLoop = nil
//        logger = nil
//        context = nil
//    }
//
//    func test_whenMakeReadLambdaHandler_isReadLambdaHandler() throws {
//        // Given
//
//        // When
//        let sut = LambdaHandlerFactory.makeReadLambdaHandler(context)
//
//        // Then
//        XCTAssert(sut is ReadLambdaHandler)
//    }
//
//    func test_whenMakeListLambdaHandler_isListLambdaHandler() throws {
//        // Given
//
//        // When
//        let sut = LambdaHandlerFactory.makeListLambdaHandler(context)
//
//        // Then
//        XCTAssert(sut is ListLambdaHandler)
//    }
//
//    func test_whenMakeCreateLambdaHandler_isCreateLambdaHandler() throws {
//        // Given
//
//        // When
//        let sut = LambdaCreateHandlerFactory.makeHandler(context)
//
//        // Then
//        XCTAssert(sut is CreateLambdaHandler)
//    }
//
//    func test_whenMakeUpdateLambdaHandler_isUpdateLambdaHandler() throws {
//        // Given
//
//        // When
//        let sut = LambdaUpdateHandlerFactory.makeHandler(context)
//
//        // Then
//        XCTAssert(sut is UpdateLambdaHandler)
//    }
//    
//    func test_whenMakeDeleteLambdaHandler_isDeleteLambdaHandler() throws {
//        // Given
//
//        // When
//        let sut = LambdaDeleteHandlerFactory.makeHandler(context)
//
//        // Then
//        XCTAssert(sut is DeleteLambdaHandler)
//    }
//
//}
