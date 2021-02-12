//
//  Comic+Domain.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 04/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import struct Domain.Comic
import Foundation

extension Domain.Comic: Identifiable {
    
    public var id: String {
        identifier
    }
    
}

extension Comic {
    
    init(from comic: Domain.Comic) {
        var charactersID: Set<String>?
        if let IDs = comic.characters?.map({ $0.identifier }), !IDs.isEmpty {
            charactersID = Set(IDs)
        }
        var characterSummary: [CharacterSummary]?
        if let characters = comic.characters?.map({ CharacterSummary(from: $0, link: comic, count: nil) }), !characters.isEmpty {
            characterSummary = characters
        }
        var seriesID: Set<String>?
        if let IDs = comic.series?.map({ $0.identifier }), !IDs.isEmpty {
            seriesID = Set(IDs)
        }
        var seriesSummary: [SeriesSummary]?
        if let series = comic.series?.map({ SeriesSummary(from: $0, link: comic) }), !series.isEmpty {
            seriesSummary = series
        }
        
        let now = Date()
        self.init(
            id: comic.identifier,
            popularity: comic.popularity,
            title: comic.title,
            dateAdded: now,
            dateLastUpdated: now,
            thumbnail: comic.thumbnail,
            description: comic.description,
            number: comic.number,
            aliases: comic.aliases,
            variantDescription: comic.variantDescription,
            format: comic.format,
            pageCount: comic.pageCount,
            variantsIdentifier: comic.variantsIdentifier,
            collectionsIdentifier: comic.collectionsIdentifier,
            collectedIdentifiers: comic.collectedIdentifiers,
            images: comic.images,
            published: comic.published,
            charactersID: charactersID,
            characters: characterSummary,
            seriesID: seriesID,
            series: seriesSummary,
            itemID: .comicInfoID(for: comic),
            summaryID: .comicInfoID(for: comic),
            itemName: .getType(from: Comic.self)
        )
    }
    
}
