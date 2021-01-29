//
//  CharacterCreateUseCase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 08/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public final class CharacterCreateUseCase<APIWrapper: CreateRepositoryAPIWrapper>: CreateUseCase, CreateSummaryFactory, SeriesSummaryFactory, ComicSummaryFactory where APIWrapper.Item == Character {

    public let repository: CreateRepository<APIWrapper>
    var seriesUseCase: SeriesUseCase<SeriesRepositoryAPIWrapper, InMemoryCacheProvider<Series>>
    var comicUseCase: ComicUseCase<ComicRepositoryAPIWrapper, InMemoryCacheProvider<Comic>>

    public init(
        repository: CreateRepository<APIWrapper>,
        seriesUseCase: SeriesUseCase<SeriesRepositoryAPIWrapper, InMemoryCacheProvider<Series>>,
        comicUseCase: ComicUseCase<ComicRepositoryAPIWrapper, InMemoryCacheProvider<Comic>>
    ) {
        self.repository = repository
        self.seriesUseCase = seriesUseCase
        self.comicUseCase = comicUseCase
    }
    
    public func appendItemSummary(on item: Item, on eventLoop: EventLoop, from table: String) -> EventLoopFuture<Item> {
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
    
    public func createSummaries(for item: Item, on eventLoop: EventLoop, in table: String) -> EventLoopFuture<Void> {
        createSummaries(item.characterSummaryForSeries, on: eventLoop, in: table)
            .and(createSummaries(item.series, on: eventLoop, in: table))
            .and(createSummaries(item.characterSummaryForComics, on: eventLoop, in: table))
            .and(createSummaries(item.comics, on: eventLoop, in: table))
            .flatMap { _ in eventLoop.makeSucceededFuture(()) }
    }

}
