//
//  ComicUseCaseFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 05/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public struct ComicUseCaseFactory: GetUseCaseFactory  {

    public let eventLoop: EventLoop
    public let isLocalServer: Bool
    public let cacheProvider: InMemoryCacheProvider<Comic>

    public init(
        on eventLoop: EventLoop,
        isLocalServer: Bool,
        cacheProvider: InMemoryCacheProvider<Comic>
    ) {
        self.eventLoop = eventLoop
        self.isLocalServer = isLocalServer
        self.cacheProvider = cacheProvider
    }

    public func makeUseCase() -> ComicUseCase{
        ComicUseCase(repository: makecomicRepository())
    }

    private func makecomicRepository() -> GetRepository<Comic, InMemoryCacheProvider<Comic>> {
        GetRepositoryFactory(
            eventLoop: eventLoop,
            itemGetDBWrapper: makeItemGetDBWrapper(),
            cacheProvider: cacheProvider
        ).makeRepository()
    }

    private func makeItemGetDBWrapper() -> ItemGetDBWrapper<Comic> {
        ItemGetDBWrapper(itemGetDBService: makeItemGetDBService())
    }

}
