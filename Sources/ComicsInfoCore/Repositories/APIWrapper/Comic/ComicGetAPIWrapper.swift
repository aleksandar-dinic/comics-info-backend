//
//  ComicGetAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 05/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

struct ComicGetAPIWrapper: GetAPIWrapper {

    let repositoryAPIService: RepositoryAPIService
    let decoderService: DecoderService

    func handleItem(_ items: [DatabaseItem], id: String) throws -> Comic {
        var dbComic: ComicDatabase = try handleDatabaseItem(items, id: id)

        dbComic.charactersSummary = handleCharactersSummary(items)
        dbComic.seriesSummary = handleSeriesSummary(items)

        return Comic(from: dbComic)
    }

}
