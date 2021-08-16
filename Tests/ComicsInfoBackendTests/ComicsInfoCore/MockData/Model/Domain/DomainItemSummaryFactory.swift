//
//  DomainItemSummaryFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 05/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Domain.CharacterSummary
import struct Domain.ComicSummary
import struct Domain.SeriesSummary
import Foundation

enum DomainSummaryFactory {
    
    static func makeCharacterSummary(
        identifier: String = "1",
        popularity: Int = 0,
        name: String = "CharacterSummary Name",
        thumbnail: String? = "CharacterSummary thumbnail",
        description: String? = "CharacterSummary description",
        count: Int? = 0
    ) -> Domain.CharacterSummary {
        Domain.CharacterSummary(
            identifier: identifier,
            popularity: popularity,
            name: name,
            thumbnail: thumbnail,
            description: description,
            count: count
        )
    }
    
    static func makeComicSummary(
        identifier: String = "1",
        popularity: Int = 0,
        title: String = "ComicSummary Name",
        thumbnail: String? = "ComicSummary thumbnail",
        description: String? = "ComicSummary description",
        number: String? = "ComicSummary number",
        published: Date? = Date()
    ) -> Domain.ComicSummary {
        Domain.ComicSummary(
            identifier: identifier,
            popularity: popularity,
            title: title,
            thumbnail: thumbnail,
            description: description,
            number: number,
            published: published
        )
    }
    
    static func makeSeriesSummary(
        identifier: String = "1",
        popularity: Int = 0,
        title: String = "SeriesSummary title",
        thumbnail: String? = "SeriesSummary thumbnail",
        description: String? = "SeriesSummary description"
    ) -> Domain.SeriesSummary {
        Domain.SeriesSummary(
            identifier: identifier,
            popularity: popularity,
            title: title,
            thumbnail: thumbnail,
            description: description
        )
    }
    
}
