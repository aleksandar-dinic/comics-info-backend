//
//  ComicCreateUseCase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 08/01/2021.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public final class ComicCreateUseCase: CreateUseCase, GetComicLinks, CreateComicLinksSummaries {
    
    public let createRepository: CreateRepository
    private let updateRepository: UpdateRepository
    let characterUseCase: CharacterUseCase<GetDatabaseProvider, InMemoryCacheProvider<Character>>
    let seriesUseCase: SeriesUseCase<GetDatabaseProvider, InMemoryCacheProvider<Series>>
    let comicUseCase: ComicUseCase<GetDatabaseProvider, InMemoryCacheProvider<Comic>>

    public init(
        createRepository: CreateRepository,
        updateRepository: UpdateRepository,
        characterUseCase: CharacterUseCase<GetDatabaseProvider, InMemoryCacheProvider<Character>>,
        seriesUseCase: SeriesUseCase<GetDatabaseProvider, InMemoryCacheProvider<Series>>,
        comicUseCase: ComicUseCase<GetDatabaseProvider, InMemoryCacheProvider<Comic>>
    ) {
        self.createRepository = createRepository
        self.updateRepository = updateRepository
        self.characterUseCase = characterUseCase
        self.seriesUseCase = seriesUseCase
        self.comicUseCase = comicUseCase
    }
    
    public func create(_ item: Comic, on eventLoop: EventLoop, in table: String) -> EventLoopFuture<Void> {
        getLinks(for: item, on: eventLoop, in: table)
            .flatMap { [weak self] (characters, series) -> EventLoopFuture<([Character], [Series])> in
                guard let self = self else { return eventLoop.makeFailedFuture(ComicInfoError.internalServerError) }
                return self.createRepository.create(item, in: table)
                    .map { (characters, series) }
            }
            .flatMap { [weak self] characters, series -> EventLoopFuture<Void> in
                guard let self = self else { return eventLoop.makeFailedFuture(ComicInfoError.internalServerError) }
                return self.createLinksSummaries(for: item, characters: characters, series: series, on: eventLoop, in: table)
                    .and(self.updateSummaries(between: characters, and: series, on: eventLoop, in: table))
                    .map { _ in }
            }
            .hop(to: eventLoop)
    }
    
}

extension ComicCreateUseCase {

    private func updateSummaries(
        between characters: [Character],
        and series: [Series],
        on eventLoop: EventLoop,
        in table: String
    ) -> EventLoopFuture<Bool> {
        guard !characters.isEmpty, !series.isEmpty else { return eventLoop.submit { false } }
        var charactersSummaries = [CharacterSummary]()
        var seriesSummaries = [SeriesSummary]()
        
        for character in characters {
            charactersSummaries.append(contentsOf: series.map { CharacterSummary(character, link: $0, count: 1) })
            seriesSummaries.append(contentsOf: series.map { SeriesSummary($0, link: character) })
        }
        
        return updateRepository.updateSummaries(charactersSummaries, in: table, strategy: .characterInSeries)
            .and(updateRepository.updateSummaries(seriesSummaries, in: table))
            .map { _ in true }
    }
    
}
