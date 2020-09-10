//
//  Response+Extensions.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 27/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import AWSLambdaEvents
import Foundation

extension APIGateway.V2.Response {

    init(with response: Response) {
        self.init(
            statusCode: AWSLambdaEvents.HTTPResponseStatus(code: response.statusCode.code),
            headers: response.headers,
            multiValueHeaders: response.multiValueHeaders,
            body: response.body,
            isBase64Encoded: response.isBase64Encoded,
            cookies: response.cookies
        )
    }

}
