//
//  CharacterSummary+Domain.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 05/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Domain.ItemSummary
import Foundation

extension CharacterSummary {
    
    init(from item: Domain.ItemSummary, id: String, count: Int?) {
        self.init(
            itemID: "\(String.getType(from: Character.self))#\(item.identifier)",
            summaryID: "\(String.getType(from: Item.self))#\(id)",
            itemName: .getType(from: CharacterSummary<Item>.self),
            dateAdded: Date(),
            dateLastUpdated: Date(),
            popularity: item.popularity,
            name: item.name,
            thumbnail: item.thumbnail,
            description: item.description,
            count: count
        )
    }
    
}
