//
//  CharacterUseCaseBuilder.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 28/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Logging
import Foundation
import NIO

protocol CharacterUseCaseBuilder {
    
    var eventLoop: EventLoop { get }
    var isLocalServer: Bool { get }
    var logger: Logger { get }
    
    func buildCharacterUseCase() -> CharacterUseCase<CharacterRepositoryAPIWrapper, InMemoryCacheProvider<Character>>
    
}

extension CharacterUseCaseBuilder {
    
    func buildCharacterUseCase() -> CharacterUseCase<CharacterRepositoryAPIWrapper, InMemoryCacheProvider<Character>> {
        CharacterUseCaseFactory(
            on: eventLoop,
            isLocalServer: LocalServer.isEnabled,
            cacheProvider: LocalServer.characterInMemoryCache,
            logger: logger
        ).makeUseCase()
    }
    
}
