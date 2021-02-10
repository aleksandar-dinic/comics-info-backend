//
//  CharacterSummary.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 27/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation

struct CharacterSummary: ItemSummary {
    
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
