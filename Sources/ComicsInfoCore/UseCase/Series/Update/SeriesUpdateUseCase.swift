//
//  SeriesUpdateUseCase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 07/01/2021.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import struct Logging.Logger
import Foundation
import NIO

public final class SeriesUpdateUseCase: UpdateUseCase, GetSeriesLinks, CreateSeriesLinksSummaries {

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
    
    public func update(with criteria: UpdateItemCriteria<Series>) -> EventLoopFuture<Series> {
        getLinks(for: criteria.item, on: criteria.eventLoop, in: criteria.table, logger: criteria.logger)
            .flatMap { [weak self] (characters, comics) -> EventLoopFuture<((old: Series, new: Series), [Character], [Comic])> in
                guard let self = self else {
                    return criteria.eventLoop.makeFailedFuture(ComicInfoError.internalServerError)
                }

                return self.updateItem(with: criteria)
                    .map { ($0, characters, comics) }
            }
            .flatMap { [weak self] series, characters, comics in
                guard let self = self else {
                    return criteria.eventLoop.makeFailedFuture(ComicInfoError.internalServerError)
                }

                return self.createLinksSummaries(for: criteria.item, characters: characters, comics: comics, on: criteria.eventLoop, in: criteria.table, logger: criteria.logger)
                    .and(self.updateSummaries(for: criteria.item, on: criteria.eventLoop, fields: criteria.item.updatedFields(old: series.old), in: criteria.table, logger: criteria.logger))
                    .map {
                        var series = series.new
                        series.characters = $0.0?.0
                        series.comics = $0.0?.1
                        return series
                    }
            }
    }
    
    public func getItem(
        withID ID: String,
        on eventLoop: EventLoop,
        from table: String,
        logger: Logger?
    ) -> EventLoopFuture<Series> {
        seriesUseCase.getItem(
            on: eventLoop,
            withID: ID,
            fields: nil,
            from: table,
            logger: logger,
            dataSource: .database
        )
    }
    
}

extension SeriesUpdateUseCase {
    
    private func updateSummaries(
        for item: Item,
        on eventLoop: EventLoop,
        fields: Set<String>,
        limit: Int = .queryLimit,
        in table: String,
        logger: Logger?
    ) -> EventLoopFuture<[SeriesSummary]?> {
        guard item.shouldUpdateExistingSummaries(fields) else { return eventLoop.submit { nil } }

        let criteria = GetSummariesCriteria(
            SeriesSummary.self,
            ID: item.id,
            dataSource: .database,
            limit: limit,
            table: table,
            strategy: .itemID,
            logger: logger
        )

        return seriesUseCase.getSummaries(on: eventLoop, with: criteria)
            .flatMap { [weak self] summaries -> EventLoopFuture<[SeriesSummary]?> in
                guard let self = self else { return eventLoop.makeFailedFuture(ComicInfoError.internalServerError) }
                guard let summaries = summaries, !summaries.isEmpty else { return eventLoop.submit { nil } }

                var updatedSummaries = [SeriesSummary]()
                for var summary in summaries {
                    summary.update(with: item)
                    updatedSummaries.append(summary)
                }

                let criteria = UpdateSummariesCriteria(items: updatedSummaries, table: table, logger: logger)
                return self.updateSummaries(with: criteria)
                    .map { $0 }
            }
    }
    
}
