//
//  CharacterSummary.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 28/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

struct CharacterSummary: ItemSummary {

    var id: String {
        String(summaryID.dropFirst("\(String.getType(from: Character.self))#".count))
    }

    var tableName: String

    let itemID: String
    let summaryID: String
    let itemName: String

    var popularity: Int
    var name: String
    var thumbnail: String?
    var description: String?

    mutating func update(with character: Character) {
        popularity = character.popularity
        name = character.name

        if let thumbnail = character.thumbnail {
            self.thumbnail = thumbnail
        }

        if let description = character.description {
            self.description = description
        }
    }

    func shouldBeUpdated(with character: Character) -> Bool {
        popularity != character.popularity ||
            name != character.name ||
            thumbnail != character.thumbnail ||
            description != character.description
    }

}

extension CharacterSummary {

    init(_ character: Character, id: String, itemName: String, tableName: String) {
        itemID = "\(itemName)#\(id)"
        summaryID = "\(String.getType(from: Character.self))#\(character.id)"
        self.itemName = itemName
        popularity = character.popularity
        name = character.name
        description = character.description
        thumbnail = character.thumbnail
        self.tableName = tableName
    }

}

extension CharacterSummary {

    enum CodingKeys: String, CodingKey {
        case itemID
        case summaryID
        case itemName
        case popularity
        case name
        case thumbnail
        case description
    }

    public init(from item: DatabaseItem, tableName: String) throws {
        let decoder = DatabaseDecoder(from: item)

        itemID = try decoder.decode(String.self, forKey: CodingKeys.itemID)
        summaryID = try decoder.decode(String.self, forKey: CodingKeys.summaryID)
        guard summaryID.starts(with: "\(String.getType(from: Character.self))#") else {
            throw APIError.invalidSummaryID(summaryID, itemType: .getType(from: Character.self))
        }

        itemName = try decoder.decode(String.self, forKey: CodingKeys.itemName)
        popularity = try decoder.decode(Int.self, forKey: CodingKeys.popularity)
        name = try decoder.decode(String.self, forKey: CodingKeys.name)
        thumbnail = try? decoder.decode(String.self, forKey: CodingKeys.thumbnail)
        description = try? decoder.decode(String.self, forKey: CodingKeys.description)
        self.tableName = tableName
    }

}
