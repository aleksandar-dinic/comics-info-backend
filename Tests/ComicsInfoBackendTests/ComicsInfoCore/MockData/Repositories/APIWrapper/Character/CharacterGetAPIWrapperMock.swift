//
//  CharacterGetAPIWrapperMock.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 21/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation
import Logging
import NIO

enum CharacterGetAPIWrapperMock {

    static func make(
        on eventLoop: EventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next(),
        logger: Logger = Logger(label: "CharacterCreateAPIWrapperMock"),
        items: [String: Data]
    ) -> CharacterGetAPIWrapper {
        let repositoryAPIService = RepositoryAPIServiceMock.makeRepositoryAPIService(
            on: eventLoop,
            logger: logger,
            items: items
        )
        return CharacterGetAPIWrapper(repositoryAPIService: repositoryAPIService)
    }

}
