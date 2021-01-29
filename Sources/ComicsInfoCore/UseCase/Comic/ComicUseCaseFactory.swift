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

public struct ComicUseCaseFactory<CacheProvider: Cacheable>: UseCaseFactory where CacheProvider.Item == Comic  {

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

    public func makeUseCase() -> ComicUseCase<ComicRepositoryAPIWrapper, CacheProvider> {
        ComicUseCase(repository: makecomicRepository())
    }

    private func makecomicRepository() -> Repository<ComicRepositoryAPIWrapper, CacheProvider> {
        RepositoryFactory(
            eventLoop: eventLoop,
            repositoryAPIWrapper: makeRepositoryAPIWrapper(),
            cacheProvider: cacheProvider
        ).makeRepository()
    }

    private func makeRepositoryAPIWrapper() -> ComicRepositoryAPIWrapper {
        ComicRepositoryAPIWrapper(repositoryAPIService: makeRepositoryAPIService())
    }

}
