//
//  ItemUpdateDBWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 07/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

struct ItemUpdateDBWrapper {
    
    let itemUpdateDBService: ItemUpdateDBService

    func update<Item: ComicInfoItem>(_ item: Item, in table: String) -> EventLoopFuture<Set<String>> {
        itemUpdateDBService.update(item, in: table)
            .flatMapErrorThrowing { throw $0.mapToComicInfoError(itemType: Item.self) }
    }
    
    func updateSummaries<Summary: ItemSummary>(
        _ summaries: [Summary],
        in table: String,
        strategy: UpdateSummariesStrategy
    ) -> EventLoopFuture<Void> {
        var criteria = [UpdateSummariesCriteria<Summary>]()
        
        for summary in summaries {
            criteria.append(UpdateSummariesCriteria(table: table, item: summary, strategy: strategy))
        }
        
        return itemUpdateDBService.updateSummaries(with: criteria)
            .flatMapErrorThrowing { throw $0.mapToComicInfoError(itemType: Summary.self) }
    }

}
