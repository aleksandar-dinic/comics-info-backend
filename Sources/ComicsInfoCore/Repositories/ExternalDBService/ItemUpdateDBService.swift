//
//  ItemUpdateDBService.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 04/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import class NIO.EventLoopFuture
import Foundation

protocol ItemUpdateDBService {

    func update<Item: ComicInfoItem>(_ query: UpdateItemQuery<Item>) -> EventLoopFuture<Item>
    
    func updateSummaries<Summary: ItemSummary>(_ query: UpdateSummariesQuery<Summary>) -> EventLoopFuture<[Summary]>

}
