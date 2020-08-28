//
//  ComicsInfoLambdaHandler.swift
//  ComicsInfoBackend
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

    init(context: Lambda.InitializationContext) {
        database = DatabaseFectory().makeDatabase(eventLoop: context.eventLoop)
    }

    func handle(
        context: Lambda.Context,
        event: APIGateway.V2.Request
    ) -> EventLoopFuture<APIGateway.V2.Response> {
        switch event.rawPath {
        case "/characters":
            let characterLambdaHandler = CharacterLambdaHandler(database: database)

            return characterLambdaHandler.handle(context: context, event: event)

        default:
            let response = APIGateway.V2.Response(statusCode: .notFound)

            return context.eventLoop.makeSucceededFuture(response)
        }
    }

}
