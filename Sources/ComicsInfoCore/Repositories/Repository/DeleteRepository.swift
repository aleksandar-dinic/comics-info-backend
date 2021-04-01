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

    public func delete<Item: ComicInfoItem>(_ query: DeleteItemQuery<Item>) -> EventLoopFuture<Item> {
        dataProvider.delete(query)
    }
    
    public func deleteSummaries<Summary: ItemSummary>(
        _ query: DeleteSummariesQuery<Summary>
    ) -> EventLoopFuture<[Summary]> {
        dataProvider.deleteSummaries(query)
    }

}
