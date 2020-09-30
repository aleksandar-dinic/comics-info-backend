//
//  SeriesDatabase.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 28/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

struct SeriesDatabase {

    var id: String {
        String(summaryID.dropFirst("\(String.seriesType)#".count))
    }

    let itemID: String
    let summaryID: String
    let itemName: String

    let popularity: Int
    let title: String
    let description: String?
    let thumbnail: String?
    let startYear: Int?
    let endYear: Int?
    let nextIdentifier: String?
    var charactersSummary: [CharacterSummary]?

    func getCharactersID() -> Set<String> {
        guard let charactersSummary = charactersSummary else { return [] }

        return Set(charactersSummary.compactMap { $0.id })
    }

    func getComicsID() -> Set<String>? {
        nil // TODO:
    }

}

extension SeriesDatabase {

    init(series: Series) {
        itemID = "\(String.seriesType)#\(series.id)"
        summaryID = "\(String.seriesType)#\(series.id)"
        itemName = .seriesType
        popularity = series.popularity
        title = series.title
        description = series.description
        thumbnail = series.thumbnail
        startYear = series.startYear
        endYear = series.endYear
        nextIdentifier = series.nextIdentifier
        charactersSummary = series.characters?.compactMap { CharacterSummary($0, id: series.id, itemName: .seriesType) }
    }

}
