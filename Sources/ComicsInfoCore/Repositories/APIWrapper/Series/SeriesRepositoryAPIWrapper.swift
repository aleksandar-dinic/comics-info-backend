//
//  SeriesRepositoryAPIWrapper.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 27/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Logging
import Foundation
import NIO

public struct SeriesRepositoryAPIWrapper: RepositoryAPIWrapper {

    public let eventLoop: EventLoop
    public let repositoryAPIService: RepositoryAPIService
    public let logger: Logger
    public let decoderService: DecoderService
    public let encoderService: EncoderService

    public init(
        on eventLoop: EventLoop,
        repositoryAPIService: RepositoryAPIService,
        logger: Logger,
        decoderService: DecoderService = DecoderProvider(),
        encoderService: EncoderService = EncoderProvider()
    ) {
        self.eventLoop = eventLoop
        self.repositoryAPIService = repositoryAPIService
        self.logger = logger
        self.decoderService = decoderService
        self.encoderService = encoderService
    }

    // MARK: - Create item

    public func create(_ item: Series) -> EventLoopFuture<Void> {
        SeriesCreateAPIWrapper(
            on: eventLoop,
            repositoryAPIService: repositoryAPIService,
            encoderService: encoderService,
            logger: logger
        ).create(item)
    }

    // MARK: - Get item

    public func getItem(withID itemID: String) -> EventLoopFuture<Series> {
        SeriesGetAPIWrapper(
            repositoryAPIService: repositoryAPIService,
            decoderService: decoderService
        ).get(withID: itemID)
    }

    public func getAllItems() -> EventLoopFuture<[Series]> {
        SeriesGetAllAPIWrapper(
            repositoryAPIService: repositoryAPIService,
            decoderService: decoderService
        ).getAll()
    }

    // MARK: - Get metadata
    
    public func getMetadata(id: String) -> EventLoopFuture<Series> {
        repositoryAPIService.getMetadata(withID: id)
            .flatMapThrowing { Series(from: try decoderService.decode(from: $0)) }
            .flatMapErrorThrowing { throw $0.mapToAPIError(itemType: Series.self) }
    }

    public func getAllMetadata(ids: Set<String>) -> EventLoopFuture<[Series]> {
        SeriesGetAllMetadataAPIWrapper(
            repositoryAPIService: repositoryAPIService,
            decoderService: decoderService
        ).getAllMetadata(ids: ids)
    }

    // MARK: - Update item

    public func update(_ item: Series) -> EventLoopFuture<Void> {
        SeriesUpdateAPIWrapper(
            on: eventLoop,
            repositoryAPIService: repositoryAPIService,
            encoderService: encoderService,
            decoderService: decoderService,
            logger: logger
        ).update(item)
    }

}
