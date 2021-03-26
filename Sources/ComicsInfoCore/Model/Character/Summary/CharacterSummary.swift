//
//  CharacterSummary.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 27/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation

struct CharacterSummary: ItemSummary {
    
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
    private(set) var count: Int?
    private(set) var oldSortValue: String?
    
    init<Link: Identifiable>(
        ID: String,
        link: Link,
        popularity: Int,
        name: String,
        thumbnail: String?,
        description: String?,
        count: Int?
    ) {
        let now = Date()
        
        self.itemID = .comicInfoID(for: CharacterSummary.self, ID: ID)
        self.summaryID = .comicInfoSummaryID(for: link)
        sortValue = "Popularity=\(abs(popularity-100))#Count=\(count ?? 10_000_000)#Name=\(name)#SummaryID=\(summaryID)"
        itemType = .getType(from: CharacterSummary.self)
        dateAdded = now
        dateLastUpdated = now
        self.popularity = popularity
        self.name = name
        self.thumbnail = thumbnail
        self.description = description
        self.count = count
        oldSortValue = nil
    }
    
    mutating func update(with character: Character) {
        dateLastUpdated = Date()
        popularity = character.popularity
        name = character.name
        thumbnail = character.thumbnail
        description = character.description
        oldSortValue = sortValue
        sortValue = "Popularity=\(abs(popularity-100))#Count=\(count ?? 10_000_000)#Name=\(name)#SummaryID=\(summaryID)"
    }
    
}
