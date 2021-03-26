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
    private(set) var sortValue: String
    let summaryID: String
    let itemType: String
    
    let dateAdded: Date
    private(set) var dateLastUpdated: Date
    private(set) var popularity: Int
    private(set) var name: String
    private(set) var thumbnail: String?
    private(set) var description: String?
    private(set) var oldSortValue: String?
    
    init<Link: Identifiable>(
        ID: String,
        link: Link,
        popularity: Int,
        name: String,
        thumbnail: String?,
        description: String?
    ) {
        let now = Date()
        
        self.itemID = .comicInfoID(for: SeriesSummary.self, ID: ID)
        self.summaryID = .comicInfoSummaryID(for: link)
        sortValue = "Popularity=\(abs(popularity-100))#Name=\(name)#SummaryID=\(summaryID)"
        itemType = .getType(from: SeriesSummary.self)
        dateAdded = now
        dateLastUpdated = now
        self.popularity = popularity
        self.name = name
        self.thumbnail = thumbnail
        self.description = description
        oldSortValue = nil
    }
    
    mutating func update(with series: Series) {
        dateLastUpdated = Date()
        popularity = series.popularity
        name = series.name
        thumbnail = series.thumbnail
        description = series.description
        oldSortValue = sortValue
        sortValue = "Popularity=\(abs(popularity-100))#Name=\(name)#SummaryID=\(summaryID)"
    }

}
