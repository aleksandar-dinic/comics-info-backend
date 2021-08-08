//
//  DeleteLambdaHandler.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 21/05/2021.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import AWSLambdaEvents
import AWSLambdaRuntime
import Foundation
import NIO

public struct DeleteLambdaHandler: EventLoopLambdaHandler, LoggerProvider {

    public typealias In = Request
    public typealias Out = APIGateway.V2.Response

    private let deleteResponseWrapper: DeleteResponseWrapper

    public init(
        _ context: Lambda.InitializationContext,
        deleteResponseWrapper: DeleteResponseWrapper
    ) {
        self.deleteResponseWrapper = deleteResponseWrapper
    }

    public func handle(
        context: Lambda.Context,
        event: Request
    ) -> EventLoopFuture<APIGateway.V2.Response> {
        logRequest(context.logger, request: event)

        return deleteResponseWrapper.handleDelete(
            on: context.eventLoop,
            request: event,
            environment: context.environment,
            logger: context.logger
        ).map { APIGateway.V2.Response(from: $0) }
        .always { logResponse(context.logger, response: $0) }
    }

}
