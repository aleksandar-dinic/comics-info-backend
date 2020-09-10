//
//  Request+APIGateway.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 10/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import AWSLambdaEvents
import Foundation

extension Request {

    init(from request: APIGateway.V2.Request) {
        self.init(
            pathParameters: request.pathParameters
        )
    }

}
