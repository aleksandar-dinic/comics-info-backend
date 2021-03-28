//
//  SeriesCreateUseCase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 08/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public final class SeriesCreateUseCase: CreateUseCase, GetSeriesLinks, CreateSeriesLinksSummaries {
    
    public let createRepository: CreateRepository
    let characterUseCase: CharacterUseCase
    let seriesUseCase: SeriesUseCase
    let comicUseCase: ComicUseCase

    public init(
        createRepository: CreateRepository,
        characterUseCase: CharacterUseCase,
        seriesUseCase: SeriesUseCase,
        comicUseCase: ComicUseCase
    ) {
        self.createRepository = createRepository
        self.characterUseCase = characterUseCase
        self.seriesUseCase = seriesUseCase
        self.comicUseCase = comicUseCase
    }
    
    public func create(with criteria: CreateItemCriteria<Series>) -> EventLoopFuture<Series> {
        getLinks(for: criteria.item, on: criteria.eventLoop, in: criteria.table, logger: criteria.logger)
            .flatMap { [weak self] (characters, comics) -> EventLoopFuture<([Character], [Comic])> in
                guard let self = self else { return criteria.eventLoop.makeFailedFuture(ComicInfoError.internalServerError) }
                return self.seriesUseCase.getItem(on: criteria.eventLoop, withID: criteria.item.id, fields: nil, from: criteria.table, logger: criteria.logger)
                    .flatMapThrowing { _ in
                        throw ComicInfoError.itemAlreadyExists(withID: criteria.item.id, itemType: Series.self)
                    }
                    .flatMapErrorThrowing {
                        if case .itemNotFound = $0 as? ComicInfoError {
                            return (characters, comics)
                        }
                        throw $0
                    }
            }
            .flatMap { [weak self] (characters, comics) -> EventLoopFuture<(Series, [Character], [Comic])> in
                guard let self = self else { return criteria.eventLoop.makeFailedFuture(ComicInfoError.internalServerError) }
                return self.createRepository.create(with: criteria)
                    .map { ($0, characters, comics) }
            }
            .flatMap { [weak self] series, characters, comics -> EventLoopFuture<Series> in
                guard let self = self else { return criteria.eventLoop.makeFailedFuture(ComicInfoError.internalServerError) }
                return self.createLinksSummaries(for: criteria.item, characters: characters, comics: comics, on: criteria.eventLoop, in: criteria.table, logger: criteria.logger)
                    .map {
                        var series = series
                        series.characters = $0?.0
                        series.comics = $0?.1
                        return series
                    }
            }
    }
    
}
