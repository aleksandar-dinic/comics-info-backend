//
//  SeriesRepositoryAPIWrapper.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 27/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import ComicsInfoCore
import Foundation
import NIO

struct SeriesRepositoryAPIWrapper: RepositoryAPIWrapper {

    let repositoryAPIService: RepositoryAPIService
    let decoderService: DecoderService
    let encoderService: EncoderService

    init(
        repositoryAPIService: RepositoryAPIService,
        decoderService: DecoderService = DecoderProvider(),
        encoderService: EncoderService = EncoderProvider()
    ) {
        self.repositoryAPIService = repositoryAPIService
        self.decoderService = decoderService
        self.encoderService = encoderService
    }

    func create(_ item: Series) -> EventLoopFuture<Void> {
        let item = encoderService.encode(item)
        return repositoryAPIService.create(item)
    }

    func getAll(on eventLoop: EventLoop) -> EventLoopFuture<[Series]> {
        repositoryAPIService.getAll(on: eventLoop).flatMapThrowing {
            try decoderService.decodeAll(from: $0)
        }
    }

    func get(
        withID identifier: Series.ID,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<Series> {
        repositoryAPIService.get(withID: identifier, on: eventLoop).flatMapThrowing {
            try decoderService.decode(from: $0)
        }
    }

}
