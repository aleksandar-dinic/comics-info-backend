//
//  SeriesCreateUseCase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 08/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public final class SeriesCreateUseCase<APIWrapper: CreateRepositoryAPIWrapper>: CreateUseCase, CreateSummaryFactory, CharacterSummaryFactory, ComicSummaryFactory where APIWrapper.Item == Series {

    public let repository: CreateRepository<APIWrapper>
    var characterUseCase: CharacterUseCase<CharacterRepositoryAPIWrapper, InMemoryCacheProvider<Character>>
    var comicUseCase: ComicUseCase<ComicRepositoryAPIWrapper, InMemoryCacheProvider<Comic>>

    public init(
        repository: CreateRepository<APIWrapper>,
        characterUseCase: CharacterUseCase<CharacterRepositoryAPIWrapper, InMemoryCacheProvider<Character>>,
        comicUseCase: ComicUseCase<ComicRepositoryAPIWrapper, InMemoryCacheProvider<Comic>>
    ) {
        self.repository = repository
        self.characterUseCase = characterUseCase
        self.comicUseCase = comicUseCase
    }
    
    public func appendItemSummary(on item: Item, on eventLoop: EventLoop, from table: String) -> EventLoopFuture<Item> {
        getCharacters(on: eventLoop, forIDs: item.charactersID, from: table)
            .and(getComics(on: eventLoop, forIDs: item.comicsID, from: table))
            .flatMapThrowing { [weak self] (characters, comics) in
                guard let self = self else { throw APIError.internalServerError }
                var item = item

                if !characters.isEmpty {
                    item.characters = self.makeCharacterSummaries(characters, link: item, count: nil)
                    item.seriesSummaryForCharacters = self.makeSeriesSummaries(item, link: characters)
                }
                
                if !comics.isEmpty {
                    item.comics = self.makeComicSummaries(comics, link: item, number: nil)
                    item.seriesSummaryForComics = self.makeSeriesSummaries(item, link: comics)
                }
                
                return item
            }
    }
    
    public func createSummaries(for item: Item, on eventLoop: EventLoop, in table: String) -> EventLoopFuture<Void> {
        createSummaries(item.seriesSummaryForCharacters, on: eventLoop, in: table)
            .and(createSummaries(item.characters, on: eventLoop, in: table))
            .and(createSummaries(item.seriesSummaryForComics, on: eventLoop, in: table))
            .and(createSummaries(item.comics, on: eventLoop, in: table))
            .flatMap { _ in eventLoop.makeSucceededFuture(()) }
    }

}
