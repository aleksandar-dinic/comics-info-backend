//
//  ComicSummary.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 27/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation

struct ComicSummary: ItemSummary {
    
    let itemID: String
    let summaryID: String
    let itemType: String
    
    let dateAdded: Date
    private(set) var dateLastUpdated: Date
    private(set) var popularity: Int
    private(set) var name: String
    private(set) var thumbnail: String?
    private(set) var description: String?
    private(set) var number: String?
    
    init<Link: Identifiable>(
        ID: String,
        link: Link,
        popularity: Int,
        name: String,
        thumbnail: String?,
        description: String?,
        number: String?
    ) {
        let now = Date()
        
        self.itemID = .comicInfoID(for: Comic.self, ID: ID)
        self.summaryID = .comicInfoID(for: link)
        itemType = .getType(from: ComicSummary.self)
        dateAdded = now
        dateLastUpdated = now
        self.popularity = popularity
        self.name = name
        self.thumbnail = thumbnail
        self.description = description
        self.number = number
    }
    
    mutating func update(with comic: Comic) {
        dateLastUpdated = Date()
        popularity = comic.popularity
        name = comic.name
        thumbnail = comic.thumbnail
        description = comic.description
        number = comic.number
    }
    
}
