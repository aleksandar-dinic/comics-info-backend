//
//  ItemGetDBService.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 04/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public protocol ItemGetDBService {
    
    func getItem<Item: ComicInfoItem>(withID ID: String, from table: String) -> EventLoopFuture<Item>
    func getItems<Item: ComicInfoItem>(withIDs IDs: Set<String>, from table: String) -> EventLoopFuture<[Item]>
    func getAll<Item: ComicInfoItem>(_ items: String, from table: String) -> EventLoopFuture<[Item]>

    func getSummaries<Summary: ItemSummary>(
        with criteria: GetSummariesCriteria<Summary>
    ) -> EventLoopFuture<[Summary]?>
    
    func getSummary<Summary: ItemSummary>(
        with criteria: [GetSummaryCriteria<Summary>]
    ) -> EventLoopFuture<[Summary]?>
    
}
