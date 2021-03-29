//
//  ItemDeleteDBService.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 29/03/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import class NIO.EventLoopFuture
import Foundation

protocol ItemDeleteDBService {

    func delete<Item: ComicInfoItem>(_ query: DeleteItemQuery<Item>) -> EventLoopFuture<Item>
    
    func deleteSummaries<Summary: ItemSummary>(_ query: DeleteSummariesQuery<Summary>) -> EventLoopFuture<[Summary]>

}
