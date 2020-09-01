//
//  ComicsInfoLambdaHandler.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 26/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import AsyncHTTPClient
import AWSDynamoDB
import AWSLambdaEvents
import AWSLambdaRuntime
import Foundation

struct ComicsInfoLambdaHandler: EventLoopLambdaHandler {

    typealias In = APIGateway.V2.Request
    typealias Out = APIGateway.V2.Response

    private let database: Database
    private let handlerFectory: HandlerFectory

    init(context: Lambda.InitializationContext) {
        database = DatabaseFectory().makeDatabase(eventLoop: context.eventLoop)
        handlerFectory = HandlerFectory()
    }

    func handle(
        context: Lambda.Context,
        event: APIGateway.V2.Request
    ) -> EventLoopFuture<APIGateway.V2.Response> {
        let handler = handlerFectory.makeHandler(
            path: event.context.http.path,
            method: event.context.http.method
        )
        switch handler {
        case let .characters(action):
            let characterLambdaHandler = CharacterLambdaHandler(action: action, database: database)
            return characterLambdaHandler.handle(context: context, event: event)

        case .series, .comics, .none:
            let response = APIGateway.V2.Response(statusCode: .notFound)
            return context.eventLoop.makeSucceededFuture(response)
        }
    }

}
