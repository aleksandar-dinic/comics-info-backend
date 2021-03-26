//
//  SummaryMapperMock.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 29/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import ComicsInfoCore
import Foundation

struct SummaryMapperMock: SummaryMapper {
    
    let id: String
    let itemID: String
    let summaryID: String
    let itemType: String
    
    private(set) var sortValue: String
    private(set) var popularity: Int
    private(set) var name: String
    private(set) var thumbnail: String?
    private(set) var description: String?
    
    mutating func update(with newItem: SummaryMapperMock) {
        popularity = newItem.popularity
        name = newItem.name
        if let thumbnail = newItem.thumbnail {
            self.thumbnail = thumbnail
        }
        if let description = newItem.description {
            self.description = description
        }
        sortValue = "\(summaryID)#Popularity=\(popularity)#Name=\(name)"
    }
    
    static func make(
        id: String = "1",
        itemID: String = "itemID",
        summaryID: String = "summaryID",
        itemType: String = "itemType",
        popularity: Int = 0,
        name: String = "name",
        thumbnail: String? = "thumbnail",
        description: String? = "description"
    ) -> SummaryMapperMock {
        SummaryMapperMock(
            id: id,
            itemID: itemID,
            summaryID: summaryID,
            itemType: itemType,
            sortValue: "\(summaryID)#Popularity=\(popularity)#Name=\(name)",
            popularity: popularity,
            name: name,
            thumbnail: thumbnail,
            description: description
        )
    }
    
}
