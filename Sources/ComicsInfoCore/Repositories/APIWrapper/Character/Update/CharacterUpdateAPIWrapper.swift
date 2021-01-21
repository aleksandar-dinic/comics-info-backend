//
//  CharacterUpdateAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 06/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

struct CharacterUpdateAPIWrapper: UpdateAPIWrapper, SeriesSummaryFuturesFactory, ComicSummaryFuturesFactory {

    typealias Summary = ItemSummary<Character>
    typealias ItemDatabase = CharacterDatabase
    
    let eventLoop: EventLoop
    let repositoryAPIService: UpdateRepositoryAPIService
    let encoderService: EncoderService
    let decoderService: DecoderService
    
    let seriesUseCase: SeriesUseCase<SeriesRepositoryAPIWrapper, InMemoryCacheProvider<Series>>
    let comicUseCase: ComicUseCase<ComicRepositoryAPIWrapper, InMemoryCacheProvider<Comic>>

    func getSummaryFutures(for item: Character, from table: String) -> [EventLoopFuture<[DatabaseUpdateItem]>] {
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
            var dbItems: [DatabaseUpdateItem] = makeItemSummary($0, item: character, in: table)
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
            var dbItems: [DatabaseUpdateItem] = makeItemSummary($0, item: character, in: table)
            return appendItemSummary($0, item: character, dbItems: &dbItems, tableName: table)
        }
    }

}
