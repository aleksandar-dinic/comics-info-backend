//
//  ComicSummary.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 04/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

struct ComicSummary: ItemSummary {

    var id: String {
        String(summaryID.dropFirst("\(String.getType(from: Comic.self))#".count))
    }

    let itemID: String
    let summaryID: String
    let itemName: String

    var popularity: Int
    var title: String
    let dateAdded: Date
    let dateLastUpdated: Date
    var thumbnail: String?
    var description: String?

    mutating func update(with item: Comic) {
        popularity = item.popularity
        title = item.title

        if let description = item.description {
            self.description = description
        }

        if let thumbnail = item.thumbnail {
            self.thumbnail = thumbnail
        }
    }

    func shouldBeUpdated(with item: Comic) -> Bool {
        popularity != item.popularity ||
            title != item.title ||
            description != item.description ||
            thumbnail != item.thumbnail
    }

}

extension ComicSummary {

    init(_ comic: Comic, id: String, itemName: String) {
        itemID = "\(itemName)#\(id)"
        summaryID = "\(String.getType(from: Comic.self))#\(comic.id)"
        self.itemName = itemName
        popularity = comic.popularity
        title = comic.title
        dateAdded = comic.dateAdded
        dateLastUpdated = comic.dateLastUpdated
        description = comic.description
        thumbnail = comic.thumbnail
    }

}

extension ComicSummary {

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
    }

    public init(from item: DatabaseItem) throws {
        let decoder = DatabaseDecoder(from: item)

        itemID = try decoder.decode(String.self, forKey: CodingKeys.itemID)
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
    }

}
