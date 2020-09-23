//
//  CharacterRepository.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 01/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import ComicsInfoCore
import Foundation
import NIO

final class CharacterRepository {

    private let characterDataProvider: CharacterDataProvider

    init(characterDataProvider: CharacterDataProvider) {
        self.characterDataProvider = characterDataProvider
    }

    /// Create character.
    ///
    /// - Parameter character: The character.
    /// - Returns: Future with Character value.
    func create(_ character: Character) -> EventLoopFuture<Void> {
        characterDataProvider.create(character)
    }

    /// Gets all characters.
    ///
    /// - Parameter dataSource: Layer of data source.
    /// - Returns: Future with Characters value.
    func getAllCharacters(
        fromDataSource dataSource: DataSourceLayer,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<[Character]> {
        characterDataProvider.getAllCharacters(fromDataSource: dataSource, on: eventLoop)
    }

    /// Gets character.
    ///
    /// - Parameters:
    ///   - characterID: Character ID.
    ///   - dataSource: Layer of data source
    /// - Returns: Future with Character value.
    func getCharacter(
        withID characterID: String,
        fromDataSource dataSource: DataSourceLayer,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<Character> {
        characterDataProvider.getCharacter(
            withID: characterID,
            fromDataSource: dataSource,
            on: eventLoop
        )
    }
    
}
