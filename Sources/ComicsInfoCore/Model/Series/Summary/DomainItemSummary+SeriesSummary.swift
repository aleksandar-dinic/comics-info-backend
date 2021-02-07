//
//  DomainItemSummary+SeriesSummary.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 05/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Domain.ItemSummary
import Foundation

extension Domain.ItemSummary {

    init<Item>(from item: SeriesSummary<Item>) {
        self.init(
            identifier: item.itemID.replacingOccurrences(of: "\(String.getType(from: Series.self))#", with: ""),
            popularity: item.popularity,
            name: item.name,
            thumbnail: item.thumbnail,
            description: item.description,
            count: nil,
            number: nil,
            roles: nil
        )
    }

}
