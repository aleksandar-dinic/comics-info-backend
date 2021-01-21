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

    let itemID: String
    let summaryID: String
    let itemName: String

    let popularity: Int
    let name: String
    let dateAdded: Date
    let dateLastUpdated: Date
    let description: String?
    let thumbnail: String?
    let realName: String?
    let aliases: [String]?
    let birth: Date?
    var seriesSummary: [ItemSummary<Series>]?
    var comicsSummary: [ItemSummary<Comic>]?

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
        dateAdded = item.dateAdded
        dateLastUpdated = item.dateLastUpdated
        description = item.description
        thumbnail = item.thumbnail
        realName = item.realName
        aliases = item.aliases
        birth = item.birth
        seriesSummary = item.series
        comicsSummary = item.comics
    }

}

extension CharacterDatabase {

    enum CodingKeys: String, CodingKey {
        case itemID
        case summaryID
        case itemName
        case popularity
        case name
        case dateAdded
        case dateLastUpdated
        case thumbnail
        case description
        case realName
        case aliases
        case birth
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
        dateAdded = try decoder.decode(Date.self, forKey: CodingKeys.dateAdded)
        dateLastUpdated = try decoder.decode(Date.self, forKey: CodingKeys.dateLastUpdated)
        thumbnail = try? decoder.decode(String.self, forKey: CodingKeys.thumbnail)
        description = try? decoder.decode(String.self, forKey: CodingKeys.description)
        realName = try? decoder.decode(String.self, forKey: CodingKeys.realName)
        aliases = try? decoder.decode([String].self, forKey: CodingKeys.aliases)
        birth = try? decoder.decode(Date.self, forKey: CodingKeys.birth)
    }

}
