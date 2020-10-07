//
//  SeriesUpdateAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 06/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Logging
import Foundation
import NIO

struct SeriesUpdateAPIWrapper: UpdateAPIWrapper, CharacterSummaryFuturesFactory, ComicSummaryFuturesFactory {

    typealias Summary = SeriesSummary
    typealias ItemDatabase = SeriesDatabase

    let characterUseCase: CharacterUseCase<CharacterRepositoryAPIWrapper, InMemoryCacheProvider<Character>>
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
        characterUseCase = CharacterUseCaseFactory<InMemoryCacheProvider<Character>>(
            on: eventLoop,
            isLocalServer: LocalServer.isEnabled,
            cacheProvider: LocalServer.characterInMemoryCache,
            logger: logger
        ).makeUseCase()
        comicUseCase = ComicUseCaseFactory<InMemoryCacheProvider<Comic>>(
            on: eventLoop,
            isLocalServer: LocalServer.isEnabled,
            cacheProvider: LocalServer.comicInMemoryCache,
            logger: logger
        ).makeUseCase()
    }

    func getSummaryFutures(for item: Series) -> [EventLoopFuture<[DatabaseUpdateItem]>] {
        [
            getCharactersSummary(forIDs: item.charactersID, series: item),
            getComicsSummary(forIDs: item.comicsID, series: item)
        ]
    }

    // MARK: CharactersSummary

    private func getCharactersSummary(
        forIDs charactersId: Set<String>?,
        series: Series
    ) -> EventLoopFuture<[DatabaseUpdateItem]> {
        getCharacters(charactersId).flatMapThrowing {
            guard !$0.isEmpty else { return [] }
            var dbItems: [DatabaseUpdateItem] = makeCharactersSummary($0, item: series)
            return appendItemSummary($0, item: series, dbItems: &dbItems)
        }
    }

    // MARK: ComicsSummary

    private func getComicsSummary(
        forIDs comicsId: Set<String>?,
        series: Series
    ) -> EventLoopFuture<[DatabaseUpdateItem]> {
        getComics(comicsId).flatMapThrowing {
            guard !$0.isEmpty else { return [] }
            var dbItems: [DatabaseUpdateItem] = makeComicsSummary($0, item: series)
            return appendItemSummary($0, item: series, dbItems: &dbItems)
        }
    }

}
