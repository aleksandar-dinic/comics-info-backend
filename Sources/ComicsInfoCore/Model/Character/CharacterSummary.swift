//
//  CharacterSummary.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 27/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Domain.ItemSummary
import Foundation

struct CharacterSummary<Item>: ItemSummary {
    
    let itemID: String
    let summaryID: String
    let itemName: String
    
    let dateAdded: Date
    private(set) var dateLastUpdated: Date
    private(set) var popularity: Int
    private(set) var name: String
    private(set) var thumbnail: String?
    private(set) var description: String?
    private(set) var count: Int?
    
    mutating func update(with character: Character) {
        dateLastUpdated = Date()
        popularity = character.popularity
        name = character.name
        thumbnail = character.thumbnail
        description = character.description
    }

}

extension CharacterSummary {
    
    init<Mapper: SummaryMapper>(_ mapper: Mapper, id: String, link: Item.Type, count: Int?) {
        itemID = "\(String.getType(from: Item.self))#\(mapper.id)"
        summaryID = "\(String.getType(from: Character.self))#\(id)"
        itemName = .getType(from: CharacterSummary<Item>.self)
        dateAdded = Date()
        dateLastUpdated = Date()
        popularity = mapper.popularity
        name = mapper.name
        description = mapper.description
        thumbnail = mapper.thumbnail
        self.count = count
    }
    
    init(from item: Domain.ItemSummary, id: String, link: Item.Type, count: Int?) {
        itemID = "\(String.getType(from: Item.self))#\(item.identifier)"
        summaryID = "\(String.getType(from: Character.self))#\(id)"
        itemName = .getType(from: CharacterSummary<Item>.self)
        dateAdded = Date()
        dateLastUpdated = Date()
        popularity = item.popularity
        name = item.name
        description = item.description
        thumbnail = item.thumbnail
        self.count = count
    }
    
}

extension Domain.ItemSummary {

    init<Item>(from item: CharacterSummary<Item>) {
        self.init(
            identifier: item.summaryID.replacingOccurrences(of: "\(String.getType(from: Character.self))#", with: ""),
            popularity: item.popularity,
            name: item.name,
            thumbnail: item.thumbnail,
            description: item.description,
            count: item.count,
            number: nil,
            roles: nil)
    }

}
