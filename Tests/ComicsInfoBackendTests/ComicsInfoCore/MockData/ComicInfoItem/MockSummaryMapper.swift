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
    let itemName: String

    let popularity: Int
    let name: String
    let thumbnail: String?
    let description: String?
    
}

enum MockSummaryMapperFactory {
    
    static func make(
        id: String = "1",
        itemID: String = "MockSummaryMapper#1",
        summaryID: String = "MockSummaryMapper#1",
        itemName: String = "MockSummaryMapper",
        popularity: Int = 0,
        name: String = "Mock Summary Mapper Name",
        thumbnail: String? = "Mock Summary Mapper Thumbnail",
        description: String? = "Mock Summary Mapper Description"
    ) -> MockSummaryMapper {
        MockSummaryMapper(
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
