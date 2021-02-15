//
//  UpdateDataProvider.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 07/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

struct UpdateDataProvider {

    let itemUpdateDBWrapper: ItemUpdateDBWrapper

    func update<Item: ComicInfoItem>(with criteria: UpdateItemCriteria<Item>) -> EventLoopFuture<Set<String>> {
        itemUpdateDBWrapper.update(with: criteria)
    }
    
    func updateSummaries<Summary: ItemSummary>(
        with criteria: UpdateSummariesCriteria<Summary>
    ) -> EventLoopFuture<Void> {
        itemUpdateDBWrapper.updateSummaries(with: criteria)
    }

}
