//
//  ItemGetDBWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 24/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

struct ItemGetDBWrapper<Item: ComicInfoItem> {

    let itemGetDBService: ItemGetDBService

    func getItem(withID ID: String, from table: String) -> EventLoopFuture<Item> {
        itemGetDBService.getItem(withID: .comicInfoID(for: Item.self, ID: ID), from: table)
            .flatMapErrorThrowing { throw $0.mapToComicInfoError(itemType: Item.self) }
    }
    
    func getItems(withIDs IDs: Set<String>, from table: String) -> EventLoopFuture<[Item]> {
        itemGetDBService.getItems(withIDs: Set(IDs.map { .comicInfoID(for: Item.self, ID: $0) }), from: table)
            .flatMapErrorThrowing { throw $0.mapToComicInfoError(itemType: Item.self) }
    }
    
    func getAllItems(from table: String) -> EventLoopFuture<[Item]> {
        itemGetDBService.getAll(.getType(from: Item.self), from: table)
            .flatMapErrorThrowing { throw $0.mapToComicInfoError(itemType: Item.self) }
    }
    
    func getSummaries<Summary: ItemSummary>(
        with criteria: GetSummariesCriteria<Summary>
    ) -> EventLoopFuture<[Summary]?> {
        itemGetDBService.getSummaries(with: criteria)
            .flatMapErrorThrowing { throw $0.mapToComicInfoError(itemType: Summary.self) }
    }
    
    func getSummary<Summary: ItemSummary>(
        with criteria: [GetSummaryCriteria<Summary>]
    ) -> EventLoopFuture<[Summary]?> {
        itemGetDBService.getSummary(with: criteria)
            .flatMapErrorThrowing { throw $0.mapToComicInfoError(itemType: Summary.self) }
    }

}
