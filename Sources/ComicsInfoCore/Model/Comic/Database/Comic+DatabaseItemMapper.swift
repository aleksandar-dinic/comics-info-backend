//
//  Comic+DatabaseItemMapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 04/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

extension Comic: DatabaseItemMapper {

    init(from item: ComicDatabase) {
        self.init(
            id: item.id,
            popularity: item.popularity,
            title: item.title,
            dateAdded: item.dateAdded,
            dateLastUpdated: item.dateLastUpdated,
            thumbnail: item.thumbnail,
            description: item.description,
            issueNumber: item.issueNumber,
            aliases: item.aliases,
            variantDescription: item.variantDescription,
            format: item.format,
            pageCount: item.pageCount,
            variantsIdentifier: item.variantsIdentifier,
            collectionsIdentifier: item.collectionsIdentifier,
            collectedIssuesIdentifier: item.collectedIssuesIdentifier,
            images: item.images,
            published: item.published,
            charactersID: item.getCharactersID(),
            characters: item.charactersSummary?.compactMap { Character(fromSummary: $0) },
            seriesID: item.getSeriesID(),
            series: item.seriesSummary?.compactMap { Series(fromSummary: $0) }
        )
    }

}
