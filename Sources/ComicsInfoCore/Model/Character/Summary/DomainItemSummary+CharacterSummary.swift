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

    init(from summary: CharacterSummary) {
        self.init(
            identifier: summary.itemID.getIDFromComicInfoID(for: Character.self),
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
