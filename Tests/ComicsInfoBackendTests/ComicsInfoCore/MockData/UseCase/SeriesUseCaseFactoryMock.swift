//
//  SeriesUseCaseFactoryMock.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 17/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation
import NIO

struct SeriesUseCaseFactoryMock: GetUseCaseFactory {

    private let items: [String: Data]
    let eventLoop: EventLoop

    let isLocalServer: Bool
    let cacheProvider: InMemoryCacheProvider<Series>

    init(items: [String: Data] = [:], on eventLoop: EventLoop? = nil) {
        self.items = items
        self.eventLoop = eventLoop ?? MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        isLocalServer = true
        cacheProvider = InMemoryCacheProvider<Series>()
    }

    func makeUseCase() -> SeriesUseCase {
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
        DatabaseFectory(isLocalServer: isLocalServer, eventLoop: eventLoop, items: items)
            .makeDatabase()
    }

}
