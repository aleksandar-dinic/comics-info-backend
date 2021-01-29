//
//  CharacterUpdateUseCase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 07/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public final class CharacterUpdateUseCase<APIWrapper: UpdateRepositoryAPIWrapper>: UpdateUseCase, CharacterSummaryFactory, SeriesSummaryFactory, ComicSummaryFactory where APIWrapper.Item == Character {
    
    public let repository: UpdateRepository<APIWrapper>
    let characterUseCase: CharacterUseCase<CharacterRepositoryAPIWrapper, InMemoryCacheProvider<Character>>
    let seriesUseCase: SeriesUseCase<SeriesRepositoryAPIWrapper, InMemoryCacheProvider<Series>>
    let comicUseCase: ComicUseCase<ComicRepositoryAPIWrapper, InMemoryCacheProvider<Comic>>

    public init(
        repository: UpdateRepository<APIWrapper>,
        characterUseCase: CharacterUseCase<CharacterRepositoryAPIWrapper, InMemoryCacheProvider<Character>>,
        seriesUseCase: SeriesUseCase<SeriesRepositoryAPIWrapper, InMemoryCacheProvider<Series>>,
        comicUseCase: ComicUseCase<ComicRepositoryAPIWrapper, InMemoryCacheProvider<Comic>>
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
                guard let self = self else { throw APIError.internalServerError }
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
    
    public func updateSummaries(for item: Item, on eventLoop: EventLoop, in table: String) -> EventLoopFuture<Void> {
        updateSummaries(item.characterSummaryForSeries, on: eventLoop, in: table)
            .and(updateSummaries(item.series, on: eventLoop, in: table))
            .and(updateSummaries(item.characterSummaryForComics, on: eventLoop, in: table))
            .and(updateSummaries(item.comics, on: eventLoop, in: table))
            .flatMap { _ in eventLoop.makeSucceededFuture(()) }
    }

}

extension CharacterUpdateUseCase {
    
    public func updateExistingSummaries(
        for item: Item,
        on eventLoop: EventLoop,
        fields: Set<String>,
        in table: String
    ) -> EventLoopFuture<Void> {
        guard item.shouldUpdateExistingSummaries(fields) else { return eventLoop.makeSucceededFuture(()) }
        return updateSeriesSummaries(for: item, on: eventLoop, in: table)
            .and(updateComicSummaries(for: item, on: eventLoop, in: table))
            .flatMap { _ in eventLoop.makeSucceededFuture(()) }
    }
    
    private func updateSeriesSummaries(
        for item: Item,
        on eventLoop: EventLoop,
        in table: String
    ) -> EventLoopFuture<Void> {
        characterUseCase.getSummaries(CharacterSummary<Series>.self, forID: item.id, dataSource: .database, from: table)
            .flatMap { [weak self] summaries -> EventLoopFuture<Void> in
                guard let self = self else { return eventLoop.makeFailedFuture(APIError.internalServerError) }
                guard let summaries = summaries else { return eventLoop.makeSucceededFuture(()) }
                
                var updatedSummaries = [CharacterSummary<Series>]()
                for var summary in summaries {
                    summary.update(with: item)
                    updatedSummaries.append(summary)
                }
                return self.updateSummaries(updatedSummaries, on: eventLoop, in: table)
            }
    }
    
    private func updateComicSummaries(
        for item: Item,
        on eventLoop: EventLoop,
        in table: String
    ) -> EventLoopFuture<Void> {
        characterUseCase.getSummaries(CharacterSummary<Comic>.self, forID: item.id, dataSource: .database, from: table)
            .flatMap { [weak self] summaries -> EventLoopFuture<Void> in
                guard let self = self else { return eventLoop.makeFailedFuture(APIError.internalServerError) }
                guard let summaries = summaries else { return eventLoop.makeSucceededFuture(()) }

                var updatedSummaries = [CharacterSummary<Comic>]()
                for var summary in summaries {
                    summary.update(with: item)
                    updatedSummaries.append(summary)
                }
                return self.updateSummaries(updatedSummaries, on: eventLoop, in: table)
            }
    }
    
}
