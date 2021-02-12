//
//  GetSeries.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 13/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import struct ComicsInfoCore.SeriesSummary
@testable import struct ComicsInfoCore.Series
import Foundation

enum SeriesSummaryFactory {
    
    static func make(ID: String = "1", popularity: Int = 0) -> SeriesSummary {
        make(
            ID: ID,
            link: SeriesFactory.make(ID: "9"),
            popularity: 0,
            name: "SeriesSummary \(ID) Name",
            thumbnail: "SeriesSummary \(ID) Thumbnail",
            description: "SeriesSummary \(ID) Description"
        )
    }

    static func make(
        ID: String = "1",
        link: Series = SeriesFactory.make(ID: "9"),
        popularity: Int = 0,
        name: String = "SeriesSummary 1 Name",
        thumbnail: String? = nil,
        description: String? = nil
    ) -> SeriesSummary {
        SeriesSummary(
            ID: ID,
            link: link,
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
