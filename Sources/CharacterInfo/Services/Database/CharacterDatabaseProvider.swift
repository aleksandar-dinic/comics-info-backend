//
//  CharacterDatabaseProvider.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 26/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import ComicsInfoCore
import Foundation
import NIO

final class CharacterDatabaseProvider: CharacterAPIService {

    private var database: Database
    private let tableName: String

    init(database: Database, tableName: String = DatabaseTable().name) {
        self.database = database
        self.tableName = tableName
    }

    func create(_ character: Character) -> EventLoopFuture<Void> {
        let mirror = Mirror(reflecting: character)
        var item = [String: Any]()

        for child in mirror.children {
            guard let label = child.label else { continue }
            if case Optional<Any>.none = child.value { continue }
            item[label] = child.value
        }

        return database.create(item, tableName: tableName)
    }

    func getAllCharacters(on eventLoop: EventLoop) -> EventLoopFuture<[[String: Any]]?> {
        database.getAll(fromTable: tableName)
    }

    func getCharacter(
        withID characterID: String,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<[String: Any]?> {
        database.get(fromTable: tableName, forID: characterID)
    }

//    func updateCharacter(_ character: Character) -> EventLoopFuture<Character> {
//    }
//
//    func deleteCharacter(forID characterID: String) -> EventLoopFuture<Character> {
//    }

}
