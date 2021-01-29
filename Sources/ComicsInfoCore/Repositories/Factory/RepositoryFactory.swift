//
//  RepositoryFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 24/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public struct RepositoryFactory<APIWrapper: RepositoryAPIWrapper, CacheProvider: Cacheable>: DataProviderFactory where APIWrapper.Item == CacheProvider.Item {

    public let eventLoop: EventLoop
    public let repositoryAPIWrapper: APIWrapper
    public let cacheProvider: CacheProvider

    public func makeRepository() -> Repository<APIWrapper, CacheProvider> {
        Repository(dataProvider: makeDataProvider())
    }

}
