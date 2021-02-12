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
    
    public func create(_ item: Character, on eventLoop: EventLoop, in table: String) -> EventLoopFuture<Void> {
        getLinks(for: item, on: eventLoop, in: table)
            .flatMap { [weak self] (series, comics) -> EventLoopFuture<([Series], [Comic])> in
                guard let self = self else { return eventLoop.makeFailedFuture(ComicInfoError.internalServerError) }
                return self.createRepository.create(item, in: table)
                    .map { (series, comics) }
            }
            .flatMap { [weak self] series, comics in
                guard let self = self else { return eventLoop.makeFailedFuture(ComicInfoError.internalServerError) }
                return self.createLinksSummaries(for: item, series: series, comics: comics, on: eventLoop, in: table)
            }
            .hop(to: eventLoop)
    }
    
}
