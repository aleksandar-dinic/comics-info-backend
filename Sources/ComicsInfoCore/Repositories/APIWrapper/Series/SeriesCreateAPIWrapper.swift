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

struct SeriesCreateAPIWrapper: CreateAPIWrapper, CharactersMetadataHandler {

    let characterUseCase: CharacterUseCase<CharacterRepositoryAPIWrapper, InMemoryCacheProvider<Character>>
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
    }

    func create(_ item: Series) -> EventLoopFuture<Void> {
        getCharacters(item.charactersID)
            .flatMapThrowing { createCharactersSummary($0, series: item) }
            .flatMapThrowing { appendSeriesDatabase($0, series: item) }
            .flatMap { repositoryAPIService.createAll($0) }
    }

    private func createCharactersSummary(_ characters: [Character], series: Series) -> [DatabaseItem] {
        guard !characters.isEmpty else { return [] }

        var dbItems = appendCharactersSummary(characters, item: series)
        return appendSeriesSummary(characters, series: series, dbItems: &dbItems)
    }

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

    private func appendSeriesDatabase(_ items: [DatabaseItem], series: Series) -> [DatabaseItem] {
        var items = items

        let seriesDatabase = SeriesDatabase(series: series)
        items.append(encoderService.encode(seriesDatabase, table: .seriesTableName))

        return items
    }

}
