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
        logger: Logger,
        seriesUseCase: SeriesUseCase<SeriesRepositoryAPIWrapper, InMemoryCacheProvider<Series>>,
        comicUseCase: ComicUseCase<ComicRepositoryAPIWrapper, InMemoryCacheProvider<Comic>>
    ) {
        self.eventLoop = eventLoop
        self.repositoryAPIService = repositoryAPIService
        self.encoderService = encoderService
        self.decoderService = decoderService
        self.seriesUseCase = seriesUseCase
        self.comicUseCase = comicUseCase
    }

    func getSummaryFutures(
        for item: Character,
        from table: String
    ) -> [EventLoopFuture<[DatabaseUpdateItem]>] {
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
    ) -> EventLoopFuture<[DatabaseUpdateItem]> {
        getSeries(seriesID, from: table).flatMapThrowing {
            guard !$0.isEmpty else { return [] }
            var dbItems: [DatabaseUpdateItem] = makeSeriesSummary($0, item: character, in: table)
            return appendItemSummary($0, item: character, dbItems: &dbItems, tableName: table)
        }
    }

    // MARK: ComicsSummary

    private func getComicsSummary(
        forIDs comicsId: Set<String>?,
        character: Character,
        from table: String
    ) -> EventLoopFuture<[DatabaseUpdateItem]> {
        getComics(comicsId, from: table).flatMapThrowing {
            guard !$0.isEmpty else { return [] }
            var dbItems: [DatabaseUpdateItem] = makeComicsSummary($0, item: character, in: table)
            return appendItemSummary($0, item: character, dbItems: &dbItems, tableName: table)
        }
    }

}
