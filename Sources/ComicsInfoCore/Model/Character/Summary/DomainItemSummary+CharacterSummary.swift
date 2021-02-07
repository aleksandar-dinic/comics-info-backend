//
//  DomainItemSummary+CharacterSummary.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 05/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Domain.ItemSummary
import Foundation

extension Domain.ItemSummary {

    init<Item>(from summary: CharacterSummary<Item>) {
        self.init(
            identifier: summary.itemID.replacingOccurrences(of: "\(String.getType(from: Character.self))#", with: ""),
            popularity: summary.popularity,
            name: summary.name,
            thumbnail: summary.thumbnail,
            description: summary.description,
            count: summary.count,
            number: nil,
            roles: nil
        )
    }

}
