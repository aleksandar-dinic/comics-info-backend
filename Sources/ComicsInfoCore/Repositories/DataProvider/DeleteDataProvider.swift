//
//  DeleteDataProvider.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 31/03/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

struct DeleteDataProvider {

    let itemDeleteDBWrapper: ItemDeleteDBWrapper

    func delete<Item: ComicInfoItem>(with criteria: DeleteItemCriteria<Item>) -> EventLoopFuture<Item> {
        itemDeleteDBWrapper.delete(with: criteria)
    }
    
    func deleteSummaries<Summary: ItemSummary>(
        with criteria: DeleteSummariesCriteria<Summary>
    ) -> EventLoopFuture<[Summary]> {
        itemDeleteDBWrapper.deleteSummaries(with: criteria)
    }

}
