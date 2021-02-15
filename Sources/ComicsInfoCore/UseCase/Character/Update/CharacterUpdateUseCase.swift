//
//  CharacterUpdateUseCase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 07/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Logging.Logger
import Foundation
import NIO

public final class CharacterUpdateUseCase: UpdateUseCase, GetCharacterLinks, CreateCharacterLinksSummaries {
    
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
    
    public func update(with criteria: UpdateItemCriteria<Character>) -> EventLoopFuture<Void> {
        getLinks(for: criteria.item, on: criteria.eventLoop, in: criteria.table, logger: criteria.logger)
            .flatMap { [weak self] (series, comics) -> EventLoopFuture<(Set<String>, [Series], [Comic])> in
                guard let self = self else { return criteria.eventLoop.makeFailedFuture(ComicInfoError.internalServerError) }
                return self.updateItem(with: criteria)
                    .map { ($0, series, comics) }
            }
            .flatMap { [weak self] fields, series, comics in
                guard let self = self else { return criteria.eventLoop.makeFailedFuture(ComicInfoError.internalServerError) }
                return self.createLinksSummaries(for: criteria.item, series: series, comics: comics, on: criteria.eventLoop, in: criteria.table, logger: criteria.logger)
                    .and(self.updateSummaries(for: criteria.item, on: criteria.eventLoop, fields: fields, in: criteria.table, logger: criteria.logger))
                    .map { _ in }
            }
            .hop(to: criteria.eventLoop)
    }
    
    public func getItem(
        withID ID: String,
        on eventLoop: EventLoop,
        from table: String,
        logger: Logger?
    ) -> EventLoopFuture<Character> {
        characterUseCase.getItem(on: eventLoop, withID: ID, fields: nil, from: table, logger: logger)
    }
    
}

extension CharacterUpdateUseCase {
    
    private func updateSummaries(
        for item: Item,
        on eventLoop: EventLoop,
        fields: Set<String>,
        in table: String,
        logger: Logger?
    ) -> EventLoopFuture<Bool> {
        guard item.shouldUpdateExistingSummaries(fields) else { return eventLoop.submit { false } }
        
        let criteria = GetSummariesCriteria(CharacterSummary.self, ID: item.itemID, dataSource: .database, table: table, strategy: .itemID, logger: logger)

        return characterUseCase.getSummaries(on: eventLoop, with: criteria)
            .flatMap { [weak self] summaries -> EventLoopFuture<Bool> in
                guard let self = self else { return eventLoop.makeFailedFuture(ComicInfoError.internalServerError) }
                guard let summaries = summaries, !summaries.isEmpty else { return eventLoop.submit { false } }
                
                var updatedSummaries = [CharacterSummary]()
                for var summary in summaries {
                    summary.update(with: item)
                    updatedSummaries.append(summary)
                }
            
                let criteria = UpdateSummariesCriteria(items: updatedSummaries, table: table, logger: logger)
                return self.updateSummaries(with: criteria)
                    .map { true }
            }
    }

}
