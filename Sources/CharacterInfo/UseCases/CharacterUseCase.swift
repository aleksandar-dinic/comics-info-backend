//
//  CharacterUseCase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 04/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import ComicsInfoCore
import Foundation
import NIO

final class CharacterUseCase {

    private let characterRepository: CharacterRepository

    init(characterRepository: CharacterRepository) {
        self.characterRepository = characterRepository
    }

    func getAllCharacters(
        fromDataSource dataSource: DataSourceLayer,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<[Character]> {
        characterRepository.getAllCharacters(fromDataSource: dataSource, on: eventLoop)
    }

    func getCharacter(
        withID characterID: String,
        fromDataSource dataSource: DataSourceLayer,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<Character> {
        characterRepository.getCharacter(
            withID: characterID,
            fromDataSource: dataSource,
            on: eventLoop
        )
    }

}
