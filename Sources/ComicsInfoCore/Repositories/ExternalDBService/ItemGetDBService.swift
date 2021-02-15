//
//  ItemGetDBService.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 04/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import class NIO.EventLoopFuture
import Foundation

protocol ItemGetDBService {
    
    func getItem<Item: ComicInfoItem>(_ query: GetItemQuery) -> EventLoopFuture<Item>
    func getItems<Item: ComicInfoItem>(_ query: GetItemsQuery) -> EventLoopFuture<[Item]>
    func getAll<Item: ComicInfoItem>(_ query: GetAllItemsQuery) -> EventLoopFuture<[Item]>

    func getSummaries<Summary: ItemSummary>(_ query: GetSummariesQuery) -> EventLoopFuture<[Summary]?>
    func getSummary<Summary: ItemSummary>(_ query: GetSummaryQuery) -> EventLoopFuture<[Summary]?>
    
}
