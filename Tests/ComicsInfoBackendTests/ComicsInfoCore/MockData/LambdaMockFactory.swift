//
//  LambdaMockFactory.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 20/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import AWSLambdaRuntimeCore
@testable import AWSLambdaEvents
import Foundation
import Logging
import NIO

protocol LambdaMockFactory {

    func makeLambdaInitializationContext(logger: Logger, on eventLoop: EventLoop) -> Lambda.InitializationContext
    func makeLambdaContext(logger: Logger, on eventLoop: EventLoop) -> Lambda.Context

}

extension LambdaMockFactory {

    func makeLambdaInitializationContext(logger: Logger, on eventLoop: EventLoop) -> Lambda.InitializationContext {
        Lambda.InitializationContext(
            logger: logger,
            eventLoop: eventLoop,
            allocator: ByteBufferAllocator()
        )
    }

    func makeLambdaContext(logger: Logger, on eventLoop: EventLoop) -> Lambda.Context {
        Lambda.Context(
            requestID: "requestID",
            traceID: "traceID",
            invokedFunctionARN: "invokedFunctionARN",
            deadline: DispatchWallTime(millisSinceEpoch: 0),
            logger: logger,
            eventLoop: eventLoop,
            allocator: ByteBufferAllocator()
        )
    }

}
