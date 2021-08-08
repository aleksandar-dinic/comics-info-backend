//
//  DeleteRepository.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 01/04/2021.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public final class DeleteRepository {

    private let dataProvider: DeleteDataProvider

    init(dataProvider: DeleteDataProvider) {
        self.dataProvider = dataProvider
    }

    public func delete<Item: ComicInfoItem>(with criteria: DeleteItemCriteria<Item>) -> EventLoopFuture<Item> {
        dataProvider.delete(with: criteria)
    }
    
    public func deleteSummaries<Summary: ItemSummary>(
        with criteria: DeleteSummariesCriteria<Summary>
    ) -> EventLoopFuture<[Summary]> {
        dataProvider.deleteSummaries(with: criteria)
    }

}
