//
//  CreateDataProvider.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 08/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

struct CreateDataProvider {

    let itemCreateDBWrapper: ItemCreateDBWrapper

    func create<Item: ComicInfoItem>(_ item: Item, in table: String) -> EventLoopFuture<Void> {
        itemCreateDBWrapper.create(item, in: table)
    }
    
    func createSummaries<Summary: ItemSummary>(_ summaries: [Summary], in table: String) -> EventLoopFuture<Void> {
        itemCreateDBWrapper.createSummaries(summaries, in: table)
    }

}
