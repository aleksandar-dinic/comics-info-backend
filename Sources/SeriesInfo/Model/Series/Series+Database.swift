//
//  Series+Database.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import ComicsInfoCore
import Foundation

extension Series {

    enum CodingKeys: String, CodingKey {
        case identifier
        case popularity
        case title
        case description
        case startYear
        case endYear
        case thumbnail
        case charactersID
        case nextIdentifier
    }

    init(from items: [String: Any]) throws {
        let decoder = DatabaseDecoder(from: items)

        identifier = try decoder.decode(String.self, forKey: CodingKeys.identifier)
        popularity = try decoder.decode(Int.self, forKey: CodingKeys.popularity)
        title = try decoder.decode(String.self, forKey: CodingKeys.title)
        description = try? decoder.decode(String.self, forKey: CodingKeys.description)
        startYear = try? decoder.decode(Int.self, forKey: CodingKeys.startYear)
        endYear = try? decoder.decode(Int.self, forKey: CodingKeys.endYear)
        thumbnail = try? decoder.decode(String.self, forKey: CodingKeys.thumbnail)
        charactersID = try decoder.decode(Set<String>.self, forKey: CodingKeys.charactersID)
        nextIdentifier = try? decoder.decode(String.self, forKey: CodingKeys.nextIdentifier)
    }

}
