//
//  ItemSummary+Domain.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 21/01/2021.
//

import struct Domain.ItemSummary
import Foundation

extension Domain.ItemSummary {

    init<Item: SummaryMapper>(from item: ItemSummary<Item>) {
        self.init(
            identifier: item.id,
            popularity: item.popularity,
            name: item.name,
            thumbnail: item.thumbnail,
            description: item.description,
            count: item.count,
            number: item.number,
            roles: item.roles)
    }

}
