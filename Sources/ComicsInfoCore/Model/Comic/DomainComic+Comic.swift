//
//  DomainComic+Comic.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 29/01/2021.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import struct Domain.Comic
import struct Domain.CharacterSummary
import struct Domain.SeriesSummary
import Foundation

extension Domain.Comic {

    init(from comic: Comic) {
        let characters = comic.characters?.map { Domain.CharacterSummary(from: $0) }
        let series = comic.series?.map { Domain.SeriesSummary(from: $0) }

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
            characters: characters,
            series: series
        )
    }

}
