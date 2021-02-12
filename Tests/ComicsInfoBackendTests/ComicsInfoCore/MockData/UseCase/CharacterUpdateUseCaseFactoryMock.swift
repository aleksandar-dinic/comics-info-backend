//
//  CharacterUpdateUseCaseFactoryMock.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 11/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation
import Logging
import NIO

struct CharacterUpdateUseCaseFactoryMock: UpdateUseCaseFactory, CreateRepositoryBuilder {

    let items: [String: Data]
    var eventLoop: EventLoop
    var logger: Logger

    var isLocalServer: Bool

    init(items: [String: Data] = [:], on eventLoop: EventLoop? = nil, logger: Logger? = nil) {
        self.items = items
        self.eventLoop = eventLoop ?? MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        self.logger = logger ?? Logger(label: "CharacterUpdateUseCaseFactoryMock")
        isLocalServer = true
    }

    func makeUseCase() -> CharacterUpdateUseCase {
        CharacterUpdateUseCase(
            repository: makeRepository(),
            createRepository: makeCreateRepository(),
            characterUseCase: CharacterUseCaseFactoryMock().makeUseCase(),
            seriesUseCase: SeriesUseCaseFactoryMock().makeUseCase(),
            comicUseCase: ComicUseCaseFactoryMock().makeUseCase()
        )
    }

    private func makeRepository() -> UpdateRepository {
        ComicsInfoCore.UpdateRepositoryFactory(itemUpdateDBService: makeItemUpdateDBService())
            .make()
    }
    
    func makeItemUpdateDBService() -> ItemUpdateDBService {
        UpdateDatabaseProvider(database: makeDatabase())
    }

    private func makeDatabase() -> DatabaseUpdate {
        DatabaseFectory(isLocalServer: isLocalServer)
            .makeDatabaseUpdate(eventLoop: eventLoop, logger: logger, items: items)
    }

}
