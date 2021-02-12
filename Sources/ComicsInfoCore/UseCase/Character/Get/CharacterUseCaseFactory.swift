//
//  CharacterUseCaseFactory.swift
//  CharacterInfo
//
//  Created by Aleksandar Dinic on 19/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Logging
import Foundation
import NIO

public struct CharacterUseCaseFactory<CacheProvider: Cacheable>: GetUseCaseFactory where CacheProvider.Item == Character  {

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

    public func makeUseCase() -> CharacterUseCase<GetDatabaseProvider, CacheProvider> {
        CharacterUseCase(repository: makeCharacterRepository())
    }

    private func makeCharacterRepository() -> GetRepository<Character, CacheProvider> {
        GetRepositoryFactory(
            eventLoop: eventLoop,
            itemGetDBWrapper: makeItemGetDBWrapper(),
            cacheProvider: cacheProvider
        ).makeRepository()
    }

    private func makeItemGetDBWrapper() -> ItemGetDBWrapper<Character> {
        ItemGetDBWrapper(itemGetDBService: makeItemGetDBService())
    }
    
}
