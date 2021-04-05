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
    
    typealias DatabaseService = ItemGetDBService & ItemCreateDBService & ItemUpdateDBService & ItemDeleteDBService

    private let database: DatabaseService

    public init(isLocalServer: Bool, eventLoop: EventLoop, items: [String: Data] = [:]) {
        if isLocalServer {
            database = MockDB(eventLoop: eventLoop, items: items)
        } else {
            database = SotoDynamoDB.DynamoDB(eventLoop: eventLoop)
        }
    }

    func makeDatabase() -> DatabaseService {
        database
    }

}
