//
//  ComicUpdateAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 06/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

struct ComicUpdateAPIWrapper: UpdateAPIWrapper, CharacterSummaryFuturesFactory, SeriesSummaryFuturesFactory {

    typealias Summary = ItemSummary<Comic>
    typealias ItemDatabase = ComicDatabase

    let eventLoop: EventLoop
    let repositoryAPIService: UpdateRepositoryAPIService
    let encoderService: EncoderService
    let decoderService: DecoderService
    
    let characterUseCase: CharacterUseCase<CharacterRepositoryAPIWrapper, InMemoryCacheProvider<Character>>
    let seriesUseCase: SeriesUseCase<SeriesRepositoryAPIWrapper, InMemoryCacheProvider<Series>>

    func getSummaryFutures(for item: Comic, from table: String) -> [EventLoopFuture<[DatabaseUpdateItem]>] {
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
            var dbItems: [DatabaseUpdateItem] = makeItemSummary($0, item: comic, in: table)
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
            var dbItems: [DatabaseUpdateItem] = makeItemSummary($0, item: comic, in: table)
            return appendItemSummary($0, item: comic, dbItems: &dbItems, tableName: table)
        }
    }

}
