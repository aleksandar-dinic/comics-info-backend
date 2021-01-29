//
//  UpdateRepositoryAPIService.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 07/01/2021.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public protocol UpdateRepositoryAPIService {

    func update<Item: ComicInfoItem>(_ item: Item, in table: String) -> EventLoopFuture<Set<String>>
    func updateSummaries<Summary: ItemSummary>(_ summaries: [Summary], in table: String) -> EventLoopFuture<Void>
    
}
