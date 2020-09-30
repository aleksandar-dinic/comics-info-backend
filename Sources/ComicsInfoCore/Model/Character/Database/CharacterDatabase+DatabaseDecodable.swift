//
//  CharacterDatabase+DatabaseDecodable.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 29/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

extension CharacterDatabase: DatabaseDecodable {

    enum CodingKeys: String, CodingKey {
        case itemID
        case summaryID
        case itemName
        case popularity
        case name
        case thumbnail
        case description
    }

    public init(from items: [String: Any]) throws {
        let decoder = DatabaseDecoder(from: items)

        itemID = try decoder.decode(String.self, forKey: CodingKeys.itemID)
        guard itemID.starts(with: "\(String.characterType)#") else {
            throw APIError.invalidItemID("Expected to decode \(String.characterType)# but found a \(itemID) instead.")
        }

        summaryID = try decoder.decode(String.self, forKey: CodingKeys.summaryID)
        guard summaryID.starts(with: "\(String.characterType)#") else {
            throw APIError.invalidSummaryID("Expected to decode \(String.characterType)# but found a \(summaryID) instead.")
        }

        itemName = try decoder.decode(String.self, forKey: CodingKeys.itemName)
        popularity = try decoder.decode(Int.self, forKey: CodingKeys.popularity)
        name = try decoder.decode(String.self, forKey: CodingKeys.name)
        thumbnail = try? decoder.decode(String.self, forKey: CodingKeys.thumbnail)
        description = try? decoder.decode(String.self, forKey: CodingKeys.description)
    }

}

