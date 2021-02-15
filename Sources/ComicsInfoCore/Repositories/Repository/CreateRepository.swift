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

    public func create<Item: ComicInfoItem>(with criteria: CreateItemCriteria<Item>) -> EventLoopFuture<Void> {
        dataProvider.create(with: criteria)
    }
    
    public func createSummaries<Summary: ItemSummary>(with criteria: CreateSummariesCriteria<Summary>) -> EventLoopFuture<Void> {
        dataProvider.createSummaries(with: criteria)
    }

}
