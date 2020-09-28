//
//  CharacterDecoderProvider.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 02/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import ComicsInfoCore
import Foundation

struct CharacterDecoderProvider: CharacterDecoderService {
    
    func decodeAllCharacters(from items: [[String : Any]]?) throws -> [Character] {
        guard let items = items else {
            throw APIError.itemsNotFound
        }
        
        return try items.compactMap { try Character(from: $0) }
    }

    func decodeCharacter(from items: [String : Any]?) throws -> Character {
        guard let items = items else {
            throw APIError.itemNotFound
        }
        return try Character(from: items)
    }

}
