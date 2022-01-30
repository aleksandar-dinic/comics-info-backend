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
