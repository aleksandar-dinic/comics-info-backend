//
//  SeriesDatabase+DatabaseDecodable.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 29/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

extension SeriesDatabase: DatabaseDecodable {

    enum CodingKeys: String, CodingKey {
        case itemID
        case summaryID
        case itemName
        case popularity
        case title
        case description
        case startYear
        case endYear
        case thumbnail
        case nextIdentifier
    }

    public init(from item: DatabaseItem) throws {
        let decoder = DatabaseDecoder(from: item)

        itemID = try decoder.decode(String.self, forKey: CodingKeys.itemID)
        guard itemID.starts(with: "\(String.seriesType)#") else {
            throw APIError.invalidItemID(itemID, itemType: .seriesType)
        }

        summaryID = try decoder.decode(String.self, forKey: CodingKeys.summaryID)
        guard summaryID.starts(with: "\(String.seriesType)#") else {
            throw APIError.invalidSummaryID(summaryID, itemType: .seriesType)
        }

        itemName = try decoder.decode(String.self, forKey: CodingKeys.itemName)
        popularity = try decoder.decode(Int.self, forKey: CodingKeys.popularity)
        title = try decoder.decode(String.self, forKey: CodingKeys.title)
        description = try? decoder.decode(String.self, forKey: CodingKeys.description)
        startYear = try? decoder.decode(Int.self, forKey: CodingKeys.startYear)
        endYear = try? decoder.decode(Int.self, forKey: CodingKeys.endYear)
        thumbnail = try? decoder.decode(String.self, forKey: CodingKeys.thumbnail)
        nextIdentifier = try? decoder.decode(String.self, forKey: CodingKeys.nextIdentifier)
    }

}
