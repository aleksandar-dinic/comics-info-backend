//
//  CharacterSummary.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 28/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

struct CharacterSummary: Identifiable {

    var id: String {
        String(summaryID.dropFirst("\(String.characterType)#".count))
    }

    let itemID: String
    let summaryID: String
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

    public init(from item: DatabaseItem) throws {
        let decoder = DatabaseDecoder(from: item)

        itemID = try decoder.decode(String.self, forKey: CodingKeys.itemID)
        summaryID = try decoder.decode(String.self, forKey: CodingKeys.summaryID)
        guard summaryID.starts(with: "\(String.characterType)#") else {
            throw APIError.invalidSummaryID(summaryID, itemType: .characterType)
        }

        itemName = try decoder.decode(String.self, forKey: CodingKeys.itemName)
        popularity = try decoder.decode(Int.self, forKey: CodingKeys.popularity)
        name = try decoder.decode(String.self, forKey: CodingKeys.name)
        thumbnail = try? decoder.decode(String.self, forKey: CodingKeys.thumbnail)
        description = try? decoder.decode(String.self, forKey: CodingKeys.description)
    }

}
