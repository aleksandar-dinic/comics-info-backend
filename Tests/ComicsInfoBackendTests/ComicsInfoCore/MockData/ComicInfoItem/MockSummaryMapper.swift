//
//  MockSummaryMapper.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 31/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation

struct MockSummaryMapper: SummaryMapper {

    let id: String
    let itemID: String
    let summaryID: String
    let itemType: String

    private(set) var sortValue: String
    private(set) var popularity: Int
    private(set) var name: String
    private(set) var thumbnail: String?
    private(set) var description: String?
    
    mutating func update(with newItem: MockSummaryMapper) {
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
    
}

enum MockSummaryMapperFactory {
    
    static func make(
        id: String = "1",
        itemID: String = "MockSummaryMapper#1",
        summaryID: String = "MockSummaryMapper#1",
        itemType: String = "MockSummaryMapper",
        popularity: Int = 0,
        name: String = "Mock Summary Mapper Name",
        thumbnail: String? = "Mock Summary Mapper Thumbnail",
        description: String? = "Mock Summary Mapper Description"
    ) -> MockSummaryMapper {
        MockSummaryMapper(
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
