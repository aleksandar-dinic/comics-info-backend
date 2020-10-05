//
//  ComicDatabase+DatabaseDecodable.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 04/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

extension ComicDatabase: DatabaseDecodable {

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
