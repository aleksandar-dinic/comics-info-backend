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

    func appendSummaries(
        for item: Item,
        on eventLoop: EventLoop,
        fields: Set<String>,
        table: String
    ) -> EventLoopFuture<Item>
    
}

public extension GetUseCase {
    
    func getItem(
        on eventLoop: EventLoop,
        withID ID: String,
        fields: Set<String>?,
        from table: String,
        dataSource: DataSourceLayer = .memory
    ) -> EventLoopFuture<Item> {
        do {
            let fields = try handleFields(fields)
            return repository.getItem(with: GetItemCriteria(itemID: ID, dataSource: dataSource, table: table))
                .flatMap { appendSummaries(for: $0, on: eventLoop, fields: fields, table: table) }
                .hop(to: eventLoop)
        } catch {
            return eventLoop.makeFailedFuture(error)
        }
    }
    
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
        fields: Set<String>?,
        from table: String,
        dataSource: DataSourceLayer = .memory
    ) -> EventLoopFuture<[Item]> {
        do {
            let fields = try handleFields(fields)
            return repository.getAllItems(with: GetAllItemsCriteria(dataSource: dataSource, table: table))
                .flatMap { appendSummaries(for: $0, on: eventLoop, fields: fields, table: table) }
                .hop(to: eventLoop)
        } catch {
            return eventLoop.makeFailedFuture(error)
        }
    }
    
    private func appendSummaries(
        for items: [Item],
        on eventLoop: EventLoop,
        fields: Set<String>,
        table: String
    ) -> EventLoopFuture<[Item]> {
        let futures = items.map { appendSummaries(for: $0, on: eventLoop, fields: fields, table: table) }

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
        with criteria: [GetSummaryCriteria<Summary>]
    ) -> EventLoopFuture<[Summary]?> {
        repository.getSummary(with: criteria)
            .hop(to: eventLoop)
    }

}
