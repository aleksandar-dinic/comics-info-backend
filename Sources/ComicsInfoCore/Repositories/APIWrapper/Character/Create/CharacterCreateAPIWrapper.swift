//
//  CharacterCreateAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 02/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

struct CharacterCreateAPIWrapper: CreateAPIWrapper, SeriesSummaryFuturesFactory, ComicSummaryFuturesFactory {

    typealias Summary = ItemSummary<Character>
    typealias ItemDatabase = CharacterDatabase
    
    let eventLoop: EventLoop
    let repositoryAPIService: CreateRepositoryAPIService
    let encoderService: EncoderService

    let seriesUseCase: SeriesUseCase<SeriesRepositoryAPIWrapper, InMemoryCacheProvider<Series>>
    let comicUseCase: ComicUseCase<ComicRepositoryAPIWrapper, InMemoryCacheProvider<Comic>>

    func getSummaryFutures(for item: Character, in table: String) -> [EventLoopFuture<[DatabasePutItem]>] {
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
            var dbItems: [DatabasePutItem] = makeItemSummary($0, item: character, in: table)
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
            var dbItems: [DatabasePutItem] = makeItemSummary($0, item: character, in: table)
            return appendItemSummary($0, item: character, dbItems: &dbItems, tableName: table)
        }
    }

}
