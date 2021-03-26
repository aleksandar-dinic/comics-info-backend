//
//  GetUseCase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 24/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import struct Logging.Logger
import Foundation
import NIO

public protocol GetUseCase {

    associatedtype CacheService: Cacheable

    typealias Item = CacheService.Item

    var repository: GetRepository<Item, CacheService> { get }
    var availableFields: Set<String> { get }

    func appendSummaries(
        for item: Item,
        on eventLoop: EventLoop,
        fields: Set<String>,
        table: String,
        logger: Logger?
    ) -> EventLoopFuture<Item>
    
}

public extension GetUseCase {
    
    func getItem(
        on eventLoop: EventLoop,
        withID ID: String,
        fields: Set<String>?,
        from table: String,
        logger: Logger?,
        dataSource: DataSourceLayer = .memory
    ) -> EventLoopFuture<Item> {
        do {
            let fields = try handleFields(fields)
            let criteria = GetItemCriteria(ID: ID, dataSource: dataSource, table: table, logger: logger)
            return repository.getItem(with: criteria)
                .flatMap { appendSummaries(for: $0, on: eventLoop, fields: fields, table: table, logger: logger) }
                .hop(to: eventLoop)
        } catch {
            return eventLoop.makeFailedFuture(error)
        }
    }
    
    func getItems(
        on eventLoop: EventLoop,
        withIDs IDs: Set<Item.ID>,
        from table: String,
        logger: Logger?,
        dataSource: DataSourceLayer = .memory
    ) -> EventLoopFuture<[Item]> {
        let criteria = GetItemsCriteria(IDs: IDs, dataSource: dataSource, table: table, logger: logger)
        return repository.getItems(with: criteria)
            .hop(to: eventLoop)
    }
    
    func getAllItems(
        on eventLoop: EventLoop,
        afterID: String?,
        fields: Set<String>?,
        limit: Int,
        from table: String,
        logger: Logger?,
        dataSource: DataSourceLayer = .memory
    ) -> EventLoopFuture<[Item]> {
        do {
            let fields = try handleFields(fields)
            var criteria = GetAllItemsCriteria<Item>(
                afterID: afterID,
                sortValue: nil,
                dataSource: dataSource,
                limit: limit,
                table: table,
                logger: logger
            )
            
            guard let afterID = afterID else {
                return getAll(on: eventLoop, fields: fields, criteria: criteria)
            }
            
            return getItem(on: eventLoop, withID: afterID, fields: nil, from: table, logger: logger)
                .flatMap {
                    criteria.sortValue = $0.sortValue
                    return getAll(on: eventLoop, fields: fields, criteria: criteria)
                }
        } catch {
            return eventLoop.makeFailedFuture(error)
        }
    }
    
    private func getAll(
        on eventLoop: EventLoop,
        fields: Set<String>,
        criteria: GetAllItemsCriteria<Item>
    ) -> EventLoopFuture<[Item]> {
        repository.getAllItems(with: criteria)
            .flatMap {
                appendSummaries(
                    for: $0,
                    on: eventLoop,
                    fields: fields,
                    table: criteria.table,
                    logger: criteria.logger
                )
            }
    }
    
    private func appendSummaries(
        for items: [Item],
        on eventLoop: EventLoop,
        fields: Set<String>,
        table: String,
        logger: Logger?
    ) -> EventLoopFuture<[Item]> {
        let futures = items.map { appendSummaries(for: $0, on: eventLoop, fields: fields, table: table, logger: logger) }

        return EventLoopFuture.reduce([Item](), futures, on: eventLoop) { (items, item) in
            var items = items
            items.append(item)
            return items
        }
    }
    
    private func handleFields(_ fields: Set<String>?) throws -> Set<String> {
        guard let fields = fields else { return [] }
        
        guard fields.isSubset(of: availableFields) else {
            throw ComicInfoError.invalidFields(fields.filter { !availableFields.contains($0) })
        }
        return fields
    }
    
    func getSummaries<Summary: ItemSummary>(
        on eventLoop: EventLoop,
        with criteria: GetSummariesCriteria<Summary>
    ) -> EventLoopFuture<[Summary]?> {
        repository.getSummaries(with: criteria)
            .hop(to: eventLoop)
    }
    
    func getSummary<Summary: ItemSummary>(
        on eventLoop: EventLoop,
        with criteria: GetSummaryCriteria
    ) -> EventLoopFuture<[Summary]?> {
        repository.getSummary(with: criteria)
            .hop(to: eventLoop)
    }

}
