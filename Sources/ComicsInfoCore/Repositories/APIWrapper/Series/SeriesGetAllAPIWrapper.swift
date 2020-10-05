//
//  SeriesGetAllAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 03/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

struct SeriesGetAllAPIWrapper: GetAllAPIWrapper {

    let repositoryAPIService: RepositoryAPIService
    let decoderService: DecoderService

    func handleItems(_ items: [DatabaseItem]) throws -> [Series] {
        var series: [String: SeriesDatabase] = try handleDatabaseItems(items)

        appendCharactersSummary(items, series: &series)
        appendComicsSummary(items, series: &series)

        return Array(series.mapValues { Series(from: $0) }.values)
    }

    private func appendCharactersSummary(_ items: [DatabaseItem], series: inout [String: SeriesDatabase]) {
        let charactersSummary = handleCharactersSummary(items)

        guard let characters = charactersSummary, !characters.isEmpty else { return }

        for character in characters {
            if series[character.itemID]?.charactersSummary == nil {
                series[character.itemID]?.charactersSummary = []
            }

            series[character.itemID]?.charactersSummary?.append(character)
        }
    }

    private func appendComicsSummary(_ items: [DatabaseItem], series: inout [String: SeriesDatabase]) {
        let comicsSummary = handleComicsSummary(items)

        guard let comics = comicsSummary, !comics.isEmpty else { return }

        for comic in comics {
            if series[comic.itemID]?.comicsSummary == nil {
                series[comic.itemID]?.comicsSummary = []
            }

            series[comic.itemID]?.comicsSummary?.append(comic)
        }
    }

}
