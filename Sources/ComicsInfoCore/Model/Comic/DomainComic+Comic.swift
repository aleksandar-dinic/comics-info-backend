//
//  DomainComic+Comic.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 29/01/2021.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import struct Domain.Comic
import struct Domain.ItemSummary
import Foundation

extension Domain.Comic {

    init(from comic: Comic) {
        let characters = comic.characters?.map { Domain.ItemSummary(from: $0) }
        let series = comic.series?.map { Domain.ItemSummary(from: $0) }

        self.init(
            identifier: comic.id,
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
            characters: characters?.sorted(by: { $0.popularity > $1.popularity }),
            series: series?.sorted(by: { $0.popularity > $1.popularity })
        )
    }

}
