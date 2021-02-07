//
//  ComicUpdateUseCase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 07/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public final class ComicUpdateUseCase: UpdateUseCase, CharacterSummaryFactory, SeriesSummaryFactory {
    
    public typealias Item = Comic

    public let repository: UpdateRepository
    var characterUseCase: CharacterUseCase<GetDatabaseProvider, InMemoryCacheProvider<Character>>
    var seriesUseCase: SeriesUseCase<GetDatabaseProvider, InMemoryCacheProvider<Series>>
    var comicUseCase: ComicUseCase<GetDatabaseProvider, InMemoryCacheProvider<Comic>>

    public init(
        repository: UpdateRepository,
        characterUseCase: CharacterUseCase<GetDatabaseProvider, InMemoryCacheProvider<Character>>,
        seriesUseCase: SeriesUseCase<GetDatabaseProvider, InMemoryCacheProvider<Series>>,
        comicUseCase: ComicUseCase<GetDatabaseProvider, InMemoryCacheProvider<Comic>>
    ) {
        self.repository = repository
        self.characterUseCase = characterUseCase
        self.seriesUseCase = seriesUseCase
        self.comicUseCase = comicUseCase
    }
    
    public func appendItemSummary(_ item: Item, on eventLoop: EventLoop, from table: String) -> EventLoopFuture<Item> {
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

    public func updateSummaries(for item: Item, on eventLoop: EventLoop, in table: String) -> EventLoopFuture<Void> {
        updateSummaries(item.comicSummaryForCharacters, on: eventLoop, in: table)
            .and(updateSummaries(item.characters, on: eventLoop, in: table))
            .and(updateSummaries(item.comicSummaryForSeries, on: eventLoop, in: table))
            .and(updateSummaries(item.series, on: eventLoop, in: table))
            .flatMap { _ in eventLoop.makeSucceededFuture(()) }
    }
    
}

extension ComicUpdateUseCase {
    
    public func updateExistingSummaries(
        for item: Item,
        on eventLoop: EventLoop,
        fields: Set<String>,
        in table: String
    ) -> EventLoopFuture<Void> {
        guard item.shouldUpdateExistingSummaries(fields) else { return eventLoop.makeSucceededFuture(()) }
        return updateCharacterSummaries(for: item, on: eventLoop, in: table)
            .and(updateSeriesSummaries(for: item, on: eventLoop, in: table))
            .flatMap { _ in eventLoop.makeSucceededFuture(()) }
    }
    
    private func updateCharacterSummaries(
        for item: Item,
        on eventLoop: EventLoop,
        in table: String
    ) -> EventLoopFuture<Void> {
        let future: EventLoopFuture<[ComicSummary<Character>]?> = comicUseCase.getSummaries(on: eventLoop, forID: item.itemID, dataSource: .database, from: table, by: .itemID)
        return future.flatMap { [weak self] summaries -> EventLoopFuture<Void> in
                guard let self = self else { return eventLoop.makeFailedFuture(ComicInfoError.internalServerError) }
                guard let summaries = summaries else { return eventLoop.makeSucceededFuture(()) }

                var updatedSummaries = [ComicSummary<Character>]()
                for var summary in summaries {
                    summary.update(with: item)
                    updatedSummaries.append(summary)
                }
                return self.updateSummaries(updatedSummaries, on: eventLoop, in: table)
            }
    }
    
    private func updateSeriesSummaries(
        for item: Item,
        on eventLoop: EventLoop,
        in table: String
    ) -> EventLoopFuture<Void> {
        let future: EventLoopFuture<[ComicSummary<Series>]?> = comicUseCase.getSummaries(on: eventLoop, forID: item.itemID, dataSource: .database, from: table, by: .itemID)
        return future.flatMap { [weak self] summaries -> EventLoopFuture<Void> in
                guard let self = self else { return eventLoop.makeFailedFuture(ComicInfoError.internalServerError) }
                guard let summaries = summaries else { return eventLoop.makeSucceededFuture(()) }

                var updatedSummaries = [ComicSummary<Series>]()
                for var summary in summaries {
                    summary.update(with: item)
                    updatedSummaries.append(summary)
                }
                return self.updateSummaries(updatedSummaries, on: eventLoop, in: table)
            }
    }
    
}
