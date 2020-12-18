//
//  ComicUpdateAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 06/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Logging
import Foundation
import NIO

struct ComicUpdateAPIWrapper: UpdateAPIWrapper, CharacterSummaryFuturesFactory, SeriesSummaryFuturesFactory {

    typealias Summary = ComicSummary
    typealias ItemDatabase = ComicDatabase

    let characterUseCase: CharacterUseCase<CharacterRepositoryAPIWrapper, InMemoryCacheProvider<Character>>
    let seriesUseCase: SeriesUseCase<SeriesRepositoryAPIWrapper, InMemoryCacheProvider<Series>>

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
        characterUseCase: CharacterUseCase<CharacterRepositoryAPIWrapper, InMemoryCacheProvider<Character>>,
        seriesUseCase: SeriesUseCase<SeriesRepositoryAPIWrapper, InMemoryCacheProvider<Series>>
    ) {
        self.eventLoop = eventLoop
        self.repositoryAPIService = repositoryAPIService
        self.encoderService = encoderService
        self.decoderService = decoderService
        self.characterUseCase = characterUseCase
        self.seriesUseCase = seriesUseCase
    }

    func getSummaryFutures(
        for item: Comic,
        from table: String
    ) -> [EventLoopFuture<[DatabaseUpdateItem]>] {
        [
            getCharactersSummary(forIDs: item.charactersID, comic: item, from: table),
            getSeriesSummary(forIDs: item.seriesID, comic: item, from: table)
        ]
    }

    // MARK: CharactersSummary

    private func getCharactersSummary(
        forIDs charactersId: Set<String>?,
        comic: Comic,
        from table: String
    ) -> EventLoopFuture<[DatabaseUpdateItem]> {
        getCharacters(charactersId, from: table).flatMapThrowing {
            guard !$0.isEmpty else { return [] }
            var dbItems: [DatabaseUpdateItem] = makeCharactersSummary($0, item: comic, in: table)
            return appendItemSummary($0, item: comic, dbItems: &dbItems, tableName: table)
        }
    }

    // MARK: SeriesSummary

    private func getSeriesSummary(
        forIDs seriesID: Set<String>?,
        comic: Comic,
        from table: String
    ) -> EventLoopFuture<[DatabaseUpdateItem]> {
        getSeries(seriesID, from: table).flatMapThrowing {
            guard !$0.isEmpty else { return [] }
            var dbItems: [DatabaseUpdateItem] = makeSeriesSummary($0, item: comic, in: table)
            return appendItemSummary($0, item: comic, dbItems: &dbItems, tableName: table)
        }
    }

}
