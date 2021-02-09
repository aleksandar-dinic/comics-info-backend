//
//  CharacterUpdateUseCase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 07/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public final class CharacterUpdateUseCase: UpdateUseCase, CharacterSummaryFactory, SeriesSummaryFactory, ComicSummaryFactory {
    
    public typealias Item = Character
    
    public let repository: UpdateRepository
    let characterUseCase: CharacterUseCase<GetDatabaseProvider, InMemoryCacheProvider<Character>>
    let seriesUseCase: SeriesUseCase<GetDatabaseProvider, InMemoryCacheProvider<Series>>
    let comicUseCase: ComicUseCase<GetDatabaseProvider, InMemoryCacheProvider<Comic>>

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
    
    public func appendItemSummary(
        _ item: Item,
        on eventLoop: EventLoop,
        from table: String
    ) -> EventLoopFuture<Item> {
        getSeries(on: eventLoop, forIDs: item.seriesID, from: table)
            .and(getComics(on: eventLoop, forIDs: item.comicsID, from: table))
            .flatMapThrowing { [weak self] (series, comics) in
                guard let self = self else { throw ComicInfoError.internalServerError }
                var item = item

                if !series.isEmpty {
                    item.series = self.makeSeriesSummaries(series, link: item)
                    item.characterSummaryForSeries = self.makeCharacterSummaries(item, link: series, count: nil)
                }
                    
                if !comics.isEmpty {
                    item.comics = self.makeComicSummaries(comics, link: item, number: nil)
                    item.characterSummaryForComics = self.makeCharacterSummaries(item, link: comics, count: nil)
                }
                
                return item
            }
    }
    
    public func getItem(withID ID: String, on eventLoop: EventLoop, from table: String) -> EventLoopFuture<Item> {
        characterUseCase.getItem(on: eventLoop, withID: ID, fields: nil, from: table)
    }
    
    public func updateSummaries(for item: Item, on eventLoop: EventLoop, in table: String) -> EventLoopFuture<Void> {
        updateSummaries(item.characterSummaryForSeries, on: eventLoop, in: table)
            .and(updateSummaries(item.series, on: eventLoop, in: table))
            .and(updateSummaries(item.characterSummaryForComics, on: eventLoop, in: table))
            .and(updateSummaries(item.comics, on: eventLoop, in: table))
            .map { _ in }
    }

}

extension CharacterUpdateUseCase {
    
    public func updateExistingSummaries(
        for item: Item,
        on eventLoop: EventLoop,
        fields: Set<String>,
        in table: String
    ) -> EventLoopFuture<Bool> {
        guard item.shouldUpdateExistingSummaries(fields) else { return eventLoop.submit { false } }
        return updateSeriesSummaries(for: item, on: eventLoop, in: table)
            .and(updateComicSummaries(for: item, on: eventLoop, in: table))
            .map { _ in true }
    }
    
    private func updateSeriesSummaries(
        for item: Item,
        on eventLoop: EventLoop,
        in table: String
    ) -> EventLoopFuture<Bool> {
        let future: EventLoopFuture<[CharacterSummary<Series>]?> = characterUseCase.getSummaries(
            on: eventLoop,
            forID: item.itemID,
            dataSource: .database,
            from: table,
            by: .itemID
        )
        return future.flatMap { [weak self] summaries -> EventLoopFuture<Bool> in
                guard let self = self else { return eventLoop.makeFailedFuture(ComicInfoError.internalServerError) }
                guard let summaries = summaries else { return eventLoop.submit { false } }
                
                var updatedSummaries = [CharacterSummary<Series>]()
                for var summary in summaries {
                    summary.update(with: item)
                    updatedSummaries.append(summary)
                }
                return self.updateSummaries(updatedSummaries, on: eventLoop, in: table)
                    .map { true }
            }
    }
    
    private func updateComicSummaries(
        for item: Item,
        on eventLoop: EventLoop,
        in table: String
    ) -> EventLoopFuture<Bool> {
        let future: EventLoopFuture<[CharacterSummary<Comic>]?> = characterUseCase.getSummaries(
            on: eventLoop,
            forID: item.itemID,
            dataSource: .database,
            from: table,
            by: .itemID
        )
        return future.flatMap { [weak self] summaries -> EventLoopFuture<Bool> in
                guard let self = self else { return eventLoop.makeFailedFuture(ComicInfoError.internalServerError) }
                guard let summaries = summaries else { return eventLoop.submit { false } }

                var updatedSummaries = [CharacterSummary<Comic>]()
                for var summary in summaries {
                    summary.update(with: item)
                    updatedSummaries.append(summary)
                }
                return self.updateSummaries(updatedSummaries, on: eventLoop, in: table)
                    .map { true }
            }
    }
    
}
