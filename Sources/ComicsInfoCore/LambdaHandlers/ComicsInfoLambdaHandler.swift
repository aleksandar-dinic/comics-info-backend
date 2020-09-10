//
//  ComicsInfoLambdaHandler.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 26/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import AWSLambdaEvents
import AWSLambdaRuntime
import Foundation
import NIO

struct ComicsInfoLambdaHandler: EventLoopLambdaHandler {

    typealias In = APIGateway.V2.Request
    typealias Out = APIGateway.V2.Response

    private let database: Database

    init(context: Lambda.InitializationContext) {
        database = DatabaseFectory().makeDatabase(eventLoop: context.eventLoop)
    }

    func handle(
        context: Lambda.Context,
        event: APIGateway.V2.Request
    ) -> EventLoopFuture<APIGateway.V2.Response> {
        let handler = getHandler(for: event.context.http)

        switch handler {
        case let .characters(action):
            let provider = CharacterLambdaProvider(database: database, action: action)
            return provider.handle(on: context.eventLoop, event: event)

        case .series, .comics, .none:
            let response = APIGateway.V2.Response(statusCode: .notFound)
            return context.eventLoop.makeSucceededFuture(response)
        }
    }

    private func getHandler(for http: APIGateway.V2.Request.Context.HTTP) -> Handler? {
        HandlerFectory().makeHandler(
            path: http.path,
            method: HTTPMethod(rawValue: http.method.rawValue)
        )
    }

}
