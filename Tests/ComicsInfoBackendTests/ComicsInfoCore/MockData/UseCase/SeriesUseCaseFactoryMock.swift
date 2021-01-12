//
//  SeriesUseCaseFactoryMock.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 17/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation
import Logging
import NIO

struct SeriesUseCaseFactoryMock: UseCaseFactory {

    let eventLoop: EventLoop
    let logger: Logger

    let isLocalServer: Bool
    let cacheProvider: InMemoryCacheProvider<Series>

    init(on eventLoop: EventLoop? = nil, logger: Logger? = nil) {
        self.eventLoop = eventLoop ?? MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        self.logger = logger ?? Logger(label: "SeriesUseCaseFactoryMock")
        isLocalServer = true
        cacheProvider = InMemoryCacheProvider<Series>()
    }

    func makeUseCase() -> SeriesUseCase<SeriesRepositoryAPIWrapper, InMemoryCacheProvider<Series>> {
        SeriesUseCase(repository: makeSeriesRepository())
    }

    private func makeSeriesRepository() -> Repository<SeriesRepositoryAPIWrapper, CacheProvider> {
        RepositoryFactory(
            on: eventLoop,
            repositoryAPIWrapper: makeRepositoryAPIWrapper(),
            cacheProvider: cacheProvider
        ).makeRepository()
    }

    private func makeRepositoryAPIWrapper() -> SeriesRepositoryAPIWrapper {
        SeriesRepositoryAPIWrapper(
            repositoryAPIService: makeRepositoryAPIService()
        )
    }

}
