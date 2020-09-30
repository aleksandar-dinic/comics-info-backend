//
//  SeriesRepositoryAPIWrapper.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 27/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public struct SeriesRepositoryAPIWrapper: RepositoryAPIWrapper {

    public let eventLoop: EventLoop
    public let repositoryAPIService: RepositoryAPIService
    public let decoderService: DecoderService
    public let encoderService: EncoderService

    public init(
        on eventLoop: EventLoop,
        repositoryAPIService: RepositoryAPIService,
        decoderService: DecoderService = DecoderProvider(),
        encoderService: EncoderService = EncoderProvider()
    ) {
        self.eventLoop = eventLoop
        self.repositoryAPIService = repositoryAPIService
        self.decoderService = decoderService
        self.encoderService = encoderService
    }

    public func create(_ item: Series) -> EventLoopFuture<Void> {
        SeriesCreateAPIWrapper(
            on: eventLoop,
            repositoryAPIService: repositoryAPIService,
            encoderService: encoderService
        ).create(item)
    }

    // FIXME: - Change getMetadata when implement getItem
    public func getItem(withID itemID: String) -> EventLoopFuture<Series> {
        repositoryAPIService.getMetadata(id: itemID).flatMapThrowing {
            return Series(from: try decoderService.decode(from: $0))
        }
    }

    public func getAllItems() -> EventLoopFuture<[Series]> {
        repositoryAPIService.getAllItems().flatMapThrowing {
            let seriesDatabase: [SeriesDatabase] = try decoderService.decodeAll(from: $0)
            return seriesDatabase.map { Series(from: $0) }
        }
    }

    public func getMetadata(id: String) -> EventLoopFuture<Series> {
        repositoryAPIService.getMetadata(id: id).flatMapThrowing {
            return Series(from: try decoderService.decode(from: $0))
        }
    }

    public func getAllMetadata(ids: Set<String>) -> EventLoopFuture<[Series]> {
        repositoryAPIService.getAllMetadata(ids: ids).flatMapThrowing {
            let seriesDatabase: [SeriesDatabase] = try decoderService.decodeAll(from: $0)
            return seriesDatabase.map { Series(from: $0) }
        }
    }

}
