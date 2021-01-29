//
//  Series+Domain.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import struct Domain.Series
import Foundation

extension Series {
    
    init(from series: Domain.Series) {
        id = series.identifier
        popularity = series.popularity
        title = series.title
        dateAdded = Date()
        dateLastUpdated = Date()
        thumbnail = series.thumbnail
        description = series.description
        startYear = series.startYear
        endYear = series.endYear
        aliases = series.aliases
        nextIdentifier = series.nextIdentifier
        if let charactersID = series.characters?.map({ $0.identifier }), !charactersID.isEmpty {
            self.charactersID = Set(charactersID)
        } else {
            self.charactersID = nil
        }
        if let characters = series.characters?.map({ CharacterSummary(from: $0, id: series.identifier, link: Series.self, count: nil) }), !characters.isEmpty {
            self.characters = characters
        } else {
            self.characters = nil
        }
        if let comicsID = series.comics?.map({ $0.identifier }), !comicsID.isEmpty {
            self.comicsID = Set(comicsID)
        } else {
            self.comicsID = nil
        }
        if let comics = series.comics?.map({ ComicSummary(from: $0, id: series.identifier, link: Series.self, number: nil) }), !comics.isEmpty {
            self.comics = comics
        } else {
            self.comics = nil
        }
        
        itemName = String.getType(from: Series.self)
        itemID = "\(itemName)#\(id)"
        summaryID = "\(itemName)#\(id)"
    }
    
}
