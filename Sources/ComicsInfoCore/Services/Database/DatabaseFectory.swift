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
    private let tableName: String

    public init(isLocalServer: Bool, tableName: String) {
        self.isLocalServer = isLocalServer
        self.tableName = tableName
    }

    public func makeDatabase(eventLoop: EventLoop) -> Database {
        guard !isLocalServer else {
            return DatabaseMock(eventLoop: eventLoop, tableName: tableName)
        }

        return SotoDynamoDB.DynamoDB(eventLoop: eventLoop, tableName: tableName)
    }

}
