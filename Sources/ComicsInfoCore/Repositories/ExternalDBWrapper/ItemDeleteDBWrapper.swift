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
    
    func delete<Item: ComicInfoItem>(_ query: DeleteItemQuery<Item>) -> EventLoopFuture<Item> {
        itemDeleteDBService.delete(query)
    }

    func deleteSummaries<Summary: ItemSummary>(_ query: DeleteSummariesQuery<Summary>) -> EventLoopFuture<[Summary]> {
        itemDeleteDBService.deleteSummaries(query)
    }

}
