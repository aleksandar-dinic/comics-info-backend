//
//  DatabaseFectory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 28/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import struct SotoDynamoDB.DynamoDB
import struct Logging.Logger
import Foundation
import NIO

public struct DatabaseFectory {

    private let isLocalServer: Bool

    public init(isLocalServer: Bool) {
        self.isLocalServer = isLocalServer
    }

    public func makeDatabase(
        eventLoop: EventLoop,
        logger: Logger,
        items: [String: Data] = [:]
    ) -> DatabaseGet {
        guard !isLocalServer else {
            return DatabaseMock(eventLoop: eventLoop, logger: logger, items: items)
        }

        return SotoDynamoDB.DynamoDB(eventLoop: eventLoop, logger: logger)
    }
    
    public func makeDatabaseCreate(
        eventLoop: EventLoop,
        logger: Logger
    ) -> DatabaseCreate {
        guard !isLocalServer else {
            return DatabaseMockCreate(eventLoop: eventLoop, logger: logger)
        }

        return SotoDynamoDB.DynamoDB(eventLoop: eventLoop, logger: logger)
    }
    
    public func makeDatabaseUpdate(
        eventLoop: EventLoop,
        logger: Logger,
        items: [String: Data] = [:]
    ) -> DatabaseUpdate {
        guard !isLocalServer else {
            return DatabaseMockUpdate(eventLoop: eventLoop, logger: logger, items: items)
        }

        return SotoDynamoDB.DynamoDB(eventLoop: eventLoop, logger: logger)
    }

}
