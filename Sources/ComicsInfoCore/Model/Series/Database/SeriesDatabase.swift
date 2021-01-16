//
//  SeriesDatabase.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 28/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

struct SeriesDatabase: DatabaseMapper {

    var id: String {
        String(summaryID.dropFirst("\(String.getType(from: Series.self))#".count))
    }

    let itemID: String
    let summaryID: String
    let itemName: String

    let popularity: Int
    let title: String
    let dateAdded: Date
    let dateLastUpdated: Date
    let description: String?
    let thumbnail: String?
    let startYear: Int?
    let endYear: Int?
    let aliases: [String]?
    let nextIdentifier: String?
    var charactersSummary: [CharacterSummary]?
    var comicsSummary: [ComicSummary]?

    func getCharactersID() -> Set<String>? {
        guard let charactersSummary = charactersSummary else { return nil }
        return Set(charactersSummary.compactMap { $0.id })
    }

    func getComicsID() -> Set<String>? {
        guard let comicsSummary = comicsSummary else { return nil }
        return Set(comicsSummary.compactMap { $0.id })
    }

}

extension SeriesDatabase {

    init(item: Series) {
        itemID = "\(String.getType(from: Series.self))#\(item.id)"
        summaryID = "\(String.getType(from: Series.self))#\(item.id)"
        itemName = .getType(from: Series.self)
        popularity = item.popularity
        title = item.title
        dateAdded = item.dateAdded
        dateLastUpdated = item.dateLastUpdated
        description = item.description
        thumbnail = item.thumbnail
        startYear = item.startYear
        endYear = item.endYear
        aliases = item.aliases
        nextIdentifier = item.nextIdentifier
        charactersSummary = item.characters?.compactMap {
            CharacterSummary($0, id: item.id, itemName: .getType(from: Series.self))
        }
        comicsSummary = item.comics?.compactMap {
            ComicSummary($0, id: item.id, itemName: .getType(from: Series.self))
        }
    }

}

extension SeriesDatabase {

    enum CodingKeys: String, CodingKey {
        case itemID
        case summaryID
        case itemName
        case popularity
        case title
        case dateAdded
        case dateLastUpdated
        case description
        case startYear
        case endYear
        case aliases
        case thumbnail
        case nextIdentifier
    }

    public init(from item: DatabaseItem) throws {
        let decoder = DatabaseDecoder(from: item)

        itemID = try decoder.decode(String.self, forKey: CodingKeys.itemID)
        guard itemID.starts(with: "\(String.getType(from: Series.self))#") else {
            throw APIError.invalidItemID(itemID, itemType: .getType(from: Series.self))
        }

        summaryID = try decoder.decode(String.self, forKey: CodingKeys.summaryID)
        guard summaryID.starts(with: "\(String.getType(from: Series.self))#") else {
            throw APIError.invalidSummaryID(summaryID, itemType: .getType(from: Series.self))
        }

        itemName = try decoder.decode(String.self, forKey: CodingKeys.itemName)
        popularity = try decoder.decode(Int.self, forKey: CodingKeys.popularity)
        title = try decoder.decode(String.self, forKey: CodingKeys.title)
        dateAdded = try decoder.decode(Date.self, forKey: CodingKeys.dateAdded)
        dateLastUpdated = try decoder.decode(Date.self, forKey: CodingKeys.dateLastUpdated)
        description = try? decoder.decode(String.self, forKey: CodingKeys.description)
        startYear = try? decoder.decode(Int.self, forKey: CodingKeys.startYear)
        endYear = try? decoder.decode(Int.self, forKey: CodingKeys.endYear)
        aliases = try? decoder.decode([String].self, forKey: CodingKeys.aliases)
        thumbnail = try? decoder.decode(String.self, forKey: CodingKeys.thumbnail)
        nextIdentifier = try? decoder.decode(String.self, forKey: CodingKeys.nextIdentifier)
    }

}
