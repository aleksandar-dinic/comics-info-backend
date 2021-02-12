//
//  Series+Domain.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import struct Domain.Series
import Foundation

extension Series {
    
    init(from series: Domain.Series) {
        var charactersID: Set<String>?
        if let IDs = series.characters?.map({ $0.identifier }), !IDs.isEmpty {
            charactersID = Set(IDs)
        }
        var comicsID: Set<String>?
        if let IDs = series.comics?.map({ $0.identifier }), !IDs.isEmpty {
            comicsID = Set(IDs)
        }

        self.init(
            id: series.identifier,
            popularity: series.popularity,
            title: series.title,
            thumbnail: series.thumbnail,
            description: series.description,
            startYear: series.startYear,
            endYear: series.endYear,
            aliases: series.aliases,
            nextIdentifier: series.nextIdentifier,
            charactersID: charactersID,
            comicsID: comicsID
        )
    }
    
}
