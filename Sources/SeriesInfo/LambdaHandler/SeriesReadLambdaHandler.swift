//
//  SeriesReadLambdaHandler.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import AWSLambdaEvents
import AWSLambdaRuntime
import ComicsInfoCore
import Foundation
import NIO

struct SeriesReadLambdaHandler: EventLoopLambdaHandler, LoggerProvider {

    typealias In = Request
    typealias Out = APIGateway.V2.Response

    private let seriesReadResponseWrapper: SeriesReadResponseWrapper

    init(context: Lambda.InitializationContext) {
        self.init(on: context.eventLoop, isLocalServer: LocalServer.isEnabled)
    }

    private init(on eventLoop: EventLoop, isLocalServer: Bool) {
        let seriesUseCaseFactory = SeriesUseCaseFactory(on: eventLoop, isLocalServer: isLocalServer)
        seriesReadResponseWrapper = SeriesReadResponseWrapper(seriesUseCase: seriesUseCaseFactory.makeSeriesUseCase())
    }

    func handle(
        context: Lambda.Context,
        event: Request
    ) -> EventLoopFuture<APIGateway.V2.Response> {
        logRequest(context.logger, request: event)

        return seriesReadResponseWrapper.handleRead(on: context.eventLoop, request: event)
            .map { APIGateway.V2.Response(from: $0) }
            .always { logResponse(context.logger, response: $0) }
    }

}
