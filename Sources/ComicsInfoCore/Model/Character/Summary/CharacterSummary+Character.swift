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
        self.init(
            ID: character.id,
            link: link,
            popularity: character.popularity,
            name: character.name,
            thumbnail: character.thumbnail,
            description: character.description,
            count: count
        )
    }

}
