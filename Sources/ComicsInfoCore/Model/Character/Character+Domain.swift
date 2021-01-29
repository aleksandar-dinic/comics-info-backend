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
        id = character.identifier
        popularity = character.popularity
        name = character.name
        dateAdded = Date()
        dateLastUpdated = Date()
        thumbnail = character.thumbnail
        description = character.description
        realName = character.realName
        aliases = character.aliases
        birth = character.birth
        if let seriesID = character.series?.map({ $0.identifier }), !seriesID.isEmpty {
            self.seriesID = Set(seriesID)
        } else {
            self.seriesID = nil
        }
        if let series = character.series?.map({ SeriesSummary(from: $0, id: character.identifier, link: Character.self) }), !series.isEmpty {
            self.series = series
        } else {
            self.series = nil
        }
        if let comicsID = character.comics?.map({ $0.identifier }), !comicsID.isEmpty {
            self.comicsID = Set(comicsID)
        } else {
            self.comicsID = nil
        }
        if let comics = character.comics?.map({ ComicSummary(from: $0, id: character.identifier, link: Character.self, number: nil) }), !comics.isEmpty {
            self.comics = comics
        } else {
            self.comics = nil
        }

        itemName = String.getType(from: Character.self)
        itemID = "\(itemName)#\(id)"
        summaryID = "\(itemName)#\(id)"
    }
    
}
