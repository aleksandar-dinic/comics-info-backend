//
//  SeriesCreateLambdaHandler.swift
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

struct SeriesCreateLambdaHandler: EventLoopLambdaHandler, LoggerProvider {

    typealias In = Request
    typealias Out = APIGateway.V2.Response

    private let seriesCreateResponseWrapper: SeriesCreateResponseWrapper

    init(context: Lambda.InitializationContext) {
        self.init(on: context.eventLoop, isLocalServer: LocalServer.isEnabled)
    }

    private init(on eventLoop: EventLoop, isLocalServer: Bool) {
        let seriesUseCaseFactory = SeriesUseCaseFactory(on: eventLoop, isLocalServer: isLocalServer)
        seriesCreateResponseWrapper = SeriesCreateResponseWrapper(seriesUseCase: seriesUseCaseFactory.makeSeriesUseCase())
    }

    func handle(
        context: Lambda.Context,
        event: Request
    ) -> EventLoopFuture<APIGateway.V2.Response> {
        logRequest(context.logger, request: event)

        return seriesCreateResponseWrapper.handleCreate(on: context.eventLoop, request: event)
            .map { APIGateway.V2.Response(from: $0) }
            .always { logResponse(context.logger, response: $0) }
    }

}
