//
//  CreateDataProvider.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 08/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

struct CreateDataProvider<APIWrapper: CreateRepositoryAPIWrapper> {

    let repositoryAPIWrapper: APIWrapper

    func create(_ item: APIWrapper.Item, in table: String) -> EventLoopFuture<Void> {
        repositoryAPIWrapper.create(item, in: table)
    }
    
    func createSummaries<Summary: ItemSummary>(_ summaries: [Summary], in table: String) -> EventLoopFuture<Void> {
        repositoryAPIWrapper.createSummaries(summaries, in: table)
    }

}
