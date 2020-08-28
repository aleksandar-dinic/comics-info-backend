//
//  Character+Domain.swift
//  ComicsInfoBackend
//
//  Created by Aleksandar Dinic on 28/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import struct Domain.Character
import Foundation

extension Domain.Character {

    init(from character: Character) {
        self.init(
            identifier: character.identifier,
            popularity: character.popularity,
            name: character.name,
            thumbnail: character.thumbnail,
            description: character.description
        )
    }

}
