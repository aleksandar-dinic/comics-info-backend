//
//  CharacterUseCaseFactoryMock.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 08/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation
import Logging
import NIO

struct CharacterUseCaseFactoryMock {

    private var eventLoop: EventLoop!
    private var logger: Logger!

    var useCase: CharacterUseCase<CharacterRepositoryAPIWrapper, InMemoryCacheProvider<Character>> {
        CharacterUseCaseFactory(
            on: eventLoop,
            isLocalServer: true,
            cacheProvider: InMemoryCacheProvider<Character>(),
            logger: logger
        ).makeUseCase()
    }

}
