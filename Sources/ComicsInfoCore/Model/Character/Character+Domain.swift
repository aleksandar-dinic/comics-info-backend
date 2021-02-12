//
//  Character+Domain.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 28/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import struct Domain.Character
import Foundation

extension Character {
    
    init(from character: Domain.Character) {
        var seriesID: Set<String>?
        if let IDs = character.series?.map({ $0.identifier }), !IDs.isEmpty {
            seriesID = Set(IDs)
        }
        var comicsID: Set<String>?
        if let IDs = character.comics?.map({ $0.identifier }), !IDs.isEmpty {
            comicsID = Set(IDs)
        }
                
        self.init(
            id: character.identifier,
            popularity: character.popularity,
            name: character.name,
            thumbnail: character.thumbnail,
            description: character.description,
            realName: character.realName,
            aliases: character.aliases,
            birth: character.birth,
            seriesID: seriesID,
            comicsID: comicsID
        )
    }
    
}
