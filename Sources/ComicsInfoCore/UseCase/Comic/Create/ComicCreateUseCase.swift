//
//  ComicCreateUseCase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 08/01/2021.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import struct Logging.Logger
import Foundation
import NIO

public final class ComicCreateUseCase: CreateUseCase, GetComicLinks, CreateComicLinksSummaries {
    
    public let createRepository: CreateRepository
    private let updateRepository: UpdateRepository
    let characterUseCase: CharacterUseCase
    let seriesUseCase: SeriesUseCase
    let comicUseCase: ComicUseCase

    public init(
        createRepository: CreateRepository,
        updateRepository: UpdateRepository,
        characterUseCase: CharacterUseCase,
        seriesUseCase: SeriesUseCase,
        comicUseCase: ComicUseCase
    ) {
        self.createRepository = createRepository
        self.updateRepository = updateRepository
        self.characterUseCase = characterUseCase
        self.seriesUseCase = seriesUseCase
        self.comicUseCase = comicUseCase
    }
    
    public func create(with criteria: CreateItemCriteria<Comic>) -> EventLoopFuture<Void> {
        getLinks(for: criteria.item, on: criteria.eventLoop, in: criteria.table, logger: criteria.logger)
            .flatMap { [weak self] (characters, series) -> EventLoopFuture<([Character], [Series])> in
                guard let self = self else { return criteria.eventLoop.makeFailedFuture(ComicInfoError.internalServerError) }
                return self.createRepository.create(with: criteria)
                    .map { (characters, series) }
            }
            .flatMap { [weak self] characters, series -> EventLoopFuture<Void> in
                guard let self = self else { return criteria.eventLoop.makeFailedFuture(ComicInfoError.internalServerError) }
                return self.createLinksSummaries(for: criteria.item, characters: characters, series: series, on: criteria.eventLoop, in: criteria.table, logger: criteria.logger)
                    .and(self.updateSummaries(between: characters, and: series, on: criteria.eventLoop, in: criteria.table, logger: criteria.logger))
                    .map { _ in }
            }
            .hop(to: criteria.eventLoop)
    }
    
}

extension ComicCreateUseCase {

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
        
        return updateRepository.updateSummaries(with: charactersSummariesCriteria)
            .and(updateRepository.updateSummaries(with: seriesSummariesCriteria))
            .map { _ in true }
    }
    
}
