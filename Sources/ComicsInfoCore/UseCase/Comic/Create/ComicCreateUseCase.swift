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

public final class ComicCreateUseCase: CreateUseCase, GetComicLinks, CreateComicLinksSummaries, GetCharacterSummariesForSeries {
    
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
    
    public func create(with criteria: CreateItemCriteria<Comic>) -> EventLoopFuture<Comic> {
        getLinks(for: criteria.item, on: criteria.eventLoop, in: criteria.table, logger: criteria.logger)
            .flatMap { [weak self] (characters, series) -> EventLoopFuture<(Comic, [Character], [Series])> in
                guard let self = self else { return criteria.eventLoop.makeFailedFuture(ComicInfoError.internalServerError) }
                return self.createRepository.create(with: criteria)
                    .map { ($0, characters, series) }
            }
            .flatMap { [weak self] comic, characters, series -> EventLoopFuture<(Comic, [Character], [Series])> in
                guard let self = self else { return criteria.eventLoop.makeFailedFuture(ComicInfoError.internalServerError) }
                return self.createLinksSummaries(for: criteria.item, characters: characters, series: series, on: criteria.eventLoop, in: criteria.table, logger: criteria.logger)
                    .map {
                        var comic = comic
                        comic.characters = $0?.0
                        comic.series = $0?.1
                        return (comic, characters, series)
                    }
            }
            .flatMap { [weak self] comic, characters, series in
                guard let self = self else { return criteria.eventLoop.makeFailedFuture(ComicInfoError.internalServerError) }
                return self.getCharacterSummariesForSeries(characters: characters, series: series, on: criteria.eventLoop, from: criteria.table, logger: criteria.logger)
                    .flatMap {
                        self.updateSummaries(between: characters, and: series, characterSummaries: $0, on: criteria.eventLoop, in: criteria.table, logger: criteria.logger)
                    }
                    .map { _ in comic }
            }
    }
    
}

extension ComicCreateUseCase {

    private func updateSummaries(
        between characters: [Character],
        and series: [Series],
        characterSummaries: [CharacterSummary]?,
        on eventLoop: EventLoop,
        in table: String,
        logger: Logger?
    ) -> EventLoopFuture<Bool> {
        guard !characters.isEmpty, !series.isEmpty else { return eventLoop.submit { false } }
        
        let (charactersSummaries, seriesSummaries) = getUpdateSummariesCriteria(
            characters: characters,
            series: series,
            characterSummaries: characterSummaries,
            table: table,
            logger: logger
        )
        
        return updateRepository.updateSummaries(with: charactersSummaries)
            .and(updateRepository.updateSummaries(with: seriesSummaries))
            .map { _ in true }
    }
    
}
