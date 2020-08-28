//
//  DatabaseFectory.swift
//  ComicsInfoBackend
//
//  Created by Aleksandar Dinic on 28/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import struct AWSDynamoDB.DynamoDB
import Foundation
import NIO

struct DatabaseFectory {

    private let mocked: Bool

    init(mocked: Bool = ProcessInfo.processInfo.environment["LOCAL_LAMBDA_SERVER_ENABLED"] == "true") {
        self.mocked = mocked
    }

    func makeDatabase(eventLoop: EventLoop) -> Database {
        guard !mocked else {
            return DatabaseMock(eventLoop: eventLoop)
        }

        return AWSDynamoDB.DynamoDB(eventLoop: eventLoop)
    }

}
