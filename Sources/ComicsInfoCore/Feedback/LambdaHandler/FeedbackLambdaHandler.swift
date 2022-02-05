//
//  FeedbackLambdaHandler.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 02/09/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import AWSLambdaEvents
import AWSLambdaRuntime
import Foundation
import NIO

public struct FeedbackLambdaHandler: EventLoopLambdaHandler, LoggerProvider {

    public typealias In = Request
    public typealias Out = APIGateway.V2.Response

    private let operation: CRUDOperation
    private let responseWrapper: FeedbackResponseWrapper

    public init(
        _ context: Lambda.InitializationContext,
        operation: CRUDOperation,
        isLocalServer: Bool = LocalServer.isEnabled
    ) {
        self.operation = operation
        let useCaseFactory = FeedbackUseCaseFactory(
            on: context.eventLoop,
            isLocalServer: isLocalServer
        )
        responseWrapper = FeedbackResponseWrapper(
            useCase: useCaseFactory.makeUseCase()
        )
    }

    public func handle(
        context: Lambda.Context,
        event: Request
    ) -> EventLoopFuture<APIGateway.V2.Response> {
        logRequest(context.logger, request: event)
        
        return handle(operation, context: context, event: event)
            .map { APIGateway.V2.Response(from: $0) }
            .always { logResponse(context.logger, response: $0) }
    }
    
    private func handle(
        _ operation: CRUDOperation,
        context: Lambda.Context,
        event: Request
    ) -> EventLoopFuture<Response> {
        switch operation {
        case .create:
            return responseWrapper.handleCreate(
                on: context.eventLoop,
                request: event,
                environment: context.environment
            )
        default:
            return context.eventLoop.makeFailedFuture(ComicInfoError.handlerUnknown)
        }
    }
    
}
