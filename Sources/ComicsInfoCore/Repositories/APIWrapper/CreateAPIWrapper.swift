//
//  CreateAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 03/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

protocol CreateAPIWrapper {

    associatedtype Item: SummaryMapper

    var repositoryAPIService: CreateRepositoryAPIService { get }
    
    func create(_ item: Item, in table: String) -> EventLoopFuture<Void>
    
    func createSummaries<Summary: ItemSummary>(_ summaries: [Summary], in table: String) -> EventLoopFuture<Void>

}

extension CreateAPIWrapper {
    
    func create(_ item: Item, in table: String) -> EventLoopFuture<Void> {
        repositoryAPIService.create(item, in: table)
            .flatMapErrorThrowing { throw $0.mapToAPIError(itemType: Item.self) }
    }
    
    func createSummaries<Summary: ItemSummary>(_ summaries: [Summary], in table: String) -> EventLoopFuture<Void> {
        repositoryAPIService.createSummaries(summaries, in: table)
    }

}
