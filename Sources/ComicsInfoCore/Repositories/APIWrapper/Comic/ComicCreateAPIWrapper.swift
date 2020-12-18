//
//  ComicCreateAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 05/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Logging
import Foundation
import NIO

struct ComicCreateAPIWrapper: CreateAPIWrapper, CharacterSummaryFuturesFactory, SeriesSummaryFuturesFactory {

    typealias Summary = ComicSummary
    typealias ItemDatabase = ComicDatabase

    let repositoryAPIService: RepositoryAPIService
    let encoderService: EncoderService
    let eventLoop: EventLoop

    let characterUseCase: CharacterUseCase<CharacterRepositoryAPIWrapper, InMemoryCacheProvider<Character>>
    let seriesUseCase: SeriesUseCase<SeriesRepositoryAPIWrapper, InMemoryCacheProvider<Series>>

    init(
        on eventLoop: EventLoop,
        repositoryAPIService: RepositoryAPIService,
        encoderService: EncoderService,
        logger: Logger,
        characterUseCase: CharacterUseCase<CharacterRepositoryAPIWrapper, InMemoryCacheProvider<Character>>,
        seriesUseCase: SeriesUseCase<SeriesRepositoryAPIWrapper, InMemoryCacheProvider<Series>>
    ) {
        self.repositoryAPIService = repositoryAPIService
        self.encoderService = encoderService
        self.eventLoop = eventLoop
        self.characterUseCase = characterUseCase
        self.seriesUseCase = seriesUseCase
    }

    func getSummaryFutures(
        for item: Comic,
        in table: String
    ) -> [EventLoopFuture<[DatabasePutItem]>] {
        [
            getCharactersSummary(forIDs: item.charactersID, comic: item, from: table),
            getSeriesSummary(forIDs: item.seriesID, comic: item, from: table)
        ]
    }

    // MARK: CharactersSummary

    private func getCharactersSummary(
        forIDs charactersID: Set<String>?,
        comic: Comic,
        from table: String
    ) -> EventLoopFuture<[DatabasePutItem]> {
        getCharacters(charactersID, from: table).flatMapThrowing {
            guard !$0.isEmpty else { return [] }
            var dbItems: [DatabasePutItem] = makeCharactersSummary($0, item: comic, in: table)
            return appendItemSummary($0, item: comic, dbItems: &dbItems, tableName: table)
        }
    }

    // MARK: SeriesSummary

    private func getSeriesSummary(
        forIDs seriesID: Set<String>?,
        comic: Comic,
        from table: String
    ) -> EventLoopFuture<[DatabasePutItem]> {
        getSeries(seriesID, from: table).flatMapThrowing {
            guard !$0.isEmpty else { return [] }
            var dbItems: [DatabasePutItem] = makeSeriesSummary($0, item: comic, in: table)
            return appendItemSummary($0, item: comic, dbItems: &dbItems, tableName: table)
        }
    }

}
