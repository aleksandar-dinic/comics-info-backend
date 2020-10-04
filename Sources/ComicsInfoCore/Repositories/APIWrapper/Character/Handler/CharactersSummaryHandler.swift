//
//  CharactersSummaryHandler.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 03/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

protocol CharactersSummaryHandler {

    var decoderService: DecoderService { get }

    func handleCharactersSummary(_ items: [DatabaseItem]) -> [CharacterSummary]?

}

extension CharactersSummaryHandler {

    func handleCharactersSummary(_ items: [DatabaseItem]) -> [CharacterSummary]? {
        var characters = [CharacterSummary]()

        for item in items {
            guard let characterSummary: CharacterSummary = try? decoderService.decode(from: item) else { continue }
            characters.append(characterSummary)
        }

        return !characters.isEmpty ? characters : nil
    }

}
