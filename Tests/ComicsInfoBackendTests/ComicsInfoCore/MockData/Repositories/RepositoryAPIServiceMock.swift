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
        logger: Logger
    ) -> RepositoryAPIService {
        DatabaseProvider(
            database: makeDatabase(
                isLocalServer: isLocalServer,
                on: eventLoop,
                logger: logger
            )
        )
    }

    static func makeDatabase(
        isLocalServer: Bool = true,
        on eventLoop: EventLoop,
        logger: Logger
    ) -> Database {
        DatabaseFectory(isLocalServer: isLocalServer)
            .makeDatabase(eventLoop: eventLoop, logger: logger)
    }

}
