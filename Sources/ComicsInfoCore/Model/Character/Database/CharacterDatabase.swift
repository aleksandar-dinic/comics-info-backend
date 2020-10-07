//
//  CharacterDatabase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 28/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

struct CharacterDatabase: DatabaseMapper {

    var id: String {
        String(summaryID.dropFirst("\(String.getType(from: Character.self))#".count))
    }

    var tableName: String {
        .characterTableName
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

    init(item: Character) {
        itemID = "\(String.getType(from: Character.self))#\(item.id)"
        summaryID = "\(String.getType(from: Character.self))#\(item.id)"
        itemName = .getType(from: Character.self)
        popularity = item.popularity
        name = item.name
        description = item.description
        thumbnail = item.thumbnail
        seriesSummary = item.series?.compactMap {
            SeriesSummary($0, id: item.id, itemName: .getType(from: Character.self))
        }
        comicsSummary = item.comics?.compactMap {
            ComicSummary($0, id: item.id, itemName: .getType(from: Character.self))
        }
    }

}

extension CharacterDatabase {

    enum CodingKeys: String, CodingKey {
        case itemID
        case summaryID
        case itemName
        case popularity
        case name
        case thumbnail
        case description
    }

    public init(from item: DatabaseItem) throws {
        let decoder = DatabaseDecoder(from: item)

        itemID = try decoder.decode(String.self, forKey: CodingKeys.itemID)
        guard itemID.starts(with: "\(String.getType(from: Character.self))#") else {
            throw APIError.invalidItemID(itemID, itemType: .getType(from: Character.self))
        }

        summaryID = try decoder.decode(String.self, forKey: CodingKeys.summaryID)
        guard summaryID.starts(with: "\(String.getType(from: Character.self))#") else {
            throw APIError.invalidSummaryID(summaryID, itemType: .getType(from: Character.self))
        }

        itemName = try decoder.decode(String.self, forKey: CodingKeys.itemName)
        popularity = try decoder.decode(Int.self, forKey: CodingKeys.popularity)
        name = try decoder.decode(String.self, forKey: CodingKeys.name)
        thumbnail = try? decoder.decode(String.self, forKey: CodingKeys.thumbnail)
        description = try? decoder.decode(String.self, forKey: CodingKeys.description)
    }

}
