//
//  SeriesDatabase.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 28/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

struct SeriesDatabase: Identifiable {

    var id: String {
        String(summaryID.dropFirst("\(String.getType(from: Series.self))#".count))
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
    var comicsSummary: [ComicSummary]?

    func getCharactersID() -> Set<String> {
        guard let charactersSummary = charactersSummary else { return [] }

        return Set(charactersSummary.compactMap { $0.id })
    }

    func getComicsID() -> Set<String>? {
        guard let comicsSummary = comicsSummary else { return nil }

        return Set(comicsSummary.compactMap { $0.id })
    }

}

extension SeriesDatabase {

    init(series: Series) {
        itemID = "\(String.getType(from: Series.self))#\(series.id)"
        summaryID = "\(String.getType(from: Series.self))#\(series.id)"
        itemName = .getType(from: Series.self)
        popularity = series.popularity
        title = series.title
        description = series.description
        thumbnail = series.thumbnail
        startYear = series.startYear
        endYear = series.endYear
        nextIdentifier = series.nextIdentifier
        charactersSummary = series.characters?.compactMap {
            CharacterSummary($0, id: series.id, itemName: .getType(from: Series.self))
        }
        comicsSummary = series.comics?.compactMap {
            ComicSummary($0, id: series.id, itemName: .getType(from: Series.self))
        }
    }

}
