//
//  ComicUseCaseFactoryMock.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 17/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation
import Logging
import NIO

struct ComicUseCaseFactoryMock: GetUseCaseFactory {

    private let items: [String: Data]
    var eventLoop: EventLoop
    var logger: Logger

    var isLocalServer: Bool
    var cacheProvider: InMemoryCacheProvider<Comic>

    init(items: [String: Data] = [:], on eventLoop: EventLoop? = nil, logger: Logger? = nil) {
        self.items = items
        self.eventLoop = eventLoop ?? MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        self.logger = logger ?? Logger(label: "ComicUseCaseFactoryMock")
        isLocalServer = true
        cacheProvider = InMemoryCacheProvider<Comic>()
    }

    func makeUseCase() -> ComicUseCase<GetDatabaseProvider, InMemoryCacheProvider<Comic>> {
        ComicUseCase(repository: makecomicRepository())
    }

    private func makecomicRepository() -> GetRepository<Comic, InMemoryCacheProvider<Comic>> {
        ComicsInfoCore.GetRepositoryFactory(
            eventLoop: eventLoop,
            itemGetDBWrapper: makeItemGetDBWrapper(),
            cacheProvider: cacheProvider
        ).makeRepository()
    }

    private func makeItemGetDBWrapper() -> ItemGetDBWrapper<Comic> {
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
