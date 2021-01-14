//
//  Comic+ComicSummary.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 04/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

extension Comic {

    init(fromSummary comic: ComicSummary) {
        self.init(
            id: comic.id,
            popularity: comic.popularity,
            title: comic.title,
            dateAdded: comic.dateAdded,
            dateLastUpdated: comic.dateLastUpdated,
            thumbnail: comic.thumbnail,
            description: comic.description,
            issueNumber: nil,
            variantDescription: nil,
            format: nil,
            pageCount: nil,
            variantsIdentifier: nil,
            collectionsIdentifier: nil,
            collectedIssuesIdentifier: nil,
            images: nil,
            published: nil,
            charactersID: nil,
            characters: nil,
            seriesID: nil,
            series: nil
        )
    }

}
