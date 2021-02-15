//
//  CharacterUseCaseBuilder.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 28/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

protocol CharacterUseCaseBuilder {
    
    var eventLoop: EventLoop { get }
    
    func buildCharacterUseCase() -> CharacterUseCase
    
}

extension CharacterUseCaseBuilder {
    
    func buildCharacterUseCase() -> CharacterUseCase {
        CharacterUseCaseFactory(
            on: eventLoop,
            isLocalServer: LocalServer.isEnabled,
            cacheProvider: LocalServer.characterInMemoryCache
        ).makeUseCase()
    }
    
}
