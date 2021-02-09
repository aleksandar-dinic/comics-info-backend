//
//  ComicCreateUseCase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 08/01/2021.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public final class ComicCreateUseCase: CreateUseCase, CreateSummaryFactory, CharacterSummaryFactory, SeriesSummaryFactory {
    
    public typealias Item = Comic

    public let repository: CreateRepository
    var characterUseCase: CharacterUseCase<GetDatabaseProvider, InMemoryCacheProvider<Character>>
    var seriesUseCase: SeriesUseCase<GetDatabaseProvider, InMemoryCacheProvider<Series>>

    public init(
        repository: CreateRepository,
        characterUseCase: CharacterUseCase<GetDatabaseProvider, InMemoryCacheProvider<Character>>,
        seriesUseCase: SeriesUseCase<GetDatabaseProvider, InMemoryCacheProvider<Series>>
    ) {
        self.repository = repository
        self.characterUseCase = characterUseCase
        self.seriesUseCase = seriesUseCase
    }
    
    public func appendItemSummary(on item: Item, on eventLoop: EventLoop, from table: String) -> EventLoopFuture<Item> {
        getCharacters(on: eventLoop, forIDs: item.charactersID, from: table)
            .and(getSeries(on: eventLoop, forIDs: item.seriesID, from: table))
            .flatMapThrowing { [weak self] (characters, series) in
                guard let self = self else { throw ComicInfoError.internalServerError }
                var item = item

                if !characters.isEmpty {
                    item.characters = self.makeCharacterSummaries(characters, link: item, count: nil)
                    item.comicSummaryForCharacters = self.makeComicSummaries(item, link: characters, number: nil)
                }
                
                if !series.isEmpty {
                    item.series = self.makeSeriesSummaries(series, link: item)
                    item.comicSummaryForSeries = self.makeComicSummaries(item, link: series, number: nil)
                }
                
                return item
            }
    }
    
    public func createSummaries(for item: Item, on eventLoop: EventLoop, in table: String) -> EventLoopFuture<Void> {
        createSummaries(item.comicSummaryForCharacters, on: eventLoop, in: table)
            .and(createSummaries(item.characters, on: eventLoop, in: table))
            .and(createSummaries(item.comicSummaryForSeries, on: eventLoop, in: table))
            .and(createSummaries(item.series, on: eventLoop, in: table))
            .map { _ in }
    }

}
