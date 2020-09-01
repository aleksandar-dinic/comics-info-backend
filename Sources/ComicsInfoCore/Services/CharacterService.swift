//
//  CharacterService.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 26/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

final class CharacterService {

    private let database: Database
    private let tableName: String

    init(database: Database, tableName: String = DatabaseTable.character.getName()) {
        self.database = database
        self.tableName = tableName
    }

    func getAllCharacters() -> EventLoopFuture<[Character]> {
        database.getAll(fromTable: .character).flatMapThrowing {
            try $0?.compactMap { try Character(from: $0) } ?? []
        }
    }

    func getCharacter(forID characterID: String) -> EventLoopFuture<Character> {
        database.get(fromTable: .character, forID: characterID).flatMapThrowing { items in
            guard let items = items else {
                throw APIError.characterNotFound
            }
            return try Character(from: items)
        }
    }

//    func createCharacter(_ character: Character) -> EventLoopFuture<Character> {
//    }
//
//    func updateCharacter(_ character: Character) -> EventLoopFuture<Character> {
//    }
//
//    func deleteCharacter(forID characterID: String) -> EventLoopFuture<Character> {
//    }

}
