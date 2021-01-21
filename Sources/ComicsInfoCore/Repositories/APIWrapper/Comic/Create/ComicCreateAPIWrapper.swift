//
//  ComicCreateAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 05/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

struct ComicCreateAPIWrapper: CreateAPIWrapper, CharacterSummaryFuturesFactory, SeriesSummaryFuturesFactory {

    typealias Summary = ItemSummary<Comic>
    typealias ItemDatabase = ComicDatabase
    
    let eventLoop: EventLoop
    let repositoryAPIService: CreateRepositoryAPIService
    let encoderService: EncoderService

    let characterUseCase: CharacterUseCase<CharacterRepositoryAPIWrapper, InMemoryCacheProvider<Character>>
    let seriesUseCase: SeriesUseCase<SeriesRepositoryAPIWrapper, InMemoryCacheProvider<Series>>

    func getSummaryFutures(for item: Comic, in table: String) -> [EventLoopFuture<[DatabasePutItem]>] {
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
            var dbItems: [DatabasePutItem] = makeItemSummary($0, item: comic, in: table)
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
            var dbItems: [DatabasePutItem] = makeItemSummary($0, item: comic, in: table)
            return appendItemSummary($0, item: comic, dbItems: &dbItems, tableName: table)
        }
    }

}
