//
//  CreateLambdaHandler.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import AWSLambdaEvents
import AWSLambdaRuntime
import Foundation
import NIO

public struct CreateLambdaHandler: EventLoopLambdaHandler, LoggerProvider {

    public typealias In = Request
    public typealias Out = APIGateway.V2.Response

    private let createResponseWrapper: CreateResponseWrapper

    public init(
        _ context: Lambda.InitializationContext,
        createResponseWrapper: CreateResponseWrapper
    ) {
        self.createResponseWrapper = createResponseWrapper
    }

    public func handle(
        context: Lambda.Context,
        event: Request
    ) -> EventLoopFuture<APIGateway.V2.Response> {
        logRequest(context.logger, request: event)

        return createResponseWrapper.handleCreate(
            on: context.eventLoop,
            request: event,
            environment: context.environment,
            logger: context.logger
        ).map { APIGateway.V2.Response(from: $0) }
        .always { logResponse(context.logger, response: $0) }
    }

}
