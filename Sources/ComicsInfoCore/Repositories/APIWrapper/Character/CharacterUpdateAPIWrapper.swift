//
//  CharacterUpdateAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 06/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Logging
import Foundation
import NIO

struct CharacterUpdateAPIWrapper: UpdateAPIWrapper, SeriesSummaryFuturesFactory, ComicSummaryFuturesFactory {

    typealias Summary = CharacterSummary
    typealias ItemDatabase = CharacterDatabase

    let seriesUseCase: SeriesUseCase<SeriesRepositoryAPIWrapper, InMemoryCacheProvider<Series>>
    let comicUseCase: ComicUseCase<ComicRepositoryAPIWrapper, InMemoryCacheProvider<Comic>>
    
    let eventLoop: EventLoop
    let repositoryAPIService: RepositoryAPIService
    let encoderService: EncoderService
    let decoderService: DecoderService

    init(
        on eventLoop: EventLoop,
        repositoryAPIService: RepositoryAPIService,
        encoderService: EncoderService,
        decoderService: DecoderService,
        logger: Logger
    ) {
        self.eventLoop = eventLoop
        self.repositoryAPIService = repositoryAPIService
        self.encoderService = encoderService
        self.decoderService = decoderService
        seriesUseCase = SeriesUseCaseFactory<InMemoryCacheProvider<Series>>(
            on: eventLoop,
            isLocalServer: LocalServer.isEnabled,
            cacheProvider: LocalServer.seriesInMemoryCache,
            logger: logger
        ).makeUseCase()
        comicUseCase = ComicUseCaseFactory<InMemoryCacheProvider<Comic>>(
            on: eventLoop,
            isLocalServer: LocalServer.isEnabled,
            cacheProvider: LocalServer.comicInMemoryCache,
            logger: logger
        ).makeUseCase()
    }

    func getSummaryFutures(for item: Character) -> [EventLoopFuture<[DatabaseUpdateItem]>] {
        [
            getSeriesSummary(forIDs: item.seriesID, character: item),
            getComicsSummary(forIDs: item.comicsID, character: item)
        ]
    }

    // MARK: SeriesSummary

    private func getSeriesSummary(
        forIDs seriesID: Set<String>?,
        character: Character
    ) -> EventLoopFuture<[DatabaseUpdateItem]> {
        getSeries(seriesID).flatMapThrowing {
            guard !$0.isEmpty else { return [] }
            var dbItems: [DatabaseUpdateItem] = makeSeriesSummary($0, item: character)
            return appendItemSummary($0, item: character, dbItems: &dbItems)
        }
    }

    // MARK: ComicsSummary

    private func getComicsSummary(
        forIDs comicsId: Set<String>?,
        character: Character
    ) -> EventLoopFuture<[DatabaseUpdateItem]> {
        getComics(comicsId).flatMapThrowing {
            guard !$0.isEmpty else { return [] }
            var dbItems: [DatabaseUpdateItem] = makeComicsSummary($0, item: character)
            return appendItemSummary($0, item: character, dbItems: &dbItems)
        }
    }

}
