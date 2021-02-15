//
//  ComicUpdateUseCase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 07/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Logging.Logger
import Foundation
import NIO

public final class ComicUpdateUseCase: UpdateUseCase, GetComicLinks, CreateComicLinksSummaries {
    
    public let repository: UpdateRepository
    let createRepository: CreateRepository
    let characterUseCase: CharacterUseCase
    let seriesUseCase: SeriesUseCase
    let comicUseCase: ComicUseCase

    public init(
        repository: UpdateRepository,
        createRepository: CreateRepository,
        characterUseCase: CharacterUseCase,
        seriesUseCase: SeriesUseCase,
        comicUseCase: ComicUseCase
    ) {
        self.repository = repository
        self.createRepository = createRepository
        self.characterUseCase = characterUseCase
        self.seriesUseCase = seriesUseCase
        self.comicUseCase = comicUseCase
    }
    
    public func update(with criteria: UpdateItemCriteria<Comic>) -> EventLoopFuture<Void> {
        getLinks(for: criteria.item, on: criteria.eventLoop, in: criteria.table, logger: criteria.logger)
            .flatMap { [weak self] (characters, series) -> EventLoopFuture<(Set<String>, [Character], [Series])> in
                guard let self = self else { return criteria.eventLoop.makeFailedFuture(ComicInfoError.internalServerError) }
                return self.updateItem(with: criteria)
                    .map { ($0, characters, series) }
            }
            .flatMap { [weak self] fields, characters, series in
                guard let self = self else { return criteria.eventLoop.makeFailedFuture(ComicInfoError.internalServerError) }
                return self.createLinksSummaries(for: criteria.item, characters: characters, series: series, on: criteria.eventLoop, in: criteria.table, logger: criteria.logger)
                    .and(self.updateSummaries(for: criteria.item, on: criteria.eventLoop, fields: fields, in: criteria.table, logger: criteria.logger))
                    .and(self.updateSummaries(between: characters, and: series, on: criteria.eventLoop, in: criteria.table, logger: criteria.logger))
                    .map { _ in }
            }
            .hop(to: criteria.eventLoop)
    }
    
    public func getItem(
        withID ID: String,
        on eventLoop: EventLoop,
        from table: String,
        logger: Logger?
    ) -> EventLoopFuture<Comic> {
        comicUseCase.getItem(on: eventLoop, withID: ID, fields: nil, from: table, logger: logger)
    }
    
}

extension ComicUpdateUseCase {
    
    private func updateSummaries(
        for item: Item,
        on eventLoop: EventLoop,
        fields: Set<String>,
        in table: String,
        logger: Logger?
    ) -> EventLoopFuture<Bool> {
        guard item.shouldUpdateExistingSummaries(fields) else { return eventLoop.submit { false } }
        
        let criteria = GetSummariesCriteria(ComicSummary.self, ID: item.itemID, dataSource: .database, table: table, strategy: .itemID, logger: logger)
        
        return comicUseCase.getSummaries(on: eventLoop, with: criteria)
            .flatMap { [weak self] summaries -> EventLoopFuture<Bool> in
                guard let self = self else { return eventLoop.makeFailedFuture(ComicInfoError.internalServerError) }
                guard let summaries = summaries, !summaries.isEmpty else { return eventLoop.submit { false } }

                var updatedSummaries = [ComicSummary]()
                for var summary in summaries {
                    summary.update(with: item)
                    updatedSummaries.append(summary)
                }
            
                let criteria = UpdateSummariesCriteria(items: updatedSummaries, table: table, logger: logger)
                return self.updateSummaries(with: criteria)
                    .map { true }
            }
    }
    
    private func updateSummaries(
        between characters: [Character],
        and series: [Series],
        on eventLoop: EventLoop,
        in table: String,
        logger: Logger?
    ) -> EventLoopFuture<Bool> {
        guard !characters.isEmpty, !series.isEmpty else { return eventLoop.submit { false } }
        var charactersSummaries = [CharacterSummary]()
        var seriesSummaries = [SeriesSummary]()
        
        for character in characters {
            charactersSummaries.append(contentsOf: series.map { CharacterSummary(character, link: $0, count: 1) })
            seriesSummaries.append(contentsOf: series.map { SeriesSummary($0, link: character) })
        }
        
        let charactersSummariesCriteria = UpdateSummariesCriteria(
            items: charactersSummaries,
            table: table,
            logger: logger,
            strategy: .characterInSeries
        )
        let seriesSummariesCriteria = UpdateSummariesCriteria(
            items: seriesSummaries,
            table: table,
            logger: logger
        )
        
        return updateSummaries(with: charactersSummariesCriteria)
            .and(updateSummaries(with: seriesSummariesCriteria))
            .map { _ in true }
    }
    
}
