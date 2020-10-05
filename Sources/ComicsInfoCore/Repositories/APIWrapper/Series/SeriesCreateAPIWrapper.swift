//
//  SeriesCreateAPIWrapper.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 28/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Logging
import Foundation
import NIO

struct SeriesCreateAPIWrapper: CreateAPIWrapper, CharactersMetadataHandler, ComicsMetadataHandler {

    let characterUseCase: CharacterUseCase<CharacterRepositoryAPIWrapper, InMemoryCacheProvider<Character>>
    let comicUseCase: ComicUseCase<ComicRepositoryAPIWrapper, InMemoryCacheProvider<Comic>>
    let repositoryAPIService: RepositoryAPIService
    let encoderService: EncoderService
    let eventLoop: EventLoop

    init(
        on eventLoop: EventLoop,
        repositoryAPIService: RepositoryAPIService,
        encoderService: EncoderService,
        logger: Logger
    ) {
        self.repositoryAPIService = repositoryAPIService
        self.encoderService = encoderService
        self.eventLoop = eventLoop
        characterUseCase = CharacterUseCaseFactory<InMemoryCacheProvider<Character>>(
            on: eventLoop,
            isLocalServer: LocalServer.isEnabled,
            cacheProvider: LocalServer.characterInMemoryCache,
            logger: logger
        ).makeUseCase()
        comicUseCase = ComicUseCaseFactory<InMemoryCacheProvider<Comic>>(
            on: eventLoop,
            isLocalServer: LocalServer.isEnabled,
            cacheProvider: LocalServer.comicInMemoryCache,
            logger: logger
        ).makeUseCase()
    }

    func create(_ item: Series) -> EventLoopFuture<Void> {
        createSummaries(for: item)
            .flatMap { repositoryAPIService.createAll($0) }
    }

    private func createSummaries(for series: Series) -> EventLoopFuture<[DatabaseItem]> {
        .reduce(
            [createSeriesDatabase(series: series)],
            [
                getCharactersSummary(forIDs: series.charactersID, series: series),
                getComicsSummary(forIDs: series.comicsID, series: series)
            ],
            on: eventLoop
        ) { $0 + $1 }
    }

    // MARK: CharactersSummary

    private func getCharactersSummary(forIDs charactersID: Set<String>?, series: Series) -> EventLoopFuture<[DatabaseItem]> {
        getCharacters(charactersID).flatMapThrowing { appendCharactersSummary($0, series: series) }
    }

    private func appendCharactersSummary(_ characters: [Character], series: Series) -> [DatabaseItem] {
        guard !characters.isEmpty else { return [] }

        var dbItems = createCharactersSummary(characters, item: series)
        return appendSeriesSummary(characters, series: series, dbItems: &dbItems)
    }

    // MARK: ComicsSummary

    private func getComicsSummary(forIDs comicsId: Set<String>?, series: Series) -> EventLoopFuture<[DatabaseItem]> {
        getComics(comicsId).flatMapThrowing { appendComicsSummary($0, series: series) }
    }

    private func appendComicsSummary(_ comics: [Comic], series: Series) -> [DatabaseItem] {
        guard !comics.isEmpty else { return [] }

        var dbItems = createComicsSummary(comics, item: series)
        return appendSeriesSummary(comics, series: series, dbItems: &dbItems)
    }

    // MARK: SeriesSummary

    private func appendSeriesSummary<Item: Identifiable>(
        _ items: [Item],
        series: Series,
        dbItems: inout [DatabaseItem]
    ) -> [DatabaseItem] where Item.ID == String {

        for item in items {
            let seriesSummary = SeriesSummary(series, id: item.id, itemName: .getType(from: Item.self))
            dbItems.append(encoderService.encode(seriesSummary, table: .seriesTableName))
        }

        return dbItems
    }

    // MARK: SeriesDatabase

    private func createSeriesDatabase(series: Series) -> DatabaseItem {
        let seriesDatabase = SeriesDatabase(series: series)
        return encoderService.encode(seriesDatabase, table: .seriesTableName)
    }

}
