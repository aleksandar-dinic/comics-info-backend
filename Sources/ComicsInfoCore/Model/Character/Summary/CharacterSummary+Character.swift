//
//  CharacterSummary+Character.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 05/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation

extension CharacterSummary {
    
    init(_ character: Character, id: String, count: Int?) {
        self.init(
            itemID: "\(String.getType(from: Character.self))#\(character.id)",
            summaryID: "\(String.getType(from: Item.self))#\(id)",
            itemName: .getType(from: CharacterSummary<Item>.self),
            dateAdded: Date(),
            dateLastUpdated: Date(),
            popularity: character.popularity,
            name: character.name,
            thumbnail: character.thumbnail,
            description: character.description,
            count: count
        )
    }

}
