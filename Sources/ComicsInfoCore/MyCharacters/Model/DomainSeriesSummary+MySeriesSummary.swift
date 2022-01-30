//
//  DomainSeriesSummary+MySeriesSummary.swift
//  
//
//  Created by Aleksandar Dinic on 1/29/22.
//

import struct Domain.SeriesSummary
import Foundation

extension Domain.SeriesSummary {
    
    init(from mySeriesSummary: MySeriesSummary) {
        self.init(
            identifier: mySeriesSummary.identifier,
            popularity: mySeriesSummary.popularity,
            title: mySeriesSummary.title,
            thumbnail: mySeriesSummary.thumbnail,
            description: mySeriesSummary.description,
            startYear: mySeriesSummary.startYear,
            endYear: mySeriesSummary.endYear
        )
    }
    
}
