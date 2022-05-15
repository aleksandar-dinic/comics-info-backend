//
//  MySeriesSummary.swift
//  
//
//  Created by Aleksandar Dinic on 1/29/22.
//

import struct Domain.SeriesSummary
import Foundation

struct MySeriesSummary: Codable {
    
    let identifier: String
    let popularity: Int
    let title: String
    let thumbnail: String?
    let description: String?
    let startYear: Int?
    let endYear: Int?
    
}

extension MySeriesSummary: Equatable {

    static func == (lhs: MySeriesSummary, rhs: MySeriesSummary) -> Bool {
        lhs.identifier == rhs.identifier
    }
    
}

extension MySeriesSummary {
    
    init(from seriesSummary: Domain.SeriesSummary) {
        identifier = seriesSummary.identifier
        popularity = seriesSummary.popularity
        title = seriesSummary.title
        thumbnail = seriesSummary.thumbnail
        description = seriesSummary.description
        startYear = seriesSummary.startYear
        endYear = seriesSummary.endYear
    }
    
}

extension MySeriesSummary {
    
    static func make(
        identifier: String = "MySeries#1",
        popularity: Int = 0,
        title: String = "MySeries Title",
        thumbnail: String? = nil,
        description: String? = nil,
        startYear: Int? = nil,
        endYear: Int? = nil
    ) -> MySeriesSummary {
        self.init(
            identifier: identifier,
            popularity: popularity,
            title: title,
            thumbnail: thumbnail,
            description: description,
            startYear: startYear,
            endYear: endYear
        )
    }
    
}
