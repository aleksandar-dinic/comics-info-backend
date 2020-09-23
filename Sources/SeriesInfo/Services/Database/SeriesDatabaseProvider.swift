//
//  SeriesDatabaseProvider.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import ComicsInfoCore
import Foundation
import NIO

final class SeriesDatabaseProvider: SeriesAPIService {

    private var database: Database
    private let tableName: String

    init(database: Database, tableName: String = DatabaseTable().name) {
        self.database = database
        self.tableName = tableName
    }

    func create(_ series: Series) -> EventLoopFuture<Void> {
        let mirror = Mirror(reflecting: series)
        var item = [String: Any]()

        for child in mirror.children {
            guard let label = child.label else { continue }
            if case Optional<Any>.none = child.value { continue }
            item[label] = child.value
        }

        return database.create(item, tableName: tableName)
    }

    func getAllSeries(on eventLoop: EventLoop) -> EventLoopFuture<[[String: Any]]?> {
        database.getAll(fromTable: tableName)
    }

    func getSeries(
        withID seriesID: String,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<[String: Any]?> {
        database.get(fromTable: tableName, forID: seriesID)
    }

//    func updateSeries(_ series: Series) -> EventLoopFuture<Series> {
//    }
//
//    func deleteSeries(forID seriesID: String) -> EventLoopFuture<Series> {
//    }

}
