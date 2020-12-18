//
//  ReadLambdaHandler.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 24/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import AWSLambdaEvents
import AWSLambdaRuntime
import Foundation
import NIO

public struct ReadLambdaHandler: EventLoopLambdaHandler, LoggerProvider {

    public typealias In = Request
    public typealias Out = APIGateway.V2.Response

    private let readResponseWrapper: ReadResponseWrapper

    public init(
        _ context: Lambda.InitializationContext,
        readResponseWrapper: ReadResponseWrapper
    ) {
        self.readResponseWrapper = readResponseWrapper
    }

    public func handle(
        context: Lambda.Context,
        event: Request
    ) -> EventLoopFuture<APIGateway.V2.Response> {
        logRequest(context.logger, request: event)

        return readResponseWrapper.handleRead(
            on: context.eventLoop,
            request: event,
            environment: context.environment
        )
            .map { APIGateway.V2.Response(from: $0) }
            .always { logResponse(context.logger, response: $0) }
    }

}
