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
        tableName: String = "series",
        itemID: String = "series#1",
        summaryID: String = "series#1",
        itemName: String = "series",
        popularity: Int = 0,
        title: String = "SeriesSummary 1 Title",
        thumbnail: String? = nil,
        description: String? = nil
    ) -> SeriesSummary {
        SeriesSummary(
            tableName: tableName,
            itemID: itemID,
            summaryID: summaryID,
            itemName: itemName,
            popularity: popularity,
            title: title,
            thumbnail: thumbnail,
            description: description
        )
    }

    static var seriesSummary: SeriesSummary {
        SeriesSummary(
            tableName: "series",
            itemID: "series#1",
            summaryID: "series#1",
            itemName: "series",
            popularity: 0,
            title: "SeriesSummary 1 Title",
            thumbnail: "SeriesSummary 1 Thumbnail",
            description: "SeriesSummary 1 Description"
        )
    }
    
}
