//
//  ErrorResponseWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 09/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public protocol ErrorResponseWrapper {

    func `catch`(
        _ error: Error,
        on eventLoop: EventLoop,
        statusCode: HTTPResponseStatus
    ) -> EventLoopFuture<Response>

}

extension ErrorResponseWrapper {

    public func `catch`(
        _ error: Error,
        on eventLoop: EventLoop,
        statusCode: HTTPResponseStatus = .notFound
    ) -> EventLoopFuture<Response> {
        let response = Response(with: error, statusCode: statusCode)

        return eventLoop.makeSucceededFuture(response)
    }

}
