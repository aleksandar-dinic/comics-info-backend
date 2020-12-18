//
//  CharacterRepositoryAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 01/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Logging
import Foundation
import NIO

public struct CharacterRepositoryAPIWrapper: RepositoryAPIWrapper {

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

    public func create(_ item: Character, in table: String) -> EventLoopFuture<Void> {
        CharacterCreateAPIWrapper(
            on: eventLoop,
            repositoryAPIService: repositoryAPIService,
            encoderService: encoderService,
            logger: logger,
            seriesUseCase: makeSeriesUseCase(),
            comicUseCase: makeComicUseCase()
        ).create(item, in: table)
    }

    // MARK: - Get item

    public func getItem(withID itemID: String, from table: String) -> EventLoopFuture<Character> {
        CharacterGetAPIWrapper(
            repositoryAPIService: repositoryAPIService,
            decoderService: decoderService
        ).get(withID: itemID, from: table)
    }

    public func getAllItems(from table: String) -> EventLoopFuture<[Character]> {
        CharacterGetAllAPIWrapper(
            repositoryAPIService: repositoryAPIService,
            decoderService: decoderService
        ).getAll(from: table)
    }

    // MARK: - Get metadata

    public func getMetadata(id: String, from table: String) -> EventLoopFuture<Character> {
        repositoryAPIService.getMetadata(withID: mapItemID(id), from: table)
            .flatMapThrowing { Character(from: try decoderService.decode(from: $0)) }
            .flatMapErrorThrowing { throw $0.mapToAPIError(itemType: Character.self) }
    }

    private func mapItemID(_ id: String) -> String {
        "\(String.getType(from: Item.self))#\(id)"
    }

    public func getAllMetadata(ids: Set<String>, from table: String) -> EventLoopFuture<[Character]> {
        CharacterGetAllMetadataAPIWrapper(
            repositoryAPIService: repositoryAPIService,
            decoderService: decoderService
        ).getAllMetadata(ids: ids, from: table)
    }

    // MARK: - Update item

    public func update(_ item: Character, in table: String) -> EventLoopFuture<Void> {
        CharacterUpdateAPIWrapper(
            on: eventLoop,
            repositoryAPIService: repositoryAPIService,
            encoderService: encoderService,
            decoderService: decoderService,
            logger: logger,
            seriesUseCase: makeSeriesUseCase(),
            comicUseCase: makeComicUseCase()
        ).update(item, in: table)
    }

    private func makeSeriesUseCase() -> SeriesUseCase<SeriesRepositoryAPIWrapper, InMemoryCacheProvider<Series>> {
        SeriesUseCaseFactory(
            on: eventLoop,
            isLocalServer: LocalServer.isEnabled,
            cacheProvider: LocalServer.seriesInMemoryCache,
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
