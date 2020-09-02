//
//  CharacterCacheProvider.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 01/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

struct CharacterCacheProvider: CharacterCacheService {

    private let inMemoryCache: InMemoryCache<String, Character>

    init(_ inMemoryCache: InMemoryCache<String, Character> = InMemoryCache()) {
        self.inMemoryCache = inMemoryCache
    }

    func getAllCharacters(on eventLoop: EventLoop) -> EventLoopFuture<[Character]> {
        let promise = eventLoop.makePromise(of: [Character].self)

        eventLoop.execute {
            guard !inMemoryCache.isEmpty else {
                return promise.fail(APIError.charactersNotFound)
            }

            promise.succeed(inMemoryCache.values)
        }

        return promise.futureResult
    }

    func getCharacter(
        withID characterID: String,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<Character> {
        let promise = eventLoop.makePromise(of: Character.self)

        eventLoop.execute {
            guard let character = inMemoryCache[characterID] else {
                return promise.fail(APIError.characterNotFound)
            }
            promise.succeed(character)
        }

        return promise.futureResult
    }

    func save(characters: [Character]) {
        for character in characters {
            inMemoryCache[character.identifier] = character
        }
    }

}
