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
    public let tableName: String

    private let seriesTableName: String
    private let comicTableName: String

    public init(
        on eventLoop: EventLoop,
        repositoryAPIService: RepositoryAPIService,
        logger: Logger,
        decoderService: DecoderService = DecoderProvider(),
        encoderService: EncoderService = EncoderProvider(),
        tableName: String,
        seriesTableName: String,
        comicTableName: String
    ) {
        self.eventLoop = eventLoop
        self.repositoryAPIService = repositoryAPIService
        self.logger = logger
        self.decoderService = decoderService
        self.encoderService = encoderService
        self.tableName = tableName
        self.seriesTableName = seriesTableName
        self.comicTableName = comicTableName
    }

    // MARK: - Create item

    public func create(_ item: Character) -> EventLoopFuture<Void> {
        CharacterCreateAPIWrapper(
            on: eventLoop,
            repositoryAPIService: repositoryAPIService,
            encoderService: encoderService,
            logger: logger,
            tableName: tableName,
            seriesUseCase: makeSeriesUseCase(),
            comicUseCase: makeComicUseCase()
        ).create(item)
    }

    // MARK: - Get item

    public func getItem(withID itemID: String) -> EventLoopFuture<Character> {
        CharacterGetAPIWrapper(
            repositoryAPIService: repositoryAPIService,
            decoderService: decoderService
        ).get(withID: itemID)
    }

    public func getAllItems() -> EventLoopFuture<[Character]> {
        CharacterGetAllAPIWrapper(
            repositoryAPIService: repositoryAPIService,
            decoderService: decoderService
        ).getAll()
    }

    // MARK: - Get metadata

    public func getMetadata(id: String) -> EventLoopFuture<Character> {
        repositoryAPIService.getMetadata(withID: mapItemID(id))
            .flatMapThrowing { Character(from: try decoderService.decode(from: $0)) }
            .flatMapErrorThrowing { throw $0.mapToAPIError(itemType: Character.self) }
    }

    private func mapItemID(_ id: String) -> String {
        "\(String.getType(from: Item.self))#\(id)"
    }

    public func getAllMetadata(ids: Set<String>) -> EventLoopFuture<[Character]> {
        CharacterGetAllMetadataAPIWrapper(
            repositoryAPIService: repositoryAPIService,
            decoderService: decoderService
        ).getAllMetadata(ids: ids)
    }

    // MARK: - Update item

    public func update(_ item: Character) -> EventLoopFuture<Void> {
        CharacterUpdateAPIWrapper(
            on: eventLoop,
            repositoryAPIService: repositoryAPIService,
            encoderService: encoderService,
            decoderService: decoderService,
            logger: logger,
            tableName: tableName,
            seriesUseCase: makeSeriesUseCase(),
            comicUseCase: makeComicUseCase()
        ).update(item)
    }

    private func makeSeriesUseCase() -> SeriesUseCase<SeriesRepositoryAPIWrapper, InMemoryCacheProvider<Series>> {
        SeriesUseCaseFactory(
            on: eventLoop,
            isLocalServer: LocalServer.isEnabled,
            cacheProvider: LocalServer.seriesInMemoryCache,
            logger: logger,
            tableName: seriesTableName
        ).makeUseCase()
    }

    private func makeComicUseCase() -> ComicUseCase<ComicRepositoryAPIWrapper, InMemoryCacheProvider<Comic>> {
        ComicUseCaseFactory(
            on: eventLoop,
            isLocalServer: LocalServer.isEnabled,
            cacheProvider: LocalServer.comicInMemoryCache,
            logger: logger,
            tableName: comicTableName
        ).makeUseCase()
    }

}
