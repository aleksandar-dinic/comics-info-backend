//
//  ComicSummary+Domain.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 05/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Domain.ComicSummary
import Foundation

extension ComicSummary {
    
    init<Summary: Identifiable>(from comicSummary: Domain.ComicSummary, link: Summary, number: String?) {
        self.init(
            ID: comicSummary.identifier,
            link: link,
            popularity: comicSummary.popularity,
            name: comicSummary.title,
            thumbnail: comicSummary.thumbnail,
            description: comicSummary.description,
            number: number,
            published: comicSummary.published
        )
    }
    
}
