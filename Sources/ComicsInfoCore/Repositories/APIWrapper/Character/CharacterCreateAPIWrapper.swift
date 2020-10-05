//
//  CharacterCreateAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 02/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Logging
import Foundation
import NIO

struct CharacterCreateAPIWrapper: CreateAPIWrapper, SeriesMetadataHandler, ComicsMetadataHandler {

    let seriesUseCase: SeriesUseCase<SeriesRepositoryAPIWrapper, InMemoryCacheProvider<Series>>
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
        seriesUseCase = SeriesUseCaseFactory<InMemoryCacheProvider<Series>>(
            on: eventLoop,
            isLocalServer: LocalServer.isEnabled,
            cacheProvider: LocalServer.seriesInMemoryCache,
            logger: logger
        ).makeUseCase()
        comicUseCase = ComicUseCaseFactory<InMemoryCacheProvider<Comic>>(
            on: eventLoop,
            isLocalServer: LocalServer.isEnabled,
            cacheProvider: LocalServer.comicInMemoryCache,
            logger: logger
        ).makeUseCase()
    }

    func create(_ item: Character) -> EventLoopFuture<Void> {
        createSummaries(for: item)
            .flatMap { repositoryAPIService.createAll($0) }
    }

    private func createSummaries(for character: Character) -> EventLoopFuture<[DatabaseItem]> {
        .reduce(
            [createCharacterDatabase(character: character)],
            [
                getSeriesSummary(forIDs: character.seriesID, character: character),
                getComicsSummary(forIDs: character.comicsID, character: character)
            ],
            on: eventLoop
        ) { $0 + $1 }
    }

    // MARK: SeriesSummary

    private func getSeriesSummary(forIDs seriesID: Set<String>?, character: Character) -> EventLoopFuture<[DatabaseItem]> {
        getSeries(seriesID).flatMapThrowing { appendSeriesSummary($0, character: character) }
    }

    private func appendSeriesSummary(_ series: [Series], character: Character) -> [DatabaseItem] {
        guard !series.isEmpty else { return [] }

        var dbItems = createSeriesSummary(series, item: character)
        return appendCharactersSummary(series, character: character, dbItems: &dbItems)
    }

    // MARK: ComicsSummary

    private func getComicsSummary(forIDs comicsId: Set<String>?, character: Character) -> EventLoopFuture<[DatabaseItem]> {
        getComics(comicsId).flatMapThrowing { appendComicsSummary($0, character: character) }
    }

    private func appendComicsSummary(_ comics: [Comic], character: Character) -> [DatabaseItem] {
        guard !comics.isEmpty else { return [] }

        var dbItems = createComicsSummary(comics, item: character)
        return appendCharactersSummary(comics, character: character, dbItems: &dbItems)
    }

    // MARK: CharactersSummary

    private func appendCharactersSummary<Item: Identifiable>(
        _ items: [Item],
        character: Character,
        dbItems: inout [DatabaseItem]
    ) -> [DatabaseItem] where Item.ID == String {

        for item in items {
            let characterSummary = CharacterSummary(character, id: item.id, itemName: .getType(from: Item.self))
            dbItems.append(encoderService.encode(characterSummary, table: .characterTableName))
        }

        return dbItems
    }

    // MARK: CharacterDatabase

    private func createCharacterDatabase(character: Character) -> DatabaseItem {
        let characterDatabase = CharacterDatabase(character: character)
        return encoderService.encode(characterDatabase, table: .characterTableName)
    }

}
