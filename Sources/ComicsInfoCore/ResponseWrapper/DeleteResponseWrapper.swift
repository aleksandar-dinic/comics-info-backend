//
//  DeleteResponseWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 29/04/2021.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import struct Logging.Logger
import Foundation
import NIO

public protocol DeleteResponseWrapper: ErrorResponseWrapper {

    func handleDelete(
        on eventLoop: EventLoop,
        request: Request,
        environment: String?,
        logger: Logger?
    ) -> EventLoopFuture<Response>

}
