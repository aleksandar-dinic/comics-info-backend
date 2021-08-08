//
//  ItemDeleteDBWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 30/03/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

struct ItemDeleteDBWrapper: LoggerProvider {
    
    let itemDeleteDBService: ItemDeleteDBService
    
    func delete<Item: ComicInfoItem>(with criteria: DeleteItemCriteria<Item>) -> EventLoopFuture<Item> {
        let query = DeleteItemQuery(
            item: criteria.item,
            table: criteria.table,
            logger: criteria.logger
        )
    
        return itemDeleteDBService.delete(query)
            .flatMapErrorThrowing {
                logError(criteria.logger, error: $0)
                throw $0.mapToComicInfoError(itemType: Item.self)
            }
    }

    func deleteSummaries<Summary: ItemSummary>(with criteria: DeleteSummariesCriteria<Summary>) -> EventLoopFuture<[Summary]> {
        let query = DeleteSummariesQuery(
            summaries: criteria.items,
            table: criteria.table,
            logger: criteria.logger
        )

        return itemDeleteDBService.deleteSummaries(query)
            .flatMapErrorThrowing {
                logError(criteria.logger, error: $0)
                throw $0.mapToComicInfoError(itemType: Summary.self)
            }
    }

}
