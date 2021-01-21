//
//  ComicGetAllAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 05/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

struct ComicGetAllAPIWrapper: GetAllAPIWrapper {

    let repositoryAPIService: RepositoryAPIService
    let decoderService: DecoderService

    func handleItems(_ items: [DatabaseItem]) throws -> [Comic] {
        var comics: [String: ComicDatabase] = try handleDatabaseItems(items)

        appendCharactersSummary(items, comics: &comics)
        appendSeriesSummary(items, comics: &comics)

        return Array(comics.mapValues { Comic(from: $0) }.values)
    }

    private func appendCharactersSummary(_ items: [DatabaseItem], comics: inout [String: ComicDatabase]) {
        let charactersSummary: [ItemSummary<Character>]? = handleItemSummary(items)

        guard let characters = charactersSummary, !characters.isEmpty else { return }

        for character in characters {
            if comics[character.itemID]?.charactersSummary == nil {
                comics[character.itemID]?.charactersSummary = []
            }

            comics[character.itemID]?.charactersSummary?.append(character)
        }
    }

    private func appendSeriesSummary(_ items: [DatabaseItem], comics: inout [String: ComicDatabase]) {
        let seriesSummary: [ItemSummary<Series>]? = handleItemSummary(items)

        guard let series = seriesSummary, !series.isEmpty else { return }

        for series in series {
            if comics[series.itemID]?.seriesSummary == nil {
                comics[series.itemID]?.seriesSummary = []
            }

            comics[series.itemID]?.seriesSummary?.append(series)
        }
    }

}
