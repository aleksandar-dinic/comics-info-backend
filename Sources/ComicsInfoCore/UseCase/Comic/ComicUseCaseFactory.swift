//
//  ComicUseCaseFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 05/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Logging
import Foundation
import NIO

public struct ComicUseCaseFactory<CacheProvider: Cacheable> where CacheProvider.Item == Comic  {

    private let eventLoop: EventLoop
    private let isLocalServer: Bool
    private let cacheProvider: CacheProvider
    private let logger: Logger

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

    public func makeUseCase() -> ComicUseCase<ComicRepositoryAPIWrapper, CacheProvider> {
        ComicUseCase(repository: makecomicRepository())
    }

    private func makecomicRepository() -> Repository<ComicRepositoryAPIWrapper, CacheProvider> {
        RepositoryFactory(
            on: eventLoop,
            repositoryAPIWrapper: makeRepositoryAPIWrapper(),
            cacheProvider: cacheProvider
        ).makeRepository()
    }

    private func makeRepositoryAPIWrapper() -> ComicRepositoryAPIWrapper {
        ComicRepositoryAPIWrapper(
            on: eventLoop,
            repositoryAPIService: makeRepositoryAPIService(),
            logger: logger
        )
    }

    private func makeRepositoryAPIService() -> RepositoryAPIService {
        DatabaseProvider(database: makeDatabase())
    }

    private func makeDatabase() -> Database {
        DatabaseFectory(isLocalServer: isLocalServer, tableName: .comicTableName)
            .makeDatabase(eventLoop: eventLoop, logger: logger)
    }

}
