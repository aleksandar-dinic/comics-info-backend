//
//  UseCase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 24/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public protocol UseCase where APIWrapper.Item == CacheService.Item {

    associatedtype APIWrapper: RepositoryAPIWrapper
    associatedtype CacheService: Cacheable

    typealias Item = APIWrapper.Item

    var repository: Repository<APIWrapper, CacheService> { get }

    func getItem(
        withID itemID: Item.ID,
        fromDataSource dataSource: DataSourceLayer,
        from table: String
    ) -> EventLoopFuture<Item>

    func getAllItems(
        fromDataSource dataSource: DataSourceLayer,
        from table: String
    ) -> EventLoopFuture<[Item]>

    func getMetadata(
        withID id: String,
        fromDataSource dataSource: DataSourceLayer,
        from table: String
    ) -> EventLoopFuture<Item>

    func getAllMetadata(
        withIDs ids: Set<String>,
        fromDataSource dataSource: DataSourceLayer,
        from table: String
    ) -> EventLoopFuture<[Item]>

}

public extension UseCase {

    func getItem(
        withID itemID: Item.ID,
        fromDataSource dataSource: DataSourceLayer,
        from table: String
    ) -> EventLoopFuture<Item> {
        repository.getItem(
            withID: itemID,
            fromDataSource: dataSource,
            from: table
        )
    }

    func getAllItems(
        fromDataSource dataSource: DataSourceLayer,
        from table: String
    ) -> EventLoopFuture<[Item]> {
        repository.getAllItems(fromDataSource: dataSource, from: table)
    }

    func getMetadata(
        withID id: Item.ID,
        fromDataSource dataSource: DataSourceLayer,
        from table: String
    ) -> EventLoopFuture<Item> {
        repository.getMetadata(
            withID: id,
            fromDataSource: dataSource,
            from: table
        )
    }

    func getAllMetadata(
        withIDs ids: Set<Item.ID>,
        fromDataSource dataSource: DataSourceLayer,
        from table: String
    ) -> EventLoopFuture<[Item]> {
        repository.getAllMetadata(
            withIDs: ids,
            fromDataSource: dataSource,
            from: table
        )
    }

}
