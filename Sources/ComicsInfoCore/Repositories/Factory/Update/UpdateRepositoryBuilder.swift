//
//  UpdateRepositoryBuilder.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 11/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Logging
import Foundation
import NIO

public protocol UpdateRepositoryBuilder  {

    var eventLoop: EventLoop { get }
    var isLocalServer: Bool { get }
    var logger: Logger { get }

    func makeUpdateRepository() -> UpdateRepository
    
}

extension UpdateRepositoryBuilder {
    
    public func makeUpdateRepository() -> UpdateRepository {
        UpdateRepositoryFactory(itemUpdateDBService: makeItemUpdateDBService())
            .make()
    }

    func makeItemUpdateDBService() -> ItemUpdateDBService {
        UpdateDatabaseProvider(database: makeDatabase())
    }

    private func makeDatabase() -> DatabaseUpdate {
        DatabaseFectory(isLocalServer: isLocalServer)
            .makeDatabaseUpdate(eventLoop: eventLoop, logger: logger)
    }

}
