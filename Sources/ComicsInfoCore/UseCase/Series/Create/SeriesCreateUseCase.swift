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
    let characterUseCase: CharacterUseCase<GetDatabaseProvider, InMemoryCacheProvider<Character>>
    let seriesUseCase: SeriesUseCase<GetDatabaseProvider, InMemoryCacheProvider<Series>>
    let comicUseCase: ComicUseCase<GetDatabaseProvider, InMemoryCacheProvider<Comic>>

    public init(
        createRepository: CreateRepository,
        characterUseCase: CharacterUseCase<GetDatabaseProvider, InMemoryCacheProvider<Character>>,
        seriesUseCase: SeriesUseCase<GetDatabaseProvider, InMemoryCacheProvider<Series>>,
        comicUseCase: ComicUseCase<GetDatabaseProvider, InMemoryCacheProvider<Comic>>
    ) {
        self.createRepository = createRepository
        self.characterUseCase = characterUseCase
        self.seriesUseCase = seriesUseCase
        self.comicUseCase = comicUseCase
    }
    
    public func create(_ item: Series, on eventLoop: EventLoop, in table: String) -> EventLoopFuture<Void> {
        getLinks(for: item, on: eventLoop, in: table)
            .flatMap { [weak self] (characters, comics) -> EventLoopFuture<([Character], [Comic])> in
                guard let self = self else { return eventLoop.makeFailedFuture(ComicInfoError.internalServerError) }
                return self.createRepository.create(item, in: table)
                    .map { (characters, comics) }
            }
            .flatMap { [weak self] characters, comics -> EventLoopFuture<Void> in
                guard let self = self else { return eventLoop.makeFailedFuture(ComicInfoError.internalServerError) }
                return self.createLinksSummaries(for: item, characters: characters, comics: comics, on: eventLoop, in: table)
            }
            .hop(to: eventLoop)
    }
    
}
