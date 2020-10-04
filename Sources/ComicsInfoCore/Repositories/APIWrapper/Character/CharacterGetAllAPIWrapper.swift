//
//  CharacterGetAllAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 01/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

struct CharacterGetAllAPIWrapper: GetAllAPIWrapper {

    let repositoryAPIService: RepositoryAPIService
    let decoderService: DecoderService

    func handleItems(_ items: [DatabaseItem]) throws -> [Character] {
        var characters: [String: CharacterDatabase] = try handleDatabaseItems(items)

        appendSeriesSummary(items, characters: &characters)

        return Array(characters.mapValues { Character(from: $0) }.values)
    }

    private func appendSeriesSummary(_ items: [DatabaseItem], characters: inout [String: CharacterDatabase]) {
        let seriesSummary = handleSeriesSummary(items)

        guard let series = seriesSummary, !series.isEmpty else { return }

        for series in series {
            if characters[series.itemID]?.seriesSummary == nil {
                characters[series.itemID]?.seriesSummary = []
            }

            characters[series.itemID]?.seriesSummary?.append(series)
        }
    }

}
