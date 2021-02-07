//
//  ComicSummary.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 27/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation

struct ComicSummary<Item>: ItemSummary {
    
    let itemID: String
    let summaryID: String
    let itemName: String
    
    let dateAdded: Date
    private(set) var dateLastUpdated: Date
    private(set) var popularity: Int
    private(set) var name: String
    private(set) var thumbnail: String?
    private(set) var description: String?
    private(set) var number: String?
    
    mutating func update(with comic: Comic) {
        dateLastUpdated = Date()
        popularity = comic.popularity
        name = comic.name
        thumbnail = comic.thumbnail
        description = comic.description
    }
    
}
