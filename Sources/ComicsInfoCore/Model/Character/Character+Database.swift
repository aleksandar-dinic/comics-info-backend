//
//  Character+Database.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 27/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

extension Character {

    init(from items: [String: Any]) throws {
        let decoder = DatabaseDecoder(from: items)

        identifier = try decoder.decode(String.self, forKey: .identifier)
        popularity = try decoder.decode(Int.self, forKey: .popularity)
        name = try decoder.decode(String.self, forKey: .name)
        thumbnail = try? decoder.decode(String.self, forKey: .thumbnail)
        description = try? decoder.decode(String.self, forKey: .description)
    }

}
