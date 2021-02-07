//
//  GetUseCaseFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 17/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Logging
import Foundation
import NIO

public protocol GetUseCaseFactory  {

    associatedtype CacheProvider: Cacheable
    associatedtype UseCaseType: GetUseCase

    var eventLoop: EventLoop { get }
    var isLocalServer: Bool { get }
    var cacheProvider: CacheProvider { get }
    var logger: Logger { get }

    func makeUseCase() -> UseCaseType

}

extension GetUseCaseFactory {
    
    func makeItemGetDBService() -> ItemGetDBService {
        GetDatabaseProvider(database: makeDatabase())
    }

    private func makeDatabase() -> DatabaseGet {
        DatabaseFectory(isLocalServer: isLocalServer)
            .makeDatabase(eventLoop: eventLoop, logger: logger)
    }

}
