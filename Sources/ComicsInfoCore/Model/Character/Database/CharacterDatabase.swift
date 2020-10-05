//
//  CharacterDatabase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 28/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

struct CharacterDatabase: Identifiable {

    var id: String {
        String(summaryID.dropFirst("\(String.getType(from: Character.self))#".count))
    }

    let itemID: String
    let summaryID: String
    let itemName: String

    let popularity: Int
    let name: String
    let description: String?
    let thumbnail: String?
    var seriesSummary: [SeriesSummary]?
    var comicsSummary: [ComicSummary]?

    func getSeriesID() -> Set<String>? {
        guard let seriesSummary = seriesSummary else { return nil }

        return Set(seriesSummary.compactMap { $0.id })
    }

    func getComicsID() -> Set<String>? {
        guard let comicsSummary = comicsSummary else { return nil }

        return Set(comicsSummary.compactMap { $0.id })
    }

}

extension CharacterDatabase {

    init(character: Character) {
        itemID = "\(String.getType(from: Character.self))#\(character.id)"
        summaryID = "\(String.getType(from: Character.self))#\(character.id)"
        itemName = .getType(from: Character.self)
        popularity = character.popularity
        name = character.name
        description = character.description
        thumbnail = character.thumbnail
        seriesSummary = character.series?.compactMap {
            SeriesSummary($0, id: character.id, itemName: .getType(from: Character.self))
        }
        comicsSummary = character.comics?.compactMap {
            ComicSummary($0, id: character.id, itemName: .getType(from: Character.self))
        }
    }

}
