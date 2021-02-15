//
//  ItemCreateDBService.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 04/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import class NIO.EventLoopFuture
import Foundation

protocol ItemCreateDBService {
    
    func create<Item: ComicInfoItem>(_ query: CreateItemQuery<Item>) -> EventLoopFuture<Void>

    func createSummaries<Summary: ItemSummary>(_ query: CreateSummariesQuery<Summary>) -> EventLoopFuture<Void>
    
}
