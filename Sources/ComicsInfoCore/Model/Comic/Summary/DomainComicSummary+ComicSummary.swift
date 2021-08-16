//
//  DomainComicSummary+ComicSummary.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 05/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Domain.ComicSummary
import Foundation

extension Domain.ComicSummary {

    init(from comicSummary: ComicSummary) {
        self.init(
            identifier: comicSummary.itemID.getIDFromComicInfoID(for: ComicSummary.self),
            popularity: comicSummary.popularity,
            title: comicSummary.name,
            thumbnail: comicSummary.thumbnail,
            description: comicSummary.description,
            number: comicSummary.number,
            published: comicSummary.published
        )
    }

}
