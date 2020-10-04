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

struct CharacterCreateAPIWrapper: CreateAPIWrapper, SeriesMetadataHandler {

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
        seriesUseCase = SeriesUseCaseFactory<InMemoryCacheProvider<Series>>(
            on: eventLoop,
            isLocalServer: LocalServer.isEnabled,
            cacheProvider: LocalServer.seriesInMemoryCache,
            logger: logger
        ).makeUseCase()
    }

    func create(_ item: Character) -> EventLoopFuture<Void> {
        getSeries(item.seriesID)
            .flatMapThrowing { createSeriesSummary($0, character: item) }
            .flatMapThrowing { appendCharacterDatabase($0, character: item) }
            .flatMap { repositoryAPIService.createAll($0) }
    }

    private func createSeriesSummary(_ series: [Series], character: Character) -> [DatabaseItem] {
        guard !series.isEmpty else { return [] }

        var dbItems = appendSeriesSummary(series, item: character)
        return appendCharactersSummary(series, character: character, dbItems: &dbItems)
    }

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

    private func appendCharacterDatabase(_ items: [DatabaseItem], character: Character) -> [DatabaseItem] {
        var items = items

        let characterDatabase = CharacterDatabase(character: character)
        items.append(encoderService.encode(characterDatabase, table: .characterTableName))

        return items
    }

}
