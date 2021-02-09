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
    let itemName: String
    
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
    }
    
    static func make(
        id: String = "1",
        itemID: String = "itemID",
        summaryID: String = "summaryID",
        itemName: String = "itemName",
        popularity: Int = 0,
        name: String = "name",
        thumbnail: String? = "thumbnail",
        description: String? = "description"
    ) -> SummaryMapperMock {
        SummaryMapperMock(
            id: id,
            itemID: itemID,
            summaryID: summaryID,
            itemName: itemName,
            popularity: popularity,
            name: name,
            thumbnail: thumbnail,
            description: description
        )
    }
    
}
