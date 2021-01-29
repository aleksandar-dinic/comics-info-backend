//
//  SeriesCreateAPIWrapperMock.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 21/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation
import Logging
import NIO

enum SeriesCreateAPIWrapperMock {

    static func make(
        on eventLoop: EventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next(),
        logger: Logger = Logger(label: "SeriesCreateAPIWrapperMock"),
        items: [String: Codable]
    ) -> SeriesCreateAPIWrapper {
        SeriesCreateAPIWrapper(
            repositoryAPIService: RepositoryAPIServiceMock.makeRepositoryCreateAPIService(
                on: eventLoop,
                logger: logger
            )
        )
    }

}
