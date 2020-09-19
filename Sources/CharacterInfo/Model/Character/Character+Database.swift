//
//  Character+Database.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 27/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import ComicsInfoCore
import Foundation

extension Character {

    enum CodingKeys: String, CodingKey {
        case identifier
        case popularity
        case name
        case thumbnail
        case description
    }

    init(from items: [String: Any]) throws {
        let decoder = DatabaseDecoder(from: items)

        identifier = try decoder.decode(String.self, forKey: CodingKeys.identifier)
        popularity = try decoder.decode(Int.self, forKey: CodingKeys.popularity)
        name = try decoder.decode(String.self, forKey: CodingKeys.name)
        thumbnail = try? decoder.decode(String.self, forKey: CodingKeys.thumbnail)
        description = try? decoder.decode(String.self, forKey: CodingKeys.description)
    }

}
