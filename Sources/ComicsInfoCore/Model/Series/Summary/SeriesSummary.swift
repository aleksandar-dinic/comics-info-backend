//
//  SeriesSummary.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 27/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation

public struct SeriesSummary: ItemSummary {
    
    public let itemID: String
    public private(set) var sortValue: String
    public let summaryID: String
    public let itemType: String
    public let summaryType: String
    
    public let dateAdded: Date
    public private(set) var dateLastUpdated: Date
    public private(set) var popularity: Int
    public private(set) var name: String
    public private(set) var thumbnail: String?
    public private(set) var description: String?
    public private(set) var startYear: Int?
    public private(set) var endYear: Int?
    public private(set) var oldSortValue: String?
    
    init<Link: Identifiable>(
        ID: String,
        link: Link,
        popularity: Int,
        name: String,
        thumbnail: String?,
        description: String?,
        startYear: Int?,
        endYear: Int?
    ) {
        let now = Date()
        
        self.itemID = .comicInfoID(for: SeriesSummary.self, ID: ID)
        self.summaryID = .comicInfoSummaryID(for: link)
        sortValue = "Popularity=\(abs(popularity-100))#Name=\(name)#SummaryID=\(summaryID)"
        itemType = .getType(from: SeriesSummary.self)
        summaryType = "\(itemType)#\(summaryID)"
        dateAdded = now
        dateLastUpdated = now
        self.popularity = popularity
        self.name = name
        self.thumbnail = thumbnail
        self.description = description
        self.startYear = startYear
        self.endYear = endYear
        oldSortValue = nil
    }
    
    mutating func update(with series: Series) {
        dateLastUpdated = Date()
        popularity = series.popularity
        name = series.name
        thumbnail = series.thumbnail
        description = series.description
        startYear = series.startYear
        endYear = series.endYear
        oldSortValue = sortValue
        sortValue = "Popularity=\(abs(popularity-100))#Name=\(name)"
    }

}
