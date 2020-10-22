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
        tableName: String,
        logger: Logger
    ) -> RepositoryAPIService {
        DatabaseProvider(
            database: makeDatabase(
                isLocalServer: isLocalServer,
                on: eventLoop,
                tableName: tableName,
                logger: logger
            )
        )
    }

    static func makeDatabase(
        isLocalServer: Bool = true,
        on eventLoop: EventLoop,
        tableName: String,
        logger: Logger
    ) -> Database {
        DatabaseFectory(isLocalServer: isLocalServer, tableName: tableName)
            .makeDatabase(eventLoop: eventLoop, logger: logger)
    }

}
