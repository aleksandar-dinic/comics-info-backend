//
//  SeriesUpdateUseCase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 07/01/2021.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public final class SeriesUpdateUseCase<APIWrapper: UpdateRepositoryAPIWrapper>: UpdateUseCase, CharacterSummaryFactory, SeriesSummaryFactory, ComicSummaryFactory where APIWrapper.Item == Series {

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
            .and(getComics(on: eventLoop, forIDs: item.comicsID, from: table))
            .flatMapThrowing { [weak self] (characters, comics) in
                guard let self = self else { throw APIError.internalServerError }
                var item = item
                
                if !characters.isEmpty {
                    item.characters = self.makeCharacterSummaries(characters, link: item, count: nil)
                    item.seriesSummaryForCharacters = self.makeSeriesSummaries(item, link: characters)
                }
                
                if !comics.isEmpty {
                    item.comics = self.makeComicSummaries(comics, link: item, number: nil)
                    item.seriesSummaryForComics = self.makeSeriesSummaries(item, link: comics)
                }
                
                return item
            }
    }
    
    public func updateSummaries(for item: Item, on eventLoop: EventLoop, in table: String) -> EventLoopFuture<Void> {
        updateSummaries(item.seriesSummaryForCharacters, on: eventLoop, in: table)
            .and(updateSummaries(item.characters, on: eventLoop, in: table))
            .and(updateSummaries(item.seriesSummaryForComics, on: eventLoop, in: table))
            .and(updateSummaries(item.comics, on: eventLoop, in: table))
            .flatMap { _ in eventLoop.makeSucceededFuture(()) }
    }

}

extension SeriesUpdateUseCase {
    
    public func updateExistingSummaries(
        for item: Item,
        on eventLoop: EventLoop,
        fields: Set<String>,
        in table: String
    ) -> EventLoopFuture<Void> {
        guard item.shouldUpdateExistingSummaries(fields) else { return eventLoop.makeSucceededFuture(()) }
        return updateCharacterSummaries(for: item, on: eventLoop, in: table)
            .and(updateComicSummaries(for: item, on: eventLoop, in: table))
            .flatMap { _ in eventLoop.makeSucceededFuture(()) }
    }
    
    private func updateCharacterSummaries(
        for item: Item,
        on eventLoop: EventLoop,
        in table: String
    ) -> EventLoopFuture<Void> {
        seriesUseCase.getSummaries(SeriesSummary<Character>.self, on: eventLoop, forID: item.id, dataSource: .database, from: table)
            .flatMap { [weak self] summaries -> EventLoopFuture<Void> in
                guard let self = self else { return eventLoop.makeFailedFuture(APIError.internalServerError) }
                guard let summaries = summaries else { return eventLoop.makeSucceededFuture(()) }

                var updatedSummaries = [SeriesSummary<Character>]()
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
        seriesUseCase.getSummaries(SeriesSummary<Comic>.self, on: eventLoop, forID: item.id, dataSource: .database, from: table)
            .flatMap { [weak self] summaries -> EventLoopFuture<Void> in
                guard let self = self else { return eventLoop.makeFailedFuture(APIError.internalServerError) }
                guard let summaries = summaries else { return eventLoop.makeSucceededFuture(()) }

                var updatedSummaries = [SeriesSummary<Comic>]()
                for var summary in summaries {
                    summary.update(with: item)
                    updatedSummaries.append(summary)
                }
                return self.updateSummaries(updatedSummaries, on: eventLoop, in: table)
            }
    }
    
}
