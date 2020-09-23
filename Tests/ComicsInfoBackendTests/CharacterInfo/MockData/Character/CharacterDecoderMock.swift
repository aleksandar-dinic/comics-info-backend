//
//  CharacterDecoderMock.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 02/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import CharacterInfo
import Foundation

final class CharacterDecoderMock: CharacterDecoderService {

    private let characters: [Character]

    init(_ characters: [Character] = []) {
        self.characters = characters
    }

    func decodeAllCharacters(from items: [[String: Any]]?) throws -> [Character] {
        guard !characters.isEmpty else {
            throw APIError.charactersNotFound
        }

        return characters
    }

    func decodeCharacter(from items: [String: Any]?) throws -> Character {
        guard let character = characters.first else {
            throw APIError.characterNotFound
        }
        return character
    }

}
