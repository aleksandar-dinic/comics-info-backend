//
//  SeriesCreateUseCaseFactoryMock.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 11/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation
import Logging
import NIO

struct SeriesCreateUseCaseFactoryMock: CreateUseCaseFactory {

    let eventLoop: EventLoop
    let logger: Logger

    let isLocalServer: Bool

    init(on eventLoop: EventLoop? = nil, logger: Logger? = nil) {
        self.eventLoop = eventLoop ?? MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        self.logger = logger ?? Logger(label: "SeriesUseCaseFactoryMock")
        isLocalServer = true
    }

    func makeUseCase() -> SeriesCreateUseCase {
        SeriesCreateUseCase(
            repository: makeRepository(),
            characterUseCase: CharacterUseCaseFactoryMock().makeUseCase(),
            comicUseCase: ComicUseCaseFactoryMock().makeUseCase()
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
