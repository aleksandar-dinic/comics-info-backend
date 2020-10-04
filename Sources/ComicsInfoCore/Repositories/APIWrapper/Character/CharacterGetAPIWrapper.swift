//
//  CharacterGetAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 30/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

struct CharacterGetAPIWrapper: GetAPIWrapper {

    let repositoryAPIService: RepositoryAPIService
    let decoderService: DecoderService

    func handleItem(_ items: [DatabaseItem], id: String) throws -> Character {
        var dbCharacter: CharacterDatabase = try handleDatabaseItem(items, id: id)
        dbCharacter.seriesSummary = handleSeriesSummary(items)

        return Character(from: dbCharacter)
    }

}
