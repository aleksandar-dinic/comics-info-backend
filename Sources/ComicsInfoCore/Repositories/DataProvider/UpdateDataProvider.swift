//
//  UpdateDataProvider.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 07/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

struct UpdateDataProvider {

    let itemUpdateDBWrapper: ItemUpdateDBWrapper

    func update<Item: ComicInfoItem>(_ item: Item, in table: String) -> EventLoopFuture<Set<String>> {
        itemUpdateDBWrapper.update(item, in: table)
    }
    
    func updateSummaries<Summary: ItemSummary>(
        _ summaries: [Summary],
        in table: String,
        strategy: UpdateSummariesStrategy
    ) -> EventLoopFuture<Void> {
        itemUpdateDBWrapper.updateSummaries(summaries, in: table, strategy: strategy)
    }

}
