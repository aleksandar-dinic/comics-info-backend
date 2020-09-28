//
//  SeriesUseCaseFactory.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import ComicsInfoCore
import Foundation
import NIO

struct SeriesUseCaseFactory<CacheProvider: Cacheable> where CacheProvider.Item == Series {

    let eventLoop: EventLoop
    let isLocalServer: Bool
    var cacheProvider: CacheProvider

    init(
        on eventLoop: EventLoop,
        isLocalServer: Bool,
        cacheProvider: CacheProvider
    ) {
        self.eventLoop = eventLoop
        self.isLocalServer = isLocalServer
        self.cacheProvider = cacheProvider
    }

    func makeUseCase() -> SeriesUseCase<SeriesRepositoryAPIWrapper, CacheProvider> {
        SeriesUseCase(seriesRepository: makeSeriesRepository())
    }

    private func makeSeriesRepository() -> Repository<SeriesRepositoryAPIWrapper, CacheProvider> {
        RepositoryFactory(
            repositoryAPIWrapper: makeRepositoryAPIWrapper(),
            cacheProvider: cacheProvider
        ).makeRepository()
    }

    private func makeRepositoryAPIWrapper() -> SeriesRepositoryAPIWrapper {
        SeriesRepositoryAPIWrapper(repositoryAPIService: makeRepositoryAPIService())
    }

    private func makeRepositoryAPIService() -> RepositoryAPIService {
        DatabaseProvider(database: makeDatabase(), tableName: .seriesTableName)
    }

    private func makeDatabase() -> Database {
        DatabaseFectory(isLocalServer: isLocalServer)
            .makeDatabase(eventLoop: eventLoop)
    }

}
