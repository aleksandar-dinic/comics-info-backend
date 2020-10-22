//
//  UseCaseFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 17/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Logging
import Foundation
import NIO

public protocol UseCaseFactory  {

    associatedtype CacheProvider: Cacheable
    associatedtype UseCaseType: UseCase

    var eventLoop: EventLoop { get }
    var isLocalServer: Bool { get }
    var cacheProvider: CacheProvider { get }
    var logger: Logger { get }
    var tableName: String { get }

    func makeUseCase() -> UseCaseType

}

extension UseCaseFactory {

    func makeRepositoryAPIService() -> RepositoryAPIService {
        DatabaseProvider(database: makeDatabase())
    }

    private func makeDatabase() -> Database {
        DatabaseFectory(isLocalServer: isLocalServer, tableName: tableName)
            .makeDatabase(eventLoop: eventLoop, logger: logger)
    }

}
