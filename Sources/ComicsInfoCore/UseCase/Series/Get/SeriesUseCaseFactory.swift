//
//  SeriesUseCaseFactory.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public struct SeriesUseCaseFactory: GetUseCaseFactory {

    public let eventLoop: EventLoop
    public let isLocalServer: Bool
    public let cacheProvider: InMemoryCacheProvider<Series>

    public init(
        on eventLoop: EventLoop,
        isLocalServer: Bool,
        cacheProvider: InMemoryCacheProvider<Series>
    ) {
        self.eventLoop = eventLoop
        self.isLocalServer = isLocalServer
        self.cacheProvider = cacheProvider
    }

    public func makeUseCase() -> SeriesUseCase {
        SeriesUseCase(repository: makeSeriesRepository())
    }

    private func makeSeriesRepository() -> GetRepository<Series, InMemoryCacheProvider<Series>> {
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
