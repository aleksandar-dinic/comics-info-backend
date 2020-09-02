//
//  CharacterDataProvider.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 01/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

struct CharacterDataProvider {

    private let characterAPIWrapper: CharacterAPIWrapper
    private let characterCacheService: CharacterCacheService

    init(
        characterAPIWrapper: CharacterAPIWrapper,
        characterCacheService: CharacterCacheService
    ) {
        self.characterAPIWrapper = characterAPIWrapper
        self.characterCacheService = characterCacheService
    }

    // Get all characters

    func getAllCharacters(
        fromDataSource dataSource: DataSourceLayer,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<[Character]> {
        switch dataSource {
        case .memory:
            return getAllCharactersFromMemory(on: eventLoop)

        case .database:
            return getAllCharactersFromDatabase(on: eventLoop)
        }
    }

    private func getAllCharactersFromMemory(on eventLoop: EventLoop) -> EventLoopFuture<[Character]> {
        characterCacheService.getAllCharacters(on: eventLoop).flatMapError { _ in
            getAllCharactersFromDatabase(on: eventLoop)
        }
    }

    private func getAllCharactersFromDatabase(on eventLoop: EventLoop) -> EventLoopFuture<[Character]> {
        characterAPIWrapper.getAllCharacters(on: eventLoop).always { result in
            guard let characters = try? result.get() else { return }
            characterCacheService.save(characters: characters)
        }
    }

    // Get Character

    func getCharacter(
        withID characterID: String,
        fromDataSource dataSource: DataSourceLayer,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<Character> {
        switch dataSource {
        case .memory:
            return getCharacterFromMemory(withID: characterID, on: eventLoop)

        case .database:
            return getCharacterFromDatabase(withID: characterID, on: eventLoop)
        }
    }

    private func getCharacterFromMemory(
        withID characterID: String,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<Character>  {
        characterCacheService.getCharacter(withID: characterID, on: eventLoop).flatMapError { _ in
            getCharacterFromDatabase(withID: characterID, on: eventLoop)
        }
    }

    private func getCharacterFromDatabase(
        withID characterID: String,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<Character> {
        characterAPIWrapper.getCharacter(withID: characterID, on: eventLoop).always { result in
            guard let character = try? result.get() else { return }
            characterCacheService.save(characters: [character])
        }
    }
    
}
