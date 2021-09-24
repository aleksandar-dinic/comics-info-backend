//
//  ComicSummary.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 27/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation

public struct ComicSummary: ItemSummary {
    
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
    public private(set) var number: String?
    public private(set) var published: Date?
    public private(set) var oldSortValue: String?
    
    init<Link: Identifiable>(
        ID: String,
        link: Link,
        popularity: Int,
        name: String,
        thumbnail: String?,
        description: String?,
        number: String?,
        published: Date?
    ) {
        let now = Date()
        
        self.itemID = .comicInfoID(for: ComicSummary.self, ID: ID)
        self.summaryID = .comicInfoSummaryID(for: link)
        sortValue = Self.makeSortValue(
            popularity: popularity,
            number: number,
            name: name,
            summaryID: summaryID
        )
        itemType = .getType(from: ComicSummary.self)
        summaryType = "\(itemType)#\(summaryID)"
        dateAdded = now
        dateLastUpdated = now
        self.popularity = popularity
        self.name = name
        self.thumbnail = thumbnail
        self.description = description
        self.number = number
        self.published = published
        oldSortValue = nil
    }
    
    mutating func update(with comic: Comic) {
        dateLastUpdated = Date()
        popularity = comic.popularity
        name = comic.name
        thumbnail = comic.thumbnail
        description = comic.description
        number = comic.number
        published = comic.published
        oldSortValue = sortValue
        sortValue = Self.makeSortValue(
            popularity: popularity,
            number: number,
            name: name,
            summaryID: summaryID
        )
    }
    
    static private func makeSortValue(
        popularity: Int,
        number: String?,
        name: String,
        summaryID: String
    ) -> String {
        var num = "~"
        if let numberStr = number {
            if let number = Int(numberStr) {
                num = String(format: "%011d", number)
            } else {
                num = numberStr
            }
        }

        return "Popularity=\(abs(popularity-100))#Number=\(num)#Name=\(name)#SummaryID=\(summaryID)"
    }
    
}
