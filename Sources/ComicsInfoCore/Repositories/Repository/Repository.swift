//
//  Repository.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 24/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public final class Repository<APIWrapper: RepositoryAPIWrapper, CacheProvider: Cacheable> where APIWrapper.Item == CacheProvider.Item {

    public typealias Item = APIWrapper.Item

    private let dataProvider: DataProvider<APIWrapper, CacheProvider>

    init(dataProvider: DataProvider<APIWrapper, CacheProvider>) {
        self.dataProvider = dataProvider
    }

    public func getItem(
        withID itemID: Item.ID,
        dataSource: DataSourceLayer,
        from table: String
    ) -> EventLoopFuture<Item> {
        dataProvider.getItem(
            withID: itemID,
            dataSource: dataSource,
            from: table
        )
    }
    
    public func getItems(
        withIDs IDs: Set<String>,
        dataSource: DataSourceLayer,
        from table: String
    ) -> EventLoopFuture<[Item]> {
        dataProvider.getItems(withIDs: IDs, dataSource: dataSource, from: table)
    }

    public func getAllItems(dataSource: DataSourceLayer, from table: String) -> EventLoopFuture<[Item]> {
        dataProvider.getAllItems(dataSource: dataSource, from: table)
    }
    
    public func getSummaries<Summary: ItemSummary>(
        _ type: Summary.Type,
        forID ID: String,
        dataSource: DataSourceLayer,
        from table: String
    ) -> EventLoopFuture<[Summary]?> {
        dataProvider.getSummaries(type, forID: ID, dataSource: dataSource, from: table)
    }

}
