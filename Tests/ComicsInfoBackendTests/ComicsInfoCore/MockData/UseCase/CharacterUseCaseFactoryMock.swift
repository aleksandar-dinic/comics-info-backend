//
//  CharacterUseCaseFactoryMock.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 08/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation
import NIO

struct CharacterUseCaseFactoryMock: GetUseCaseFactory {

    let items: [String: Data]
    var eventLoop: EventLoop

    var isLocalServer: Bool
    var cacheProvider: InMemoryCacheProvider<Character>

    init(items: [String: Data] = [:], on eventLoop: EventLoop? = nil) {
        self.items = items
        self.eventLoop = eventLoop ?? MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        isLocalServer = true
        cacheProvider = InMemoryCacheProvider<Character>()
    }

    func makeUseCase() -> CharacterUseCase {
        CharacterUseCase(repository: makeCharacterRepository())
    }

    private func makeCharacterRepository() -> GetRepository<Character, InMemoryCacheProvider<Character>> {
        ComicsInfoCore.GetRepositoryFactory(
            eventLoop: eventLoop,
            itemGetDBWrapper: makeItemGetDBWrapper(),
            cacheProvider: cacheProvider
        ).makeRepository()
    }
    
    private func makeItemGetDBWrapper() -> ItemGetDBWrapper<Character> {
        ItemGetDBWrapper(itemGetDBService: makeItemGetDBService())
    }
    
    func makeItemGetDBService() -> ItemGetDBService {
        DatabaseFectory(isLocalServer: isLocalServer, eventLoop: eventLoop, items: items)
            .makeDatabase()
    }

}
