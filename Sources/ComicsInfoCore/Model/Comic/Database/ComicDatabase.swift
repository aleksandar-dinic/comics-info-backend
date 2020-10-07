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

    var tableName: String {
        .comicTableName
    }

    let itemID: String
    let summaryID: String
    let itemName: String

    let popularity: Int
    let title: String
    let description: String?
    let thumbnail: String?
    let issueNumber: String?
    let variantDescription: String?
    let format: String?
    let pageCount: Int?
    let variantsIdentifier: [String]?
    let collectionsIdentifier: [String]?
    let collectedIssuesIdentifier: [String]?
    let images: [String]?
    let published: Date?
    var charactersSummary: [CharacterSummary]?
    var seriesSummary: [SeriesSummary]?

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
        description = item.description
        thumbnail = item.thumbnail
        issueNumber = item.issueNumber
        variantDescription = item.variantDescription
        format = item.format
        pageCount = item.pageCount
        variantsIdentifier = item.variantsIdentifier
        collectionsIdentifier = item.collectionsIdentifier
        collectedIssuesIdentifier = item.collectedIssuesIdentifier
        images = item.images
        published = item.published
        charactersSummary = item.characters?.compactMap {
            CharacterSummary($0, id: item.id, itemName: .getType(from: Comic.self))
        }
        seriesSummary = item.series?.compactMap {
            SeriesSummary($0, id: item.id, itemName: .getType(from: Comic.self))
        }
    }

}

extension ComicDatabase {

    enum CodingKeys: String, CodingKey {
        case itemID
        case summaryID
        case itemName
        case popularity
        case title
        case thumbnail
        case description
        case issueNumber
        case variantDescription
        case format
        case pageCount
        case variantsIdentifier
        case collectionsIdentifier
        case collectedIssuesIdentifier
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
        thumbnail = try? decoder.decode(String.self, forKey: CodingKeys.thumbnail)
        description = try? decoder.decode(String.self, forKey: CodingKeys.description)
        issueNumber = try? decoder.decode(String.self, forKey: CodingKeys.issueNumber)
        variantDescription = try? decoder.decode(String.self, forKey: CodingKeys.variantDescription)
        format = try? decoder.decode(String.self, forKey: CodingKeys.format)
        pageCount = try? decoder.decode(Int.self, forKey: CodingKeys.pageCount)
        variantsIdentifier = try? decoder.decode([String].self, forKey: CodingKeys.variantsIdentifier)
        collectionsIdentifier = try? decoder.decode([String].self, forKey: CodingKeys.collectionsIdentifier)
        collectedIssuesIdentifier = try? decoder.decode([String].self, forKey: CodingKeys.collectedIssuesIdentifier)
        images = try? decoder.decode([String].self, forKey: CodingKeys.images)
        published = try? decoder.decode(Date.self, forKey: CodingKeys.published)
    }

}
