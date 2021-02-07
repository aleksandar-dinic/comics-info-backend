//
//  GetDataProviderFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 24/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

protocol GetDataProviderFactory {

    associatedtype Item = ComicInfoItem
    associatedtype CacheProvider: Cacheable where CacheProvider.Item == Item

    var eventLoop: EventLoop { get }
    var itemGetDBWrapper: ItemGetDBWrapper<Item> { get }
    var cacheProvider: CacheProvider  { get }

    func makeDataProvider() -> GetDataProvider<Item, CacheProvider>

}

extension GetDataProviderFactory {

    public func makeDataProvider() -> GetDataProvider<Item, CacheProvider> {
        GetDataProvider(
            eventLoop: eventLoop,
            itemGetDBWrapper: itemGetDBWrapper,
            cacheProvider: cacheProvider
        )
    }

}
