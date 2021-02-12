//
//  ComicSummary+Comic.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 05/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation

extension ComicSummary {
    
    init<Summary: Identifiable>(_ comic: Comic, link: Summary) {
        self.init(
            ID: comic.id,
            link: link,
            popularity: comic.popularity,
            name: comic.name,
            thumbnail: comic.thumbnail,
            description: comic.description,
            number: comic.number
        )
    }

}
