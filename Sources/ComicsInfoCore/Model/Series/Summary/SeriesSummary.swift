//
//  SeriesSummary.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 27/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation

struct SeriesSummary: ItemSummary {
    
    let itemID: String
    let summaryID: String
    let itemType: String
    
    let dateAdded: Date
    private(set) var dateLastUpdated: Date
    private(set) var popularity: Int
    private(set) var name: String
    private(set) var thumbnail: String?
    private(set) var description: String?
    
    init<Link: Identifiable>(
        ID: String,
        link: Link,
        popularity: Int,
        name: String,
        thumbnail: String?,
        description: String?
    ) {
        let now = Date()
        
        self.itemID = .comicInfoID(for: Series.self, ID: ID)
        self.summaryID = .comicInfoID(for: link)
        itemType = .getType(from: SeriesSummary.self)
        dateAdded = now
        dateLastUpdated = now
        self.popularity = popularity
        self.name = name
        self.thumbnail = thumbnail
        self.description = description
    }
    
    mutating func update(with series: Series) {
        dateLastUpdated = Date()
        popularity = series.popularity
        name = series.name
        thumbnail = series.thumbnail
        description = series.description
    }

}
