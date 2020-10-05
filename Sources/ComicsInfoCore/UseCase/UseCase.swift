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

    func create(_ item: Item) -> EventLoopFuture<Void>

    func getItem(
        withID itemID: Item.ID,
        fromDataSource dataSource: DataSourceLayer
    ) -> EventLoopFuture<Item>

    func getAllItems(
        fromDataSource dataSource: DataSourceLayer
    ) -> EventLoopFuture<[Item]>

    func getMetadata(
        withID id: String,
        fromDataSource dataSource: DataSourceLayer
    ) -> EventLoopFuture<Item>

    func getAllMetadata(
        withIDs ids: Set<String>,
        fromDataSource dataSource: DataSourceLayer
    ) -> EventLoopFuture<[Item]>

}

public extension UseCase {

    func create(_ item: Item) -> EventLoopFuture<Void> {
        repository.create(item)
    }

    func getItem(
        withID itemID: Item.ID,
        fromDataSource dataSource: DataSourceLayer
    ) -> EventLoopFuture<Item> {
        repository.getItem(
            withID: itemID,
            fromDataSource: dataSource
        )
    }

    func getAllItems(
        fromDataSource dataSource: DataSourceLayer
    ) -> EventLoopFuture<[Item]> {
        repository.getAllItems(fromDataSource: dataSource)
    }

    func getMetadata(
        withID id: Item.ID,
        fromDataSource dataSource: DataSourceLayer
    ) -> EventLoopFuture<Item> {
        repository.getMetadata(
            withID: id,
            fromDataSource: dataSource
        )
    }

    func getAllMetadata(
        withIDs ids: Set<Item.ID>,
        fromDataSource dataSource: DataSourceLayer
    ) -> EventLoopFuture<[Item]> {
        repository.getAllMetadata(withIDs: ids, fromDataSource: dataSource)
    }

}
