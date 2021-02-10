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
        let now = Date()
        
        self.init(
            itemID: .comicInfoID(for: comic),
            summaryID: .comicInfoID(for: link),
            itemName: .getType(from: ComicSummary.self),
            dateAdded: now,
            dateLastUpdated: now,
            popularity: comic.popularity,
            name: comic.name,
            thumbnail: comic.thumbnail,
            description: comic.description,
            number: comic.number
        )
    }

}
