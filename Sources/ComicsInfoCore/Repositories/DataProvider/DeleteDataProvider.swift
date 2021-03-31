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

    func delete<Item: ComicInfoItem>() -> EventLoopFuture<Item> {
        itemDeleteDBWrapper.delete()
    }
    
    func deleteSummaries<Summary: ItemSummary>() -> EventLoopFuture<[Summary]> {
        itemDeleteDBWrapper.deleteSummaries()
    }

}
