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
        var charactersID: Set<String>?
        if let IDs = comic.characters?.map({ $0.identifier }), !IDs.isEmpty {
            charactersID = Set(IDs)
        }
        var seriesID: Set<String>?
        if let IDs = comic.series?.map({ $0.identifier }), !IDs.isEmpty {
            seriesID = Set(IDs)
        }
        
        self.init(
            id: comic.identifier,
            popularity: comic.popularity,
            title: comic.title,
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
            seriesID: seriesID
        )
    }
    
}
