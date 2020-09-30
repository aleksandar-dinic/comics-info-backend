//
//  CharacterDatabase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 28/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

struct CharacterDatabase {

    var id: String {
        String(summaryID.dropFirst("\(String.characterType)#".count))
    }

    let itemID: String
    let summaryID: String
    let itemName: String

    let popularity: Int
    let name: String
    let description: String?
    let thumbnail: String?
    var seriesSummary: [SeriesSummary]?

    func getSeriesID() -> Set<String>? {
        guard let seriesSummary = seriesSummary else { return nil }

        return Set(seriesSummary.compactMap { $0.id })
    }

    func getComicsID() -> Set<String>? {
        nil // TODO:
    }

}

extension CharacterDatabase {

    init(character: Character) {
        itemID = "\(String.characterType)#\(character.id)"
        summaryID = "\(String.characterType)#\(character.id)"
        itemName = .characterType
        popularity = character.popularity
        name = character.name
        description = character.description
        thumbnail = character.thumbnail
        seriesSummary = character.series?.compactMap { SeriesSummary($0, id: character.id, itemName: .characterType) }
    }

}
