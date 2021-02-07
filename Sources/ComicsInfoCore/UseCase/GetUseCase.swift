//
//  GetUseCase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 24/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public protocol GetUseCase {

    associatedtype DBService: ItemGetDBService
    associatedtype CacheService: Cacheable

    typealias Item = CacheService.Item

    var repository: GetRepository<Item, CacheService> { get }
    var availableFields: Set<String> { get }

    func getItem(
        on eventLoop: EventLoop,
        withID ID: String,
        fields: Set<String>?,
        from table: String,
        dataSource: DataSourceLayer
    ) -> EventLoopFuture<Item>

    func getItems(
        on eventLoop: EventLoop,
        withIDs IDs: Set<String>,
        from table: String,
        dataSource: DataSourceLayer
    ) -> EventLoopFuture<[Item]>
    
    func getAllItems(
        on eventLoop: EventLoop,
        from table: String,
        dataSource: DataSourceLayer
    ) -> EventLoopFuture<[Item]>
    
    func getSummaries<Summary: ItemSummary>(
        on eventLoop: EventLoop,
        forID ID: String,
        dataSource: DataSourceLayer,
        from table: String,
        by key: PartitionKey
    ) -> EventLoopFuture<[Summary]?>

}

public extension GetUseCase {
    
    func getItems(
        on eventLoop: EventLoop,
        withIDs IDs: Set<Item.ID>,
        from table: String,
        dataSource: DataSourceLayer = .memory
    ) -> EventLoopFuture<[Item]> {
        repository.getItems(with: GetItemsCriteria(IDs: IDs, dataSource: dataSource, table: table))
            .hop(to: eventLoop)
    }

    func getAllItems(
        on eventLoop: EventLoop,
        from table: String,
        dataSource: DataSourceLayer = .memory
    ) -> EventLoopFuture<[Item]> {
        repository.getAllItems(with: GetAllItemsCriteria(dataSource: dataSource, table: table))
            .hop(to: eventLoop)
    }
    
    func handleFields(_ fields: Set<String>?) throws -> Set<String> {
        guard let fields = fields else { return [] }
        
        guard fields.isSubset(of: availableFields) else {
            throw ComicInfoError.invalidFields(fields.filter { !availableFields.contains($0) })
        }
        return fields
    }
    
    func getSummaries<Summary: ItemSummary>(
        on eventLoop: EventLoop,
        forID ID: String,
        dataSource: DataSourceLayer,
        from table: String,
        by key: PartitionKey
    ) -> EventLoopFuture<[Summary]?> {
        repository.getSummaries(with: GetSummariesCriteria(ID: ID, dataSource: dataSource, table: table, key: key))
            .hop(to: eventLoop)
    }

}
