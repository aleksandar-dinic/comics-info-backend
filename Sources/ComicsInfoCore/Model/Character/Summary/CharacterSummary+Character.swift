//
//  CharacterSummary+Character.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 05/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation

extension CharacterSummary {
    
    init<Summary: Identifiable>(_ character: Character, link: Summary, count: Int?) {
        let now = Date()
        
        self.init(
            itemID: .comicInfoID(for: character),
            summaryID: .comicInfoID(for: link),
            itemName: .getType(from: CharacterSummary.self),
            dateAdded: now,
            dateLastUpdated: now,
            popularity: character.popularity,
            name: character.name,
            thumbnail: character.thumbnail,
            description: character.description,
            count: count
        )
    }

}
