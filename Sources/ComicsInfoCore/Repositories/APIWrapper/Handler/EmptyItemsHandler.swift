//
//  EmptyItemsHandler.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 05/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

protocol EmptyItemsHandler {

    var eventLoop: EventLoop { get }

    func handleEmptyItems<Item>() -> EventLoopFuture<[Item]>

}

extension EmptyItemsHandler {

    func handleEmptyItems<Item>() -> EventLoopFuture<[Item]> {
        let promise = eventLoop.makePromise(of: [Item].self)
        eventLoop.execute { promise.succeed([]) }
        return promise.futureResult
    }

}
