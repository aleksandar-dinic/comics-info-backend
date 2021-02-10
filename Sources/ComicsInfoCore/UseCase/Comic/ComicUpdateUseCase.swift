//
//  ComicUpdateUseCase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 07/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public final class ComicUpdateUseCase: UpdateUseCase, ComicAddSummariesFactory {
    
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
    
    public func getItem(withID ID: String, on eventLoop: EventLoop, from table: String) -> EventLoopFuture<Item> {
        comicUseCase.getItem(on: eventLoop, withID: ID, fields: nil, from: table)
    }

    public func updateSummaries(for item: Item, on eventLoop: EventLoop, in table: String) -> EventLoopFuture<Void> {
        updateSummaries(item.comicSummaryForCharacters, on: eventLoop, in: table)
            .and(updateSummaries(item.characters, on: eventLoop, in: table))
            .and(updateSummaries(item.comicSummaryForSeries, on: eventLoop, in: table))
            .and(updateSummaries(item.series, on: eventLoop, in: table))
            .map { _ in }
    }
    
}

extension ComicUpdateUseCase {
    
    public func updateExistingSummaries(
        for item: Item,
        on eventLoop: EventLoop,
        fields: Set<String>,
        in table: String
    ) -> EventLoopFuture<Bool> {
        guard item.shouldUpdateExistingSummaries(fields) else { return eventLoop.submit { false } }
        return updateCharacterSummaries(for: item, on: eventLoop, in: table)
            .and(updateSeriesSummaries(for: item, on: eventLoop, in: table))
            .map { _ in true }
    }
    
    private func updateCharacterSummaries(
        for item: Item,
        on eventLoop: EventLoop,
        in table: String
    ) -> EventLoopFuture<Bool> {
        let future: EventLoopFuture<[ComicSummary]?> = comicUseCase.getSummaries(on: eventLoop, forID: item.itemID, dataSource: .database, from: table, by: .itemID)
        return future.flatMap { [weak self] summaries -> EventLoopFuture<Bool> in
                guard let self = self else { return eventLoop.makeFailedFuture(ComicInfoError.internalServerError) }
                guard let summaries = summaries else { return eventLoop.submit { false } }

                var updatedSummaries = [ComicSummary]()
                for var summary in summaries {
                    summary.update(with: item)
                    updatedSummaries.append(summary)
                }
                return self.updateSummaries(updatedSummaries, on: eventLoop, in: table)
                    .map { true }
            }
    }
    
    private func updateSeriesSummaries(
        for item: Item,
        on eventLoop: EventLoop,
        in table: String
    ) -> EventLoopFuture<Bool> {
        let future: EventLoopFuture<[ComicSummary]?> = comicUseCase.getSummaries(on: eventLoop, forID: item.itemID, dataSource: .database, from: table, by: .itemID)
        return future.flatMap { [weak self] summaries -> EventLoopFuture<Bool> in
                guard let self = self else { return eventLoop.makeFailedFuture(ComicInfoError.internalServerError) }
                guard let summaries = summaries else { return eventLoop.submit { false } }

                var updatedSummaries = [ComicSummary]()
                for var summary in summaries {
                    summary.update(with: item)
                    updatedSummaries.append(summary)
                }
                return self.updateSummaries(updatedSummaries, on: eventLoop, in: table)
                    .map { true }
            }
    }
    
}
