//
//  SeriesGetAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 03/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

struct SeriesGetAPIWrapper: GetAPIWrapper {

    let repositoryAPIService: RepositoryAPIService
    let decoderService: DecoderService

    func handleItem(_ items: [DatabaseItem], id: String) throws -> Series {
        var dbSeries: SeriesDatabase = try handleDatabaseItem(items, id: id)
        dbSeries.charactersSummary = handleCharactersSummary(items)

        return Series(from: dbSeries)
    }

}
