//
//  CharacterDeleteUseCaseFactoryMock.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 21/05/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation
import NIO

struct CharacterDeleteUseCaseFactoryMock: DeleteUseCaseFactory {

    let items: [String: Data]
    var eventLoop: EventLoop

    var isLocalServer: Bool

    init(items: [String: Data] = [:], on eventLoop: EventLoop? = nil) {
        self.items = items
        self.eventLoop = eventLoop ?? MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        isLocalServer = true
    }

    func makeUseCase() -> CharacterDeleteUseCase {
        CharacterDeleteUseCase(
            deleteRepository: makeDeleteRepository(),
            characterUseCase: CharacterUseCaseFactoryMock().makeUseCase()
        )
    }
    
    func makeDeleteRepository() -> DeleteRepository {
        ComicsInfoCore.DeleteRepositoryFactory(itemDeleteDBService: makeItemDeleteDBService())
            .make()
    }
    
    func makeItemDeleteDBService() -> ItemDeleteDBService {
        DatabaseFectory(isLocalServer: isLocalServer, eventLoop: eventLoop, items: items)
            .makeDatabase()
    }

}
