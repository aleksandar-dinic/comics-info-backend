//
//  DatabaseFectory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 28/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import struct SotoDynamoDB.DynamoDB
import Foundation
import NIO

public struct DatabaseFectory {

    private let isLocalServer: Bool

    public init(isLocalServer: Bool) {
        self.isLocalServer = isLocalServer
    }

    public func makeDatabase(eventLoop: EventLoop) -> Database {
        guard !isLocalServer else {
            return DatabaseMock(eventLoop: eventLoop)
        }

        return SotoDynamoDB.DynamoDB(eventLoop: eventLoop)
    }

}
