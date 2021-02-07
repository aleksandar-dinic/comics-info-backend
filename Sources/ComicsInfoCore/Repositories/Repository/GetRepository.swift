//
//  GetRepository.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 24/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public final class GetRepository<Item, CacheProvider: Cacheable> where CacheProvider.Item == Item {

    private let dataProvider: GetDataProvider<Item, CacheProvider>

    init(dataProvider: GetDataProvider<Item, CacheProvider>) {
        self.dataProvider = dataProvider
    }

    public func getItem(with criteria: GetItemCriteria) -> EventLoopFuture<Item> {
        dataProvider.getItem(with: criteria)
    }
    
    public func getItems(with criteria: GetItemsCriteria) -> EventLoopFuture<[Item]> {
        dataProvider.getItems(with: criteria)
    }

    public func getAllItems(with criteria: GetAllItemsCriteria) -> EventLoopFuture<[Item]> {
        dataProvider.getAllItems(with: criteria)
    }
    
    public func getSummaries<Summary: ItemSummary>(with criteria: GetSummariesCriteria) -> EventLoopFuture<[Summary]?> {
        dataProvider.getSummaries(with: criteria)
    }

}
