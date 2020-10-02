//
//  SeriesSummary.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 28/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

struct SeriesSummary {

    var id: String {
        String(summaryID.dropFirst("\(String.seriesType)#".count))
    }

    let itemID: String
    let summaryID: String
    let itemName: String

    let popularity: Int
    let title: String
    let description: String?
    let thumbnail: String?

}

extension SeriesSummary {

    init(_ series: Series, id: String, itemName: String) {
        itemID = "\(itemName)#\(id)"
        summaryID = "\(String.seriesType)#\(series.id)"
        self.itemName = itemName
        popularity = series.popularity
        title = series.title
        description = series.description
        thumbnail = series.thumbnail
    }

}

extension SeriesSummary: DatabaseDecodable {

    enum CodingKeys: String, CodingKey {
        case itemID
        case summaryID
        case itemName
        case popularity
        case title
        case description
        case thumbnail
    }

    public init(from item: DatabaseItem) throws {
        let decoder = DatabaseDecoder(from: item)

        itemID = try decoder.decode(String.self, forKey: CodingKeys.itemID)
        summaryID = try decoder.decode(String.self, forKey: CodingKeys.summaryID)
        guard summaryID.starts(with: "\(String.seriesType)#") else {
            throw APIError.invalidSummaryID(summaryID, itemType: .seriesType)
        }

        itemName = try decoder.decode(String.self, forKey: CodingKeys.itemName)
        popularity = try decoder.decode(Int.self, forKey: CodingKeys.popularity)
        title = try decoder.decode(String.self, forKey: CodingKeys.title)
        description = try? decoder.decode(String.self, forKey: CodingKeys.description)
        thumbnail = try? decoder.decode(String.self, forKey: CodingKeys.thumbnail)
    }

}
