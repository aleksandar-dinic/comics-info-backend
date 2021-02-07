//
//  SeriesUseCaseFactory.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Logging
import Foundation
import NIO

public struct SeriesUseCaseFactory<CacheProvider: Cacheable>: GetUseCaseFactory where CacheProvider.Item == Series {

    public let eventLoop: EventLoop
    public let isLocalServer: Bool
    public let cacheProvider: CacheProvider
    public let logger: Logger

    public init(
        on eventLoop: EventLoop,
        isLocalServer: Bool,
        cacheProvider: CacheProvider,
        logger: Logger
    ) {
        self.eventLoop = eventLoop
        self.isLocalServer = isLocalServer
        self.cacheProvider = cacheProvider
        self.logger = logger
    }

    public func makeUseCase() -> SeriesUseCase<GetDatabaseProvider, CacheProvider> {
        SeriesUseCase(repository: makeSeriesRepository())
    }

    private func makeSeriesRepository() -> GetRepository<Series, CacheProvider> {
        GetRepositoryFactory(
            eventLoop: eventLoop,
            itemGetDBWrapper: makeItemGetDBWrapper(),
            cacheProvider: cacheProvider
        ).makeRepository()
    }

    private func makeItemGetDBWrapper() -> ItemGetDBWrapper<Series> {
        ItemGetDBWrapper(itemGetDBService: makeItemGetDBService())
    }

}
