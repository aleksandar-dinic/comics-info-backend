//
//  CreateRepository.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 08/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public final class CreateRepository {

    private let dataProvider: CreateDataProvider

    init(dataProvider: CreateDataProvider) {
        self.dataProvider = dataProvider
    }

    public func create<Item: ComicInfoItem>(_ item: Item, in table: String) -> EventLoopFuture<Void> {
        dataProvider.create(item, in: table)
    }
    
    public func createSummaries<Summary: ItemSummary>(_ summaries: [Summary], in table: String) -> EventLoopFuture<Void> {
        dataProvider.createSummaries(summaries, in: table)
    }

}
