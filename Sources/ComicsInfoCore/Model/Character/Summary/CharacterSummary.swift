//
//  CharacterSummary.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 28/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

public struct CharacterSummary: Codable {

    var id: String {
        String(summaryID.dropFirst("\(String.characterType)#".count))
    }

    public let itemID: String
    public let summaryID: String
    let itemName: String

    let popularity: Int
    let name: String
    let thumbnail: String?
    let description: String?

}

extension CharacterSummary {

    init(_ character: Character, id: String, itemName: String) {
        itemID = "\(itemName)#\(id)"
        summaryID = "\(String.characterType)#\(character.id)"
        self.itemName = itemName
        popularity = character.popularity
        name = character.name
        description = character.description
        thumbnail = character.thumbnail
    }

}

extension CharacterSummary: DatabaseDecodable {

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
