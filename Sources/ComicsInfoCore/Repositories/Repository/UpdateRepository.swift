//
//  UpdateRepository.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 07/01/2021.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public final class UpdateRepository<APIWrapper: UpdateRepositoryAPIWrapper> {

    private let dataProvider: UpdateDataProvider<APIWrapper>

    init(dataProvider: UpdateDataProvider<APIWrapper>) {
        self.dataProvider = dataProvider
    }

    public func update(_ item: APIWrapper.Item, in table: String) -> EventLoopFuture<Set<String>> {
        dataProvider.update(item, in: table)
    }
    
    public func updateSummaries<Summary: ItemSummary>(_ summaries: [Summary], in table: String) -> EventLoopFuture<Void> {
        dataProvider.updateSummaries(summaries, in: table)
    }

}
