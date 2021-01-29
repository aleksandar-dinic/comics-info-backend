//
//  UpdateAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 07/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

protocol UpdateAPIWrapper {

    associatedtype Item: SummaryMapper

    var repositoryAPIService: UpdateRepositoryAPIService { get }

    func update(_ item: Item, in table: String) -> EventLoopFuture<Set<String>>
    func updateSummaries<Summary: ItemSummary>(_ summaries: [Summary], in table: String) -> EventLoopFuture<Void>
    
}

extension UpdateAPIWrapper {
    
    func update(_ item: Item, in table: String) -> EventLoopFuture<Set<String>> {
        repositoryAPIService.update(item, in: table)
    }

    func updateSummaries<Summary: ItemSummary>(_ summaries: [Summary], in table: String) -> EventLoopFuture<Void> {
        repositoryAPIService.updateSummaries(summaries, in: table)
    }
    
}
