//
//  ItemCreateDBService.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 04/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

protocol ItemCreateDBService {
    
    func create<Item: ComicInfoItem>(_ item: Item, in table: String) -> EventLoopFuture<Void>
    
    func createSummaries<Summary: ItemSummary>(_ summaries: [Summary], in table: String) -> EventLoopFuture<Void>
    
}
