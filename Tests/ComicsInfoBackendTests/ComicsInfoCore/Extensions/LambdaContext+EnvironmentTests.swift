//
//  LambdaContext+EnvironmentTests.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 29/01/2021.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import AWSLambdaRuntime
import XCTest
import Logging
import NIO

final class LambdaContext_EnvironmentTests: XCTestCase, LambdaMockFactory {

    private var eventLoop: EventLoop!
    private var logger: Logger!
    private var context: Lambda.Context!
    
    override func setUpWithError() throws {
        eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        logger = Logger(label: self.className)
    }

    override func tearDownWithError() throws {
        eventLoop = nil
        logger = nil
    }
    
    func testIvalidEnvironment_whenGetEnvironmentFromContext_environmentIsNil() {
        // Given
        let invokedFunctionARN = ""
        context = makeLambdaContext(invokedFunctionARN: invokedFunctionARN, logger: logger, on: eventLoop)
        
        // When
        let environment = context.environment
        
        // Then
        XCTAssertNil(environment)
    }
    
    func testEnvironment_whenGetEnvironmentFromContext_environmentIsTEST() {
        // Given
        let invokedFunctionARN = "FunctionARN:TEST"
        context = makeLambdaContext(invokedFunctionARN: invokedFunctionARN, logger: logger, on: eventLoop)
        
        // When
        let environment = context.environment
        
        // Then
        XCTAssertEqual(environment, "TEST")
    }

}
