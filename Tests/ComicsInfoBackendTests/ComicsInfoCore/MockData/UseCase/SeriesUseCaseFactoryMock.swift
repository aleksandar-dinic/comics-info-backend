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

struct SeriesUseCaseFactoryMock: GetUseCaseFactory {

    private let items: [String: Data]
    let eventLoop: EventLoop
    let logger: Logger

    let isLocalServer: Bool
    let cacheProvider: InMemoryCacheProvider<Series>

    init(items: [String: Data] = [:], on eventLoop: EventLoop? = nil, logger: Logger? = nil) {
        self.items = items
        self.eventLoop = eventLoop ?? MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        self.logger = logger ?? Logger(label: "SeriesUseCaseFactoryMock")
        isLocalServer = true
        cacheProvider = InMemoryCacheProvider<Series>()
    }

    func makeUseCase() -> SeriesUseCase<GetDatabaseProvider, InMemoryCacheProvider<Series>> {
        SeriesUseCase(repository: makeRepository())
    }
    
    private func makeRepository() -> GetRepository<Series, InMemoryCacheProvider<Series>> {
        ComicsInfoCore.GetRepositoryFactory(
            eventLoop: eventLoop,
            itemGetDBWrapper: makeItemGetDBWrapper(),
            cacheProvider: cacheProvider
        ).makeRepository()
    }

    private func makeItemGetDBWrapper() -> ItemGetDBWrapper<Series> {
        ItemGetDBWrapper(itemGetDBService: makeItemGetDBService())
    }
    
    func makeItemGetDBService() -> ItemGetDBService {
        GetDatabaseProvider(database: makeDatabase())
    }

    private func makeDatabase() -> DatabaseGet {
        DatabaseFectory(isLocalServer: isLocalServer)
            .makeDatabase(eventLoop: eventLoop, logger: logger, items: items)
    }


}
