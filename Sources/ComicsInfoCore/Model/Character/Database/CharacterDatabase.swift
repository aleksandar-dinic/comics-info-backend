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

    var tableName: String

    let itemID: String
    let summaryID: String
    let itemName: String

    let popularity: Int
    let name: String
    let description: String?
    let thumbnail: String?
    var seriesSummary: [SeriesSummary]?
    var comicsSummary: [ComicSummary]?

    init(
        tableName: String,
        itemID: String,
        summaryID: String,
        itemName: String,
        popularity: Int,
        name: String,
        description: String?,
        thumbnail: String?,
        seriesSummary: [SeriesSummary]?,
        comicsSummary: [ComicSummary]?
    ) {
        self.tableName = tableName
        self.itemID = itemID
        self.summaryID = summaryID
        self.itemName = itemName
        self.popularity = popularity
        self.name = name
        self.description = description
        self.thumbnail = thumbnail
        self.seriesSummary = seriesSummary
        self.comicsSummary = comicsSummary
    }

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

    init(item: Character, tableName: String) {
        itemID = "\(String.getType(from: Character.self))#\(item.id)"
        summaryID = "\(String.getType(from: Character.self))#\(item.id)"
        itemName = .getType(from: Character.self)
        popularity = item.popularity
        name = item.name
        description = item.description
        thumbnail = item.thumbnail
        seriesSummary = item.series?.compactMap {
            SeriesSummary($0, id: item.id, itemName: .getType(from: Character.self), tableName: tableName)
        }
        comicsSummary = item.comics?.compactMap {
            ComicSummary($0, id: item.id, itemName: .getType(from: Character.self), tableName: tableName)
        }
        self.tableName = tableName
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

    public init(from item: DatabaseItem, tableName: String) throws {
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
        self.tableName = tableName
    }

}
