//
//  CharacterUpdateUseCase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 07/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public final class CharacterUpdateUseCase: UpdateUseCase, GetCharacterLinks, CreateCharacterLinksSummaries {
    
    public let repository: UpdateRepository
    let createRepository: CreateRepository
    let characterUseCase: CharacterUseCase<GetDatabaseProvider, InMemoryCacheProvider<Character>>
    let seriesUseCase: SeriesUseCase<GetDatabaseProvider, InMemoryCacheProvider<Series>>
    let comicUseCase: ComicUseCase<GetDatabaseProvider, InMemoryCacheProvider<Comic>>

    public init(
        repository: UpdateRepository,
        createRepository: CreateRepository,
        characterUseCase: CharacterUseCase<GetDatabaseProvider, InMemoryCacheProvider<Character>>,
        seriesUseCase: SeriesUseCase<GetDatabaseProvider, InMemoryCacheProvider<Series>>,
        comicUseCase: ComicUseCase<GetDatabaseProvider, InMemoryCacheProvider<Comic>>
    ) {
        self.repository = repository
        self.createRepository = createRepository
        self.characterUseCase = characterUseCase
        self.seriesUseCase = seriesUseCase
        self.comicUseCase = comicUseCase
    }
    
    public func update(_ item: Character, on eventLoop: EventLoop, in table: String) -> EventLoopFuture<Void> {
        getLinks(for: item, on: eventLoop, in: table)
            .flatMap { [weak self] (series, comics) -> EventLoopFuture<(Set<String>, [Series], [Comic])> in
                guard let self = self else { return eventLoop.makeFailedFuture(ComicInfoError.internalServerError) }
                return self.updateItem(item, on: eventLoop, in: table)
                    .map { ($0, series, comics) }
            }
            .flatMap { [weak self] fields, series, comics in
                guard let self = self else { return eventLoop.makeFailedFuture(ComicInfoError.internalServerError) }
                return self.createLinksSummaries(for: item, series: series, comics: comics, on: eventLoop, in: table)
                    .and(self.updateSummaries(for: item, on: eventLoop, fields: fields, in: table))
                    .map { _ in }
            }
            .hop(to: eventLoop)
    }
    
    public func getItem(
        withID ID: String,
        on eventLoop: EventLoop,
        from table: String
    ) -> EventLoopFuture<Character> {
        characterUseCase.getItem(on: eventLoop, withID: ID, fields: nil, from: table)
    }
    
}

extension CharacterUpdateUseCase {
    
    private func updateSummaries(
        for item: Item,
        on eventLoop: EventLoop,
        fields: Set<String>,
        in table: String
    ) -> EventLoopFuture<Bool> {
        guard item.shouldUpdateExistingSummaries(fields) else { return eventLoop.submit { false } }
        
        let criteria = GetSummariesCriteria(CharacterSummary.self, ID: item.itemID, dataSource: .database, table: table, strategy: .itemID)

        return characterUseCase.getSummaries(on: eventLoop, with: criteria)
            .flatMap { [weak self] summaries -> EventLoopFuture<Bool> in
                guard let self = self else { return eventLoop.makeFailedFuture(ComicInfoError.internalServerError) }
                guard let summaries = summaries, !summaries.isEmpty else { return eventLoop.submit { false } }
                
                var updatedSummaries = [CharacterSummary]()
                for var summary in summaries {
                    summary.update(with: item)
                    updatedSummaries.append(summary)
                }
            
                return self.updateSummaries(updatedSummaries, in: table)
                    .map { true }
            }
    }

}
