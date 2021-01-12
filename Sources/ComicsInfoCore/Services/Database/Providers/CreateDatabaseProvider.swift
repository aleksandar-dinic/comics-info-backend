//
//  CreateDatabaseProvider.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 08/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public final class CreateDatabaseProvider: CreateRepositoryAPIService {

    private var database: DatabaseCreate

    public init(database: DatabaseCreate) {
        self.database = database
    }
    
    public func create(_ item: DatabasePutItem) -> EventLoopFuture<Void> {
        database.create(item)
    }
    
    public func createAll(_ items: [DatabasePutItem]) -> EventLoopFuture<Void> {
        database.createAll(items)
    }
    
}
