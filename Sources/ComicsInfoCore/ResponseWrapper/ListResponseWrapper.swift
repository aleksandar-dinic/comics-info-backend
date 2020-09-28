//
//  ListResponseWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 24/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public protocol ListResponseWrapper: ErrorResponseWrapper {

    func handleList(on eventLoop: EventLoop) -> EventLoopFuture<Response>

}
