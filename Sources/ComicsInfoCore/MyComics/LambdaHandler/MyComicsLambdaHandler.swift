//
//  MyComicsLambdaHandler.swift
//  
//
//  Created by Aleksandar Dinic on 2/5/22.
//

import AWSLambdaEvents
import AWSLambdaRuntime
import Foundation
import NIO

public struct MyComicsLambdaHandler: EventLoopLambdaHandler, LoggerProvider {

    public typealias In = Request
    public typealias Out = APIGateway.V2.Response

    private let operation: CRUDOperation
    private let responseWrapper: MyComicsResponseWrapper

    public init(
        _ context: Lambda.InitializationContext,
        operation: CRUDOperation,
        isLocalServer: Bool = LocalServer.isEnabled
    ) {
        self.operation = operation
        let useCaseFactory = MyComicsUseCaseFactory(
            on: context.eventLoop,
            isLocalServer: isLocalServer
        )
        responseWrapper = MyComicsResponseWrapper(
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
        case .read:
            return responseWrapper.handleGet(
                on: context.eventLoop,
                request: event,
                environment: context.environment
            )
        case .update:
            return responseWrapper.handleUpdate(
                on: context.eventLoop,
                request: event,
                environment: context.environment
            )
        case .delete:
            return responseWrapper.handleDelete(
                on: context.eventLoop,
                request: event,
                environment: context.environment
            )
        }
    }

}
