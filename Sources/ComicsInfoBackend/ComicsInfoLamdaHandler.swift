//
//  ComicsInfoLamdaHandler.swift
//  ComicsInfoBackend
//
//  Created by Aleksandar Dinic on 26/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import AWSLambdaEvents
import AWSLambdaRuntime
import Foundation
import NIO

struct ComicsInfoLamdaHandler: EventLoopLambdaHandler {

    typealias In = APIGateway.V2.Request
    typealias Out = APIGateway.V2.Response

    init(context: Lambda.InitializationContext) {
    }

    func handle(context: Lambda.Context, event: APIGateway.V2.Request) -> EventLoopFuture<APIGateway.V2.Response> {
        context.eventLoop.makeSucceededFuture(APIGateway.V2.Response(statusCode: .badRequest))
    }

}
