//
//  ItemCreateDBWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 08/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

struct ItemCreateDBWrapper: LoggerProvider {
    
    var itemCreateDBService: ItemCreateDBService
    
    func create<Item: ComicInfoItem>(with criteria: CreateItemCriteria<Item>) -> EventLoopFuture<Void> {
        let query = CreateItemQuery(item: criteria.item, table: criteria.table, logger: criteria.logger)
        
        return itemCreateDBService.create(query)
            .flatMapErrorThrowing {
                logError(criteria.logger, error: $0)
                throw $0.mapToComicInfoError(itemType: Item.self)
            }
    }
    
    func createSummaries<Summary: ItemSummary>(
        with criteria: CreateSummariesCriteria<Summary>
    ) -> EventLoopFuture<Void> {
        let query = CreateSummariesQuery(summaries: criteria.summaries, table: criteria.table, logger: criteria.logger)
        
        return itemCreateDBService.createSummaries(query)
            .flatMapErrorThrowing {
                logError(criteria.logger, error: $0)
                throw $0.mapToComicInfoError(itemType: Summary.self)
            }
    }

}
