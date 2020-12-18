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

    init(
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

    public func create(_ item: Series, in table: String) -> EventLoopFuture<Void> {
        SeriesCreateAPIWrapper(
            on: eventLoop,
            repositoryAPIService: repositoryAPIService,
            encoderService: encoderService,
            logger: logger,
            characterUseCase: makeCharacterUseCase(),
            comicUseCase: makeComicUseCase()
        ).create(item, in: table)
    }

    // MARK: - Get item

    public func getItem(withID itemID: String, from table: String) -> EventLoopFuture<Series> {
        SeriesGetAPIWrapper(
            repositoryAPIService: repositoryAPIService,
            decoderService: decoderService
        ).get(withID: itemID, from: table)
    }

    public func getAllItems(from table: String) -> EventLoopFuture<[Series]> {
        SeriesGetAllAPIWrapper(
            repositoryAPIService: repositoryAPIService,
            decoderService: decoderService
        ).getAll(from: table)
    }

    // MARK: - Get metadata
    
    public func getMetadata(id: String, from table: String) -> EventLoopFuture<Series> {
        repositoryAPIService.getMetadata(withID: mapItemID(id), from: table)
            .flatMapThrowing { Series(from: try decoderService.decode(from: $0)) }
            .flatMapErrorThrowing { throw $0.mapToAPIError(itemType: Series.self) }
    }

    private func mapItemID(_ id: String) -> String {
        "\(String.getType(from: Item.self))#\(id)"
    }

    public func getAllMetadata(ids: Set<String>, from table: String) -> EventLoopFuture<[Series]> {
        SeriesGetAllMetadataAPIWrapper(
            repositoryAPIService: repositoryAPIService,
            decoderService: decoderService
        ).getAllMetadata(ids: ids, from: table)
    }

    // MARK: - Update item

    public func update(_ item: Series, in table: String) -> EventLoopFuture<Void> {
        SeriesUpdateAPIWrapper(
            on: eventLoop,
            repositoryAPIService: repositoryAPIService,
            encoderService: encoderService,
            decoderService: decoderService,
            logger: logger,
            characterUseCase: makeCharacterUseCase(),
            comicUseCase: makeComicUseCase()
        ).update(item, in: table)
    }

    private func makeCharacterUseCase() -> CharacterUseCase<CharacterRepositoryAPIWrapper, InMemoryCacheProvider<Character>> {
        CharacterUseCaseFactory(
            on: eventLoop,
            isLocalServer: LocalServer.isEnabled,
            cacheProvider: LocalServer.characterInMemoryCache,
            logger: logger
        ).makeUseCase()
    }

    private func makeComicUseCase() -> ComicUseCase<ComicRepositoryAPIWrapper, InMemoryCacheProvider<Comic>> {
        ComicUseCaseFactory(
            on: eventLoop,
            isLocalServer: LocalServer.isEnabled,
            cacheProvider: LocalServer.comicInMemoryCache,
            logger: logger
        ).makeUseCase()
    }

}
