//
//  ItemUpdateDBWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 07/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

struct ItemUpdateDBWrapper: LoggerProvider {
    
    let itemUpdateDBService: ItemUpdateDBService

    func update<Item: ComicInfoItem>(with criteria: UpdateItemCriteria<Item>) -> EventLoopFuture<Set<String>> {
        let query = UpdateItemQuery(item: criteria.item, table: criteria.table, logger: criteria.logger)
        
        return itemUpdateDBService.update(query)
            .flatMapErrorThrowing {
                logError(criteria.logger, error: $0)
                throw $0.mapToComicInfoError(itemType: Item.self)
            }
    }
    
    func updateSummaries<Summary: ItemSummary>(
        with criteria: UpdateSummariesCriteria<Summary>
    ) -> EventLoopFuture<Void> {
        let query = UpdateSummariesQuery(
            summaries: criteria.items,
            table: criteria.table,
            logger: criteria.logger
        )
        
        return itemUpdateDBService.updateSummaries(query)
            .flatMapErrorThrowing {
                logError(criteria.logger, error: $0)
                throw $0.mapToComicInfoError(itemType: Summary.self)
            }
    }

}
