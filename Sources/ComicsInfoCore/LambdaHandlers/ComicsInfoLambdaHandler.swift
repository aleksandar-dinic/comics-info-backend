//
//  ComicsInfoLambdaHandler.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 26/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import AWSLambdaRuntime
import Foundation
import NIO

struct ComicsInfoLambdaHandler: EventLoopLambdaHandler {

    typealias In = Request
    typealias Out = Response

    private let database: Database

    init(context: Lambda.InitializationContext) {
        database = DatabaseFectory().makeDatabase(eventLoop: context.eventLoop)
    }

    func handle(
        context: Lambda.Context,
        event: Request
    ) -> EventLoopFuture<Response> {
        if let data = try? JSONEncoder().encode(event) {
            context.logger.log(level: .info, "\(String(data: data, encoding: .utf8) ?? "")")
        }
        let handler = getHandler(for: event.context.http)

        switch handler {
        case let .characters(action):
            let provider = CharacterLambdaProvider(database: database, action: action)
            return provider.handle(on: context.eventLoop, request: event)

        case .series, .comics, .none:
            let response = Response(statusCode: .notFound)
            return context.eventLoop.makeSucceededFuture(response)
        }
    }

    private func getHandler(for http: HTTP) -> Handler? {
        HandlerFectory().makeHandler(
            path: http.path,
            method: HTTPMethod(rawValue: http.method.rawValue)
        )
    }

}
