//
//  ComicCreateUseCaseFactoryMock.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 11/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation
import Logging
import NIO

struct ComicCreateUseCaseFactoryMock: CreateUseCaseFactory {

    var eventLoop: EventLoop
    var logger: Logger

    var isLocalServer: Bool

    init(on eventLoop: EventLoop? = nil, logger: Logger? = nil) {
        self.eventLoop = eventLoop ?? MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        self.logger = logger ?? Logger(label: "ComicCreateUseCaseFactoryMock")
        isLocalServer = true
    }

    func makeUseCase() -> ComicCreateUseCase {
        ComicCreateUseCase(
            repository: makeRepository(),
            characterUseCase: CharacterUseCaseFactoryMock().makeUseCase(),
            seriesUseCase: SeriesUseCaseFactoryMock().makeUseCase()
        )
    }

    private func makeRepository() -> CreateRepository {
        ComicsInfoCore.CreateRepositoryFactory(itemCreateDBService: makeItemCreateDBService())
            .make()
    }
    
    private func makeItemCreateDBService() -> ItemCreateDBService {
        CreateDatabaseProvider(database: makeDatabase())
    }

    private func makeDatabase() -> DatabaseCreate {
        DatabaseFectory(isLocalServer: isLocalServer)
            .makeDatabaseCreate(eventLoop: eventLoop, logger: logger)
    }

}
