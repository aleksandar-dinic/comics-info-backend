//
//  CharacterCacheServiceMock.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 02/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
@testable import CharacterInfo
import Foundation
import NIO

final class CharacterCacheServiceMock: CharacterCacheService {

    private var characters: [String: Character]

    init(_ characters: [String: Character] = [:]) {
        self.characters = characters
    }

    func getAllCharacters(on eventLoop: EventLoop) -> EventLoopFuture<[Character]> {
        let promise = eventLoop.makePromise(of: [Character].self)

        eventLoop.execute { [weak self] in
            guard let characters = self?.characters, !characters.isEmpty else {
                return promise.fail(APIError.itemsNotFound)
            }

            promise.succeed(Array(characters.values))
        }

        return promise.futureResult
    }

    func getCharacter(withID characterID: String, on eventLoop: EventLoop) -> EventLoopFuture<Character> {
        let promise = eventLoop.makePromise(of: Character.self)

        eventLoop.execute { [weak self] in
            guard let character = self?.characters[characterID] else {
                return promise.fail(APIError.itemNotFound)
            }
            promise.succeed(character)
        }

        return promise.futureResult
    }

    func save(characters: [Character]) {
        for character in characters {
            self.characters[character.identifier] = character
        }
    }

}

extension CharacterCacheServiceMock {

    func setCharacters(_ characters: [Character]) {
        for character in characters {
            self.characters[character.identifier] = character
        }
    }

    func setCharacter(_ character: Character) {
        characters[character.identifier] = character
    }

}
