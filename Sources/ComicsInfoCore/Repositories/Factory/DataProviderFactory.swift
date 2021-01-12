//
//  DataProviderFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 24/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

protocol DataProviderFactory where APIWrapper.Item == CacheProvider.Item {

    associatedtype APIWrapper: RepositoryAPIWrapper
    associatedtype CacheProvider: Cacheable

    var eventLoop: EventLoop { get }
    var repositoryAPIWrapper: APIWrapper { get }
    var cacheProvider: CacheProvider  { get }

    func makeDataProvider() -> DataProvider<APIWrapper, CacheProvider>

}

extension DataProviderFactory {

    public func makeDataProvider() -> DataProvider<APIWrapper, CacheProvider> {
        DataProvider(
            eventLoop: eventLoop,
            repositoryAPIWrapper: repositoryAPIWrapper,
            cacheProvider: cacheProvider
        )
    }

}
