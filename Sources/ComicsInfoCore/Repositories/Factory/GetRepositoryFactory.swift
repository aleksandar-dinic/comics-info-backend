//
//  GetRepositoryFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 24/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public struct GetRepositoryFactory<Item, CacheProvider: Cacheable>: GetDataProviderFactory where CacheProvider.Item == Item {

    let eventLoop: EventLoop
    let itemGetDBWrapper: ItemGetDBWrapper<Item>
    let cacheProvider: CacheProvider

    public func makeRepository() -> GetRepository<Item, CacheProvider> {
        GetRepository(dataProvider: makeDataProvider())
    }

}
