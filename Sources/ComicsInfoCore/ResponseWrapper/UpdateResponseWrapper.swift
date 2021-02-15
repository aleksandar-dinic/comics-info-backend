//
//  UpdateResponseWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 06/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import struct Logging.Logger
import Foundation
import NIO

public protocol UpdateResponseWrapper: ErrorResponseWrapper {

    func handleUpdate(
        on eventLoop: EventLoop,
        request: Request,
        environment: String?,
        logger: Logger
    ) -> EventLoopFuture<Response>

}
