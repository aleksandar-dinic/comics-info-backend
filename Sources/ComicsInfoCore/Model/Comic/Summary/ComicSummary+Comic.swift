//
//  ComicSummary+Comic.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 05/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation

extension ComicSummary {
    
    init(_ comic: Comic, id: String, number: String?) {
        self.init(
            itemID: "\(String.getType(from: Comic.self))#\(comic.id)",
            summaryID: "\(String.getType(from: Item.self))#\(id)",
            itemName: .getType(from: ComicSummary<Item>.self),
            dateAdded: Date(),
            dateLastUpdated: Date(),
            popularity: comic.popularity,
            name: comic.name,
            thumbnail: comic.thumbnail,
            description: comic.description,
            number: number
        )
    }

}
