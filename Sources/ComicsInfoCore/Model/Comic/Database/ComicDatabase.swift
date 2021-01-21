//
//  ComicDatabase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 04/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

struct ComicDatabase: DatabaseMapper {

    var id: String {
        String(summaryID.dropFirst("\(String.getType(from: Comic.self))#".count))
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
    let number: String?
    let aliases: [String]?
    let variantDescription: String?
    let format: String?
    let pageCount: Int?
    let variantsIdentifier: [String]?
    let collectionsIdentifier: [String]?
    let collectedIdentifiers: [String]?
    let images: [String]?
    let published: Date?
    var charactersSummary: [ItemSummary<Character>]?
    var seriesSummary: [ItemSummary<Series>]?

    func getCharactersID() -> Set<String>? {
        guard let charactersSummary = charactersSummary else { return nil }
        return Set(charactersSummary.compactMap { $0.id })
    }

    func getSeriesID() -> Set<String>? {
        guard let seriesSummary = seriesSummary else { return nil }
        return Set(seriesSummary.compactMap { $0.id })
    }

}

extension ComicDatabase {

    init(item: Comic) {
        itemID = "\(String.getType(from: Comic.self))#\(item.id)"
        summaryID = "\(String.getType(from: Comic.self))#\(item.id)"
        itemName = .getType(from: Comic.self)
        popularity = item.popularity
        title = item.title
        dateAdded = item.dateAdded
        dateLastUpdated = item.dateLastUpdated
        description = item.description
        thumbnail = item.thumbnail
        number = item.number
        aliases = item.aliases
        variantDescription = item.variantDescription
        format = item.format
        pageCount = item.pageCount
        variantsIdentifier = item.variantsIdentifier
        collectionsIdentifier = item.collectionsIdentifier
        collectedIdentifiers = item.collectedIdentifiers
        images = item.images
        published = item.published
        charactersSummary = item.characters
        seriesSummary = item.series
    }

}

extension ComicDatabase {

    enum CodingKeys: String, CodingKey {
        case itemID
        case summaryID
        case itemName
        case popularity
        case title
        case dateAdded
        case dateLastUpdated
        case thumbnail
        case description
        case number
        case aliases
        case variantDescription
        case format
        case pageCount
        case variantsIdentifier
        case collectionsIdentifier
        case collectedIdentifiers
        case images
        case published
    }

    public init(from item: DatabaseItem) throws {
        let decoder = DatabaseDecoder(from: item)

        itemID = try decoder.decode(String.self, forKey: CodingKeys.itemID)
        guard itemID.starts(with: "\(String.getType(from: Comic.self))#") else {
            throw APIError.invalidItemID(itemID, itemType: .getType(from: Comic.self))
        }

        summaryID = try decoder.decode(String.self, forKey: CodingKeys.summaryID)
        guard summaryID.starts(with: "\(String.getType(from: Comic.self))#") else {
            throw APIError.invalidSummaryID(summaryID, itemType: .getType(from: Comic.self))
        }

        itemName = try decoder.decode(String.self, forKey: CodingKeys.itemName)
        popularity = try decoder.decode(Int.self, forKey: CodingKeys.popularity)
        title = try decoder.decode(String.self, forKey: CodingKeys.title)
        dateAdded = try decoder.decode(Date.self, forKey: CodingKeys.dateAdded)
        dateLastUpdated = try decoder.decode(Date.self, forKey: CodingKeys.dateLastUpdated)
        thumbnail = try? decoder.decode(String.self, forKey: CodingKeys.thumbnail)
        description = try? decoder.decode(String.self, forKey: CodingKeys.description)
        number = try? decoder.decode(String.self, forKey: CodingKeys.number)
        aliases = try? decoder.decode([String].self, forKey: CodingKeys.aliases)
        variantDescription = try? decoder.decode(String.self, forKey: CodingKeys.variantDescription)
        format = try? decoder.decode(String.self, forKey: CodingKeys.format)
        pageCount = try? decoder.decode(Int.self, forKey: CodingKeys.pageCount)
        variantsIdentifier = try? decoder.decode([String].self, forKey: CodingKeys.variantsIdentifier)
        collectionsIdentifier = try? decoder.decode([String].self, forKey: CodingKeys.collectionsIdentifier)
        collectedIdentifiers = try? decoder.decode([String].self, forKey: CodingKeys.collectedIdentifiers)
        images = try? decoder.decode([String].self, forKey: CodingKeys.images)
        published = try? decoder.decode(Date.self, forKey: CodingKeys.published)
    }

}
