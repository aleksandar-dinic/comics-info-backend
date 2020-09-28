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

    /// Create item.
    ///
    /// - Parameter item: The item.
    /// - Returns: Future with Item value.
    public func create(_ item: Item) -> EventLoopFuture<Void> {
        dataProvider.create(item)
    }

    /// Gets all items.
    ///
    /// - Parameter dataSource: Layer of data source.
    /// - Returns: Future with Items value.
    public func getAll(
        fromDataSource dataSource: DataSourceLayer,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<[Item]> {
        dataProvider.getAll(fromDataSource: dataSource, on: eventLoop)
    }

    /// Gets item.
    ///
    /// - Parameters:
    ///   - identifier: Item ID.
    ///   - dataSource: Layer of data source
    /// - Returns: Future with Item value.
    public func get(
        withID identifier: Item.ID,
        fromDataSource dataSource: DataSourceLayer,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<Item> {
        dataProvider.get(
            withID: identifier,
            fromDataSource: dataSource,
            on: eventLoop
        )
    }

}
