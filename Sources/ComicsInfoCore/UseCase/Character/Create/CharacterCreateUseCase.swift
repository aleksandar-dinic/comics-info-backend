//
//  CharacterCreateUseCase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 08/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public final class CharacterCreateUseCase: CreateUseCase, GetCharacterLinks, CreateCharacterLinksSummaries {
    
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
    
    public func create(with criteria: CreateItemCriteria<Character>) -> EventLoopFuture<Character> {
        getLinks(for: criteria.item, on: criteria.eventLoop, in: criteria.table, logger: criteria.logger)
            .flatMap { [weak self] (series, comics) -> EventLoopFuture<([Series], [Comic])> in
                guard let self = self else { return criteria.eventLoop.makeFailedFuture(ComicInfoError.internalServerError) }
                return self.characterUseCase.getItem(on: criteria.eventLoop, withID: criteria.item.id, fields: nil, from: criteria.table, logger: criteria.logger)
                    .flatMapThrowing { _ in
                        throw ComicInfoError.itemAlreadyExists(withID: criteria.item.id, itemType: Character.self)
                    }
                    .flatMapErrorThrowing {
                        if case .itemNotFound = $0 as? ComicInfoError {
                            return (series, comics)
                        }
                        throw $0
                    }
            }
            .flatMap { [weak self] (series, comics) -> EventLoopFuture<(Character, [Series], [Comic])> in
                guard let self = self else { return criteria.eventLoop.makeFailedFuture(ComicInfoError.internalServerError) }
                return self.createRepository.create(with: criteria)
                    .map { ($0, series, comics) }
            }
            .flatMap { [weak self] character, series, comics in
                guard let self = self else { return criteria.eventLoop.makeFailedFuture(ComicInfoError.internalServerError) }
                return self.createLinksSummaries(for: criteria.item, series: series, comics: comics, on: criteria.eventLoop, in: criteria.table, logger: criteria.logger)
                    .map {
                        var character = character
                        character.series = $0?.0
                        character.comics = $0?.1
                        return character
                    }
            }
    }
    
}
