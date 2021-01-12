//
//  SeriesCreateAPIWrapper.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 28/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

struct SeriesCreateAPIWrapper: CreateAPIWrapper, CharacterSummaryFuturesFactory, ComicSummaryFuturesFactory {

    typealias Summary = SeriesSummary
    typealias ItemDatabase = SeriesDatabase

    let eventLoop: EventLoop
    let repositoryAPIService: CreateRepositoryAPIService
    let encoderService: EncoderService

    let characterUseCase: CharacterUseCase<CharacterRepositoryAPIWrapper, InMemoryCacheProvider<Character>>
    let comicUseCase: ComicUseCase<ComicRepositoryAPIWrapper, InMemoryCacheProvider<Comic>>

    func getSummaryFutures(for item: Series, in table: String) -> [EventLoopFuture<[DatabasePutItem]>] {
        [
            getCharactersSummary(forIDs: item.charactersID, series: item, from: table),
            getComicsSummary(forIDs: item.comicsID, series: item, from: table)
        ]
    }

    // MARK: CharactersSummary

    private func getCharactersSummary(
        forIDs charactersID: Set<String>?,
        series: Series,
        from table: String
    ) -> EventLoopFuture<[DatabasePutItem]> {
        getCharacters(charactersID, from: table).flatMapThrowing {
            guard !$0.isEmpty else { return [] }
            var dbItems: [DatabasePutItem] = makeCharactersSummary($0, item: series, in: table)
            return appendItemSummary($0, item: series, dbItems: &dbItems, tableName: table)
        }
    }

    // MARK: ComicsSummary

    private func getComicsSummary(
        forIDs comicsId: Set<String>?,
        series: Series,
        from table: String
    ) -> EventLoopFuture<[DatabasePutItem]> {
        getComics(comicsId, from: table).flatMapThrowing {
            guard !$0.isEmpty else { return [] }
            var dbItems: [DatabasePutItem] = makeComicsSummary($0, item: series, in: table)
            return appendItemSummary($0, item: series, dbItems: &dbItems, tableName: table)
        }
    }

}
