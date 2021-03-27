//
//  CreateDataProvider.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 08/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

struct CreateDataProvider {

    let itemCreateDBWrapper: ItemCreateDBWrapper

    func create<Item: ComicInfoItem>(with criteria: CreateItemCriteria<Item>) -> EventLoopFuture<Item> {
        itemCreateDBWrapper.create(with: criteria)
    }
    
    func createSummaries<Summary: ItemSummary>(
        with criteria: CreateSummariesCriteria<Summary>
    ) -> EventLoopFuture<[Summary]> {
        itemCreateDBWrapper.createSummaries(with: criteria)
    }

}
