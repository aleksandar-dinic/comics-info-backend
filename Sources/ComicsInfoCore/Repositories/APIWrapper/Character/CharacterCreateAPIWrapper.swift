//
//  CharacterCreateAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 02/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Logging
import Foundation
import NIO

struct CharacterCreateAPIWrapper: CreateAPIWrapper, SeriesSummaryFuturesFactory, ComicSummaryFuturesFactory {

    typealias Summary = CharacterSummary
    typealias ItemDatabase = CharacterDatabase

    let repositoryAPIService: RepositoryAPIService
    let encoderService: EncoderService
    let eventLoop: EventLoop

    let seriesUseCase: SeriesUseCase<SeriesRepositoryAPIWrapper, InMemoryCacheProvider<Series>>
    let comicUseCase: ComicUseCase<ComicRepositoryAPIWrapper, InMemoryCacheProvider<Comic>>

    init(
        on eventLoop: EventLoop,
        repositoryAPIService: RepositoryAPIService,
        encoderService: EncoderService,
        logger: Logger,
        seriesUseCase: SeriesUseCase<SeriesRepositoryAPIWrapper, InMemoryCacheProvider<Series>>,
        comicUseCase: ComicUseCase<ComicRepositoryAPIWrapper, InMemoryCacheProvider<Comic>>
    ) {
        self.repositoryAPIService = repositoryAPIService
        self.encoderService = encoderService
        self.eventLoop = eventLoop
        self.seriesUseCase = seriesUseCase
        self.comicUseCase = comicUseCase
    }

    func getSummaryFutures(
        for item: Character,
        in table: String
    ) -> [EventLoopFuture<[DatabasePutItem]>] {
        [
            getSeriesSummary(forIDs: item.seriesID, character: item, from: table),
            getComicsSummary(forIDs: item.comicsID, character: item, from: table)
        ]
    }

    // MARK: SeriesSummary

    private func getSeriesSummary(
        forIDs seriesID: Set<String>?,
        character: Character,
        from table: String
    ) -> EventLoopFuture<[DatabasePutItem]> {
        getSeries(seriesID, from: table).flatMapThrowing {
            guard !$0.isEmpty else { return [] }
            var dbItems: [DatabasePutItem] = makeSeriesSummary($0, item: character, in: table)
            return appendItemSummary($0, item: character, dbItems: &dbItems, tableName: table)
        }
    }

    // MARK: ComicsSummary

    private func getComicsSummary(
        forIDs comicsId: Set<String>?,
        character: Character,
        from table: String
    ) -> EventLoopFuture<[DatabasePutItem]> {
        getComics(comicsId, from: table).flatMapThrowing {
            guard !$0.isEmpty else { return [] }
            var dbItems: [DatabasePutItem] = makeComicsSummary($0, item: character, in: table)
            return appendItemSummary($0, item: character, dbItems: &dbItems, tableName: table)
        }
    }

}
