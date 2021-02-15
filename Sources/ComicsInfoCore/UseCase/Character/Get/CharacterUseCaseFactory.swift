//
//  CharacterUseCaseFactory.swift
//  CharacterInfo
//
//  Created by Aleksandar Dinic on 19/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public struct CharacterUseCaseFactory: GetUseCaseFactory  {

    public let eventLoop: EventLoop
    public let isLocalServer: Bool
    public let cacheProvider: InMemoryCacheProvider<Character>

    public init(
        on eventLoop: EventLoop,
        isLocalServer: Bool,
        cacheProvider: InMemoryCacheProvider<Character>
    ) {
        self.eventLoop = eventLoop
        self.isLocalServer = isLocalServer
        self.cacheProvider = cacheProvider
    }

    public func makeUseCase() -> CharacterUseCase {
        CharacterUseCase(repository: makeCharacterRepository())
    }

    private func makeCharacterRepository() -> GetRepository<Character, InMemoryCacheProvider<Character>> {
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
