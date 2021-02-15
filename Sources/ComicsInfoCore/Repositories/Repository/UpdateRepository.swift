//
//  UpdateRepository.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 07/01/2021.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public final class UpdateRepository {

    private let dataProvider: UpdateDataProvider

    init(dataProvider: UpdateDataProvider) {
        self.dataProvider = dataProvider
    }

    public func update<Item: ComicInfoItem>(with criteria: UpdateItemCriteria<Item>) -> EventLoopFuture<Set<String>> {
        dataProvider.update(with: criteria)
    }
    
    public func updateSummaries<Summary: ItemSummary>(
        with criteria: UpdateSummariesCriteria<Summary>
    ) -> EventLoopFuture<Void> {
        dataProvider.updateSummaries(with: criteria)
    }

}
