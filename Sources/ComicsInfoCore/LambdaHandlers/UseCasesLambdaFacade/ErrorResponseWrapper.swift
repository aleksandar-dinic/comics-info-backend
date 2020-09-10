//
//  ErrorResponseWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 09/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

protocol ErrorResponseWrapper {

    func catchError(on eventLoop: EventLoop, error: Error) -> EventLoopFuture<Response>

}

extension ErrorResponseWrapper {

    func catchError(
        on eventLoop: EventLoop,
        error: Error
    ) -> EventLoopFuture<Response> {
        let response = Response(with: error, statusCode: .notFound)

        return eventLoop.makeSucceededFuture(response)
    }

}
