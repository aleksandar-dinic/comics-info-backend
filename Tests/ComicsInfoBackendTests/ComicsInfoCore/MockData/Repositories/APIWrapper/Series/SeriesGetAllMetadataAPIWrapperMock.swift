//
//  SeriesGetAllMetadataAPIWrapperMock.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 21/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation
import Logging
import NIO

enum SeriesGetAllMetadataAPIWrapperMock {

    static func make(
        on eventLoop: EventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next(),
        logger: Logger = Logger(label: "SeriesCreateAPIWrapperMock"),
        decoderService: DecoderService = DecoderProvider(),
        tables: [String: TableMock]
    ) -> SeriesGetAllMetadataAPIWrapper {
        let repositoryAPIService = RepositoryAPIServiceMock.makeRepositoryAPIService(
            on: eventLoop,
            logger: logger,
            tables: tables
        )
        return SeriesGetAllMetadataAPIWrapper(
            repositoryAPIService: repositoryAPIService,
            decoderService: decoderService
        )
    }

}
