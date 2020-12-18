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
        logger: Logger,
        characterUseCase: CharacterUseCase<CharacterRepositoryAPIWrapper, InMemoryCacheProvider<Character>>,
        comicUseCase: ComicUseCase<ComicRepositoryAPIWrapper, InMemoryCacheProvider<Comic>>
    ) {
        self.eventLoop = eventLoop
        self.repositoryAPIService = repositoryAPIService
        self.encoderService = encoderService
        self.decoderService = decoderService
        self.characterUseCase = characterUseCase
        self.comicUseCase = comicUseCase
    }

    func getSummaryFutures(
        for item: Series,
        from table: String
    ) -> [EventLoopFuture<[DatabaseUpdateItem]>] {
        [
            getCharactersSummary(forIDs: item.charactersID, series: item, from: table),
            getComicsSummary(forIDs: item.comicsID, series: item, from: table)
        ]
    }

    // MARK: CharactersSummary

    private func getCharactersSummary(
        forIDs charactersId: Set<String>?,
        series: Series,
        from table: String
    ) -> EventLoopFuture<[DatabaseUpdateItem]> {
        getCharacters(charactersId, from: table).flatMapThrowing {
            guard !$0.isEmpty else { return [] }
            var dbItems: [DatabaseUpdateItem] = makeCharactersSummary($0, item: series, in: table)
            return appendItemSummary($0, item: series, dbItems: &dbItems, tableName: table)
        }
    }

    // MARK: ComicsSummary

    private func getComicsSummary(
        forIDs comicsId: Set<String>?,
        series: Series,
        from table: String
    ) -> EventLoopFuture<[DatabaseUpdateItem]> {
        getComics(comicsId, from: table).flatMapThrowing {
            guard !$0.isEmpty else { return [] }
            var dbItems: [DatabaseUpdateItem] = makeComicsSummary($0, item: series, in: table)
            return appendItemSummary($0, item: series, dbItems: &dbItems, tableName: table)
        }
    }

}
