//
//  ItemCreateDBWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 08/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

struct ItemCreateDBWrapper {
    
    let itemCreateDBService: ItemCreateDBService
    
    func create<Item: ComicInfoItem>(_ item: Item, in table: String) -> EventLoopFuture<Void> {
        itemCreateDBService.create(item, in: table)
            .flatMapErrorThrowing { throw $0.mapToComicInfoError(itemType: Item.self) }
    }
    
    func createSummaries<Summary: ItemSummary>(_ summaries: [Summary], in table: String) -> EventLoopFuture<Void> {
        itemCreateDBService.createSummaries(summaries, in: table)
            .flatMapErrorThrowing { throw $0.mapToComicInfoError(itemType: Summary.self) }
    }

}
