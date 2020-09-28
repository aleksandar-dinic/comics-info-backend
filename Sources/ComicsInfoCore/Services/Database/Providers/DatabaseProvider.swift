//
//  DatabaseProvider.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 24/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public final class DatabaseProvider: RepositoryAPIService {

    private var database: Database
    private let tableName: String

    public init(database: Database, tableName: String) {
        self.database = database
        self.tableName = tableName
    }

    public func create(_ item: [String: Any]) -> EventLoopFuture<Void> {
        database.create(item, tableName: tableName)
    }

    public func getAll(on eventLoop: EventLoop) -> EventLoopFuture<[[String: Any]]?> {
        database.getAll(fromTable: tableName)
    }

    public func get<ID: Hashable>(
        withID identifier: ID,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<[String: Any]?> {
        database.get(fromTable: tableName, forID: identifier)
    }

//    func updateSeries(_ series: Series) -> EventLoopFuture<Series> {
//    }
//
//    func deleteSeries(forID seriesID: String) -> EventLoopFuture<Series> {
//    }

}
