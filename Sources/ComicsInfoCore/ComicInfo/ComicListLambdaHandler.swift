//
//  ComicListLambdaHandler.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 26/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import AWSLambdaRuntime
import Foundation
import NIO

struct ComicListLambdaHandler: EventLoopLambdaHandler {

    typealias In = Request
    typealias Out = Response

    private let database: Database

    init(context: Lambda.InitializationContext) {
        database = DatabaseFectory(isLocalServer: ComicInfo.isMocked).makeDatabase(eventLoop: context.eventLoop)
    }

    func handle(
        context: Lambda.Context,
        event: Request
    ) -> EventLoopFuture<Response> {
        if let data = try? JSONEncoder().encode(event) {
            context.logger.log(level: .info, "\(String(data: data, encoding: .utf8) ?? "")")
        }

        let response = Response(statusCode: .notImplemented)
        return context.eventLoop.makeSucceededFuture(response)
    }

}
