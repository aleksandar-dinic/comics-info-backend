//
//  Database.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 27/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public protocol Database {

    func getItem(withID itemID: String, tableName: String) -> EventLoopFuture<[DatabaseGetItem]>
    func getAll(_ items: String, tableName: String) -> EventLoopFuture<[DatabaseGetItem]>

    func getMetadata(withID id: String, tableName: String) -> EventLoopFuture<DatabaseGetItem>
    func getAllMetadata(withIDs ids: Set<String>, tableName: String) -> EventLoopFuture<[DatabaseGetItem]>

}

