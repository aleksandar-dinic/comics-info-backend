//
//  ItemGetDBWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 24/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

struct ItemGetDBWrapper<Item: ComicInfoItem>: LoggerProvider {

    let itemGetDBService: ItemGetDBService

    func getItem(with criteria: GetItemCriteria) -> EventLoopFuture<Item> {
        let query = GetItemQuery(
            ID: .comicInfoID(for: Item.self, ID: criteria.ID),
            table: criteria.table,
            logger: criteria.logger
        )

        return itemGetDBService.getItem(query)
            .flatMapErrorThrowing {
                logError(criteria.logger, error: $0)
                throw $0.mapToComicInfoError(itemType: Item.self)
            }
    }
    
    func getItems(with criteria: GetItemsCriteria) -> EventLoopFuture<[Item]> {
        let query = GetItemsQuery(
            IDs: Set(criteria.IDs.map { .comicInfoID(for: Item.self, ID: $0) }),
            table: criteria.table,
            logger: criteria.logger
        )
        
        return itemGetDBService.getItems(query)
            .flatMapErrorThrowing {
                logError(criteria.logger, error: $0)
                throw $0.mapToComicInfoError(itemType: Item.self)
            }
    }
    
    func getAllItems(with criteria: GetAllItemsCriteria) -> EventLoopFuture<[Item]> {
        let query = GetAllItemsQuery(
            items: .getType(from: Item.self),
            table: criteria.table,
            logger: criteria.logger
        )
        
        return itemGetDBService.getAll(query)
            .flatMapErrorThrowing {
                logError(criteria.logger, error: $0)
                throw $0.mapToComicInfoError(itemType: Item.self)
            }
    }
    
    func getSummaries<Summary: ItemSummary>(
        with criteria: GetSummariesCriteria<Summary>
    ) -> EventLoopFuture<[Summary]?> {
        let query = GetSummariesQuery(
            itemType: criteria.itemType,
            ID: criteria.ID,
            table: criteria.table,
            strategy: criteria.strategy,
            logger: criteria.logger
        )
        return itemGetDBService.getSummaries(query)
            .flatMapErrorThrowing {
                logError(criteria.logger, error: $0)
                throw $0.mapToComicInfoError(itemType: Summary.self)
            }
    }
    
    func getSummary<Summary: ItemSummary>(with criteria: GetSummaryCriteria) -> EventLoopFuture<[Summary]?> {
        let query = GetSummaryQuery(items: criteria.items, table: criteria.table, logger: criteria.logger)
        
        return itemGetDBService.getSummary(query)
            .flatMapErrorThrowing {
                logError(criteria.logger, error: $0)
                throw $0.mapToComicInfoError(itemType: Summary.self)
            }
    }

}
