//
//  RepositoryAPIServiceMock.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 20/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation
import Logging
import NIO

enum RepositoryAPIServiceMock {

    static func makeRepositoryAPIService(
        isLocalServer: Bool = true,
        on eventLoop: EventLoop,
        logger: Logger,
        items: [String: TableMock]
    ) -> RepositoryAPIService {
        DatabaseProvider(
            database: makeDatabase(
                isLocalServer: isLocalServer,
                on: eventLoop,
                logger: logger,
                items: items
            )
        )
    }
    
    static func makeRepositoryUpdateAPIService(
        isLocalServer: Bool = true,
        on eventLoop: EventLoop,
        logger: Logger,
        items: [String: TableMock]
    ) -> UpdateRepositoryAPIService {
        UpdateDatabaseProvider(
            database: makeUpdateDatabase(
                isLocalServer: isLocalServer,
                on: eventLoop,
                logger: logger,
                items: items
            )
        )
    }
    
    static func makeRepositoryCreateAPIService(
        isLocalServer: Bool = true,
        on eventLoop: EventLoop,
        logger: Logger
    ) -> CreateRepositoryAPIService {
        CreateDatabaseProvider(
            database: makeCreateDatabase(
                isLocalServer: isLocalServer,
                on: eventLoop,
                logger: logger
            )
        )
    }

    static func makeDatabase(
        isLocalServer: Bool = true,
        on eventLoop: EventLoop,
        logger: Logger,
        items: [String: TableMock]
    ) -> Database {
        DatabaseFectory(isLocalServer: isLocalServer)
            .makeDatabase(eventLoop: eventLoop, logger: logger, items: items)
    }
    
    static func makeUpdateDatabase(
        isLocalServer: Bool = true,
        on eventLoop: EventLoop,
        logger: Logger,
        items: [String: TableMock]
    ) -> DatabaseUpdate {
        DatabaseFectory(isLocalServer: isLocalServer)
            .makeDatabaseUpdate(eventLoop: eventLoop, logger: logger, items: items)
    }
    
    static func makeCreateDatabase(
        isLocalServer: Bool = true,
        on eventLoop: EventLoop,
        logger: Logger
    ) -> DatabaseCreate {
        DatabaseFectory(isLocalServer: isLocalServer)
            .makeDatabaseCreate(eventLoop: eventLoop, logger: logger)
    }

}
