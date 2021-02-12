//
//  GetSeries.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 13/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import struct ComicsInfoCore.SeriesSummary
import Foundation

enum SeriesSummaryFactory {
    
    static func make(ID: String = "1", popularity: Int = 0) -> SeriesSummary {
        make(
            itemID: "Series#\(ID)",
            summaryID: "Series#\(ID)",
            itemName: "Series",
            dateAdded: Date(),
            dateLastUpdated: Date(),
            popularity: 0,
            name: "SeriesSummary \(ID) Name",
            thumbnail: "SeriesSummary \(ID) Thumbnail",
            description: "SeriesSummary \(ID) Description"
        )
    }

    static func make(
        itemID: String = "Series#1",
        summaryID: String = "Series#1",
        itemName: String = "Series",
        dateAdded: Date = Date(),
        dateLastUpdated: Date = Date(),
        popularity: Int = 0,
        name: String = "SeriesSummary 1 Name",
        thumbnail: String? = nil,
        description: String? = nil
    ) -> SeriesSummary {
        SeriesSummary(
            itemID: itemID,
            summaryID: summaryID,
            itemName: itemName,
            dateAdded: dateAdded,
            dateLastUpdated: dateLastUpdated,
            popularity: popularity,
            name: name,
            thumbnail: thumbnail,
            description: description
        )
    }

    static func makeList() -> [SeriesSummary] {
        [
            make(ID: "2", popularity: 2),
            make(ID: "3", popularity: 3),
            make(ID: "4", popularity: 4)
        ]
    }
    
}
