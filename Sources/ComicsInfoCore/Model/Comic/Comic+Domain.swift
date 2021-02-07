//
//  Comic+Domain.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 04/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import struct Domain.Comic
import Foundation

extension Comic {
    
    init(from comic: Domain.Comic) {
        id = comic.identifier
        popularity = comic.popularity
        title = comic.title
        dateAdded = Date()
        dateLastUpdated = Date()
        thumbnail = comic.thumbnail
        description = comic.description
        number = comic.number
        aliases = comic.aliases
        variantDescription = comic.variantDescription
        format = comic.format
        pageCount = comic.pageCount
        variantsIdentifier = comic.variantsIdentifier
        collectionsIdentifier = comic.collectionsIdentifier
        collectedIdentifiers = comic.collectedIdentifiers
        images = comic.images
        published = comic.published
        if let charactersID = comic.characters?.map({ $0.identifier }), !charactersID.isEmpty {
            self.charactersID = Set(charactersID)
        } else {
            self.charactersID = nil
        }
        if let characters = comic.characters?.map({ CharacterSummary<Comic>(from: $0, id: comic.identifier, count: nil) }), !characters.isEmpty {
            self.characters = characters
        } else {
            self.characters = nil
        }
        if let seriesID = comic.series?.map({ $0.identifier }), !seriesID.isEmpty {
            self.seriesID = Set(seriesID)
        } else {
            self.seriesID = nil
        }
        if let series = comic.series?.map({ SeriesSummary<Comic>(from: $0, id: comic.identifier) }), !series.isEmpty {
            self.series = series
        } else {
            self.series = nil
        }
        
        itemName = String.getType(from: Comic.self)
        itemID = "\(itemName)#\(id)"
        summaryID = "\(itemName)#\(id)"
    }
    
}
