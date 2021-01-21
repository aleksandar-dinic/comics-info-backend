//
//  SeriesSummaryMock.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 13/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import struct ComicsInfoCore.SeriesSummary
import Foundation

enum SeriesSummaryMock {

    static func makeSeriesSummary(
        itemID: String = "series#1",
        summaryID: String = "series#1",
        itemName: String = "series",
        summaryName: String = "series",
        popularity: Int = 0,
        title: String = "SeriesSummary 1 Title",
        dateAdded: Date = Date(),
        dateLastUpdated: Date = Date(),
        thumbnail: String? = nil,
        description: String? = nil
    ) -> SeriesSummary {
        SeriesSummary(
            itemID: itemID,
            summaryID: summaryID,
            itemName: itemName,
            summaryName: summaryName,
            popularity: popularity,
            title: title,
            dateAdded: dateAdded,
            dateLastUpdated: dateLastUpdated,
            thumbnail: thumbnail,
            description: description
        )
    }

    static var seriesSummary: SeriesSummary {
        SeriesSummary(
            itemID: "series#1",
            summaryID: "series#1",
            itemName: "series",
            summaryName: "series",
            popularity: 0,
            title: "SeriesSummary 1 Title",
            dateAdded: Date(),
            dateLastUpdated: Date(),
            thumbnail: "SeriesSummary 1 Thumbnail",
            description: "SeriesSummary 1 Description"
        )
    }
    
}
