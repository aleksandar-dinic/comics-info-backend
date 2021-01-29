//
//  CreateResponseWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public protocol CreateResponseWrapper: ErrorResponseWrapper {

    func handleCreate(
        on eventLoop: EventLoop,
        request: Request,
        environment: String?
    ) -> EventLoopFuture<Response>

}
