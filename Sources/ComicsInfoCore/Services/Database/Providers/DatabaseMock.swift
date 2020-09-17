//
//  DatabaseMock.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 27/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

struct DatabaseMock: Database {

    private let eventLoop: EventLoop

    init(eventLoop: EventLoop) {
        self.eventLoop = eventLoop
    }

    func getAll(fromTable table: String) -> EventLoopFuture<[[String : Any]]?> {
        eventLoop.makeSucceededFuture([
            ["identifier": "1",
             "popularity": 0,
             "name": "Name"]
        ])
    }

    func get(fromTable table: String, forID ID: String) -> EventLoopFuture<[String : Any]?> {
        eventLoop.makeSucceededFuture([
            "identifier": "1",
            "popularity": 0,
            "name": "Name"
        ])
    }

}
