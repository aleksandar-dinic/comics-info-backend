//
//  ComicUpdateUseCase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 07/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public final class ComicUpdateUseCase<APIWrapper: UpdateRepositoryAPIWrapper>: UpdateUseCase, CharacterSummaryFactory, SeriesSummaryFactory where APIWrapper.Item == Comic {

    public let repository: UpdateRepository<APIWrapper>
    var characterUseCase: CharacterUseCase<CharacterRepositoryAPIWrapper, InMemoryCacheProvider<Character>>
    var seriesUseCase: SeriesUseCase<SeriesRepositoryAPIWrapper, InMemoryCacheProvider<Series>>
    var comicUseCase: ComicUseCase<ComicRepositoryAPIWrapper, InMemoryCacheProvider<Comic>>

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
    
    public func appendItemSummary(_ item: Item, on eventLoop: EventLoop, from table: String) -> EventLoopFuture<Item> {
        getCharacters(on: eventLoop, forIDs: item.charactersID, from: table)
            .and(getSeries(on: eventLoop, forIDs: item.seriesID, from: table))
            .flatMapThrowing { [weak self] (characters, series) in
                guard let self = self else { throw APIError.internalServerError }
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
        comicUseCase.getSummaries(ComicSummary<Character>.self, on: eventLoop, forID: item.id, dataSource: .database, from: table)
            .flatMap { [weak self] summaries -> EventLoopFuture<Void> in
                guard let self = self else { return eventLoop.makeFailedFuture(APIError.internalServerError) }
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
        comicUseCase.getSummaries(ComicSummary<Series>.self, on: eventLoop, forID: item.id, dataSource: .database, from: table)
            .flatMap { [weak self] summaries -> EventLoopFuture<Void> in
                guard let self = self else { return eventLoop.makeFailedFuture(APIError.internalServerError) }
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
