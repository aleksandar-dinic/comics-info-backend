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

struct ComicCreateAPIWrapper: CreateAPIWrapper, CharactersMetadataHandler, SeriesMetadataHandler {

    let characterUseCase: CharacterUseCase<CharacterRepositoryAPIWrapper, InMemoryCacheProvider<Character>>
    let seriesUseCase: SeriesUseCase<SeriesRepositoryAPIWrapper, InMemoryCacheProvider<Series>>
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
        seriesUseCase = SeriesUseCaseFactory<InMemoryCacheProvider<Series>>(
            on: eventLoop,
            isLocalServer: LocalServer.isEnabled,
            cacheProvider: LocalServer.seriesInMemoryCache,
            logger: logger
        ).makeUseCase()
    }

    func create(_ item: Comic) -> EventLoopFuture<Void> {
        createSummaries(for: item).flatMap { repositoryAPIService.createAll($0) }
    }

    private func createSummaries(for comic: Comic) -> EventLoopFuture<[DatabaseItem]> {
        .reduce(
            [createComicDatabase(comic: comic)],
            [
                getCharactersSummary(forIDs: comic.charactersID, comic: comic),
                getSeriesSummary(forIDs: comic.seriesID, comic: comic)
            ],
            on: eventLoop
        ) { $0 + $1 }
    }

    // MARK: CharactersSummary

    private func getCharactersSummary(forIDs charactersID: Set<String>?, comic: Comic) -> EventLoopFuture<[DatabaseItem]> {
        getCharacters(charactersID).flatMapThrowing { appendCharactersSummary($0, comic: comic) }
    }

    private func appendCharactersSummary(_ characters: [Character], comic: Comic) -> [DatabaseItem] {
        guard !characters.isEmpty else { return [] }

        var dbItems = createCharactersSummary(characters, item: comic)
        return appendComicSummary(characters, comic: comic, dbItems: &dbItems)
    }

    // MARK: SeriesSummary

    private func getSeriesSummary(forIDs seriesID: Set<String>?, comic: Comic) -> EventLoopFuture<[DatabaseItem]> {
        getSeries(seriesID).flatMapThrowing { appendSeriesSummary($0, comic: comic) }
    }

    private func appendSeriesSummary(_ series: [Series], comic: Comic) -> [DatabaseItem] {
        guard !series.isEmpty else { return [] }

        var dbItems = createSeriesSummary(series, item: comic)
        return appendComicSummary(series, comic: comic, dbItems: &dbItems)
    }

    // MARK: ComicsSummary

    private func appendComicSummary<Item: Identifiable>(
        _ items: [Item],
        comic: Comic,
        dbItems: inout [DatabaseItem]
    ) -> [DatabaseItem] where Item.ID == String {

        for item in items {
            let comicSummary = ComicSummary(comic, id: item.id, itemName: .getType(from: Item.self))
            dbItems.append(encoderService.encode(comicSummary, table: .comicTableName))
        }

        return dbItems
    }

    // MARK: ComicDatabase

    private func createComicDatabase(comic: Comic) -> DatabaseItem {
        let comicDatabase = ComicDatabase(comic: comic)
        return encoderService.encode(comicDatabase, table: .comicTableName)
    }

}
