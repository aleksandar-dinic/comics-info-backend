//
//  SeriesSummary.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 28/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

struct SeriesSummary: ItemSummary {

    var id: String {
        String(summaryID.dropFirst("\(String.getType(from: Series.self))#".count))
    }

    var tableName: String

    let itemID: String
    let summaryID: String
    let itemName: String

    var popularity: Int
    var title: String
    var thumbnail: String?
    var description: String?

    mutating func update(with series: Series) {
        popularity = series.popularity
        title = series.title

        if let description = series.description {
            self.description = description
        }

        if let thumbnail = series.thumbnail {
            self.thumbnail = thumbnail
        }
    }

    func shouldBeUpdated(with item: Series) -> Bool {
        popularity != item.popularity ||
            title != item.title ||
            description != item.description ||
            thumbnail != item.thumbnail
    }

}

extension SeriesSummary {

    init(_ series: Series, id: String, itemName: String, tableName: String) {
        itemID = "\(itemName)#\(id)"
        summaryID = "\(String.getType(from: Series.self))#\(series.id)"
        self.itemName = itemName
        popularity = series.popularity
        title = series.title
        thumbnail = series.thumbnail
        description = series.description
        self.tableName = tableName
    }

}

extension SeriesSummary {

    enum CodingKeys: String, CodingKey {
        case itemID
        case summaryID
        case itemName
        case popularity
        case title
        case description
        case thumbnail
    }

    public init(from item: DatabaseItem, tableName: String) throws {
        let decoder = DatabaseDecoder(from: item)

        itemID = try decoder.decode(String.self, forKey: CodingKeys.itemID)
        summaryID = try decoder.decode(String.self, forKey: CodingKeys.summaryID)
        guard summaryID.starts(with: "\(String.getType(from: Series.self))#") else {
            throw APIError.invalidSummaryID(summaryID, itemType: .getType(from: Series.self))
        }

        itemName = try decoder.decode(String.self, forKey: CodingKeys.itemName)
        popularity = try decoder.decode(Int.self, forKey: CodingKeys.popularity)
        title = try decoder.decode(String.self, forKey: CodingKeys.title)
        thumbnail = try? decoder.decode(String.self, forKey: CodingKeys.thumbnail)
        description = try? decoder.decode(String.self, forKey: CodingKeys.description)
        self.tableName = tableName
    }

}
