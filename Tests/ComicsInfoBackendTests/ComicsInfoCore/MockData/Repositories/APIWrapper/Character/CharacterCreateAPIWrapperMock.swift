//
//  CharacterCreateAPIWrapperMock.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 20/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation
import Logging
import NIO

enum CharacterCreateAPIWrapperMock {

    static func make(
        on eventLoop: EventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next(),
        logger: Logger = Logger(label: "CharacterCreateAPIWrapperMock")
    ) -> CharacterCreateAPIWrapper {
        CharacterCreateAPIWrapper(
            repositoryAPIService: RepositoryAPIServiceMock.makeRepositoryCreateAPIService(
                on: eventLoop,
                logger: logger
            )
        )
    }

}
