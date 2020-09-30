//
//  SeriesCreateAPIWrapper.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 28/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

struct SeriesCreateAPIWrapper {

    private let characterUseCase: CharacterUseCase<CharacterRepositoryAPIWrapper, InMemoryCacheProvider<Character>>
    private let repositoryAPIService: RepositoryAPIService
    private let encoderService: EncoderService

    init(
        on eventLoop: EventLoop,
        repositoryAPIService: RepositoryAPIService,
        encoderService: EncoderService
    ) {
        self.repositoryAPIService = repositoryAPIService
        self.encoderService = encoderService
        characterUseCase = CharacterUseCaseFactory<InMemoryCacheProvider<Character>>(
            on: eventLoop,
            isLocalServer: LocalServer.isEnabled,
            cacheProvider: LocalServer.characterInMemoryCache
        ).makeUseCase()
    }

    func create(_ item: Series) -> EventLoopFuture<Void> {
        getCharacters(item.charactersID).flatMap { characters in
            var items = [String: [[String: Any]]]()

            let seriesSummary = createSeriesSummary(item, characters: characters)
            items[.seriesTableName, default: []].append(contentsOf: seriesSummary.map { encoderService.encode($0) })

            let charactersSummary = createCharactersSummary(characters, series: item)
            items[.characterTableName, default: []].append(contentsOf: charactersSummary.map { encoderService.encode($0) })

            let seriesDatabase = encoderService.encode(SeriesDatabase(series: item))
            items[.seriesTableName, default: []].append(seriesDatabase)

            return repositoryAPIService.createAll(items)
        }
    }

    private func getCharacters(_ charactersID: Set<String>) -> EventLoopFuture<[Character]> {
        characterUseCase.getAllMetadata(withIDs: charactersID, fromDataSource: .memory)
    }

    private func createCharactersSummary(_ characters: [Character], series: Series) -> [CharacterSummary] {
        characters.map { CharacterSummary($0, id: series.id, itemName: .seriesType) }
    }

    private func createSeriesSummary(_ series: Series, characters: [Character]) -> [SeriesSummary] {
        characters.map { SeriesSummary(series, id: $0.id, itemName: .characterType) }
    }

}
