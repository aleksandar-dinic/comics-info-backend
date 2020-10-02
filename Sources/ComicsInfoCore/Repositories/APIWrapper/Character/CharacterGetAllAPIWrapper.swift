//
//  CharacterGetAllAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 01/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

struct CharacterGetAllAPIWrapper {

    private let repositoryAPIService: RepositoryAPIService
    private let decoderService: DecoderService

    init(
        repositoryAPIService: RepositoryAPIService,
        decoderService: DecoderService
    ) {
        self.repositoryAPIService = repositoryAPIService
        self.decoderService = decoderService
    }

    func getAllCharacters() -> EventLoopFuture<[Character]> {
        repositoryAPIService.getAll(.characterType)
            .flatMapThrowing { try handleQuery($0) }
    }

    private func handleQuery(_ items: [DatabaseItem]) throws -> [Character] {
        var characters = try handleCharacters(items)

        handleSeries(items, characters: &characters)

        return Array(characters.mapValues { Character(from: $0) }.values)
    }

    private func handleCharacters(_ items: [DatabaseItem]) throws -> [String: CharacterDatabase] {
        var characters = [String: CharacterDatabase]()

        for item in items {
            guard let character: CharacterDatabase = try? decoderService.decode(from: item) else { continue }
            characters[character.itemID] = character
        }

        guard !characters.isEmpty else {
            throw APIError.itemsNotFound(withIDs: nil, itemType: Character.self)
        }

        return characters
    }

    private func handleSeries(_ items: [DatabaseItem], characters: inout [String: CharacterDatabase]) {
        for item in items {
            guard let series: SeriesSummary = try? decoderService.decode(from: item) else { continue }
            if characters[series.itemID]?.seriesSummary == nil {
                characters[series.itemID]?.seriesSummary = []
            }

            characters[series.itemID]?.seriesSummary?.append(series)
        }
    }

}
