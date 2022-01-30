//
//  MyCharactersRepository.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 16/01/2022.
//

import Foundation
import NIO

public final class MyCharactersRepository {

    private let dbWrapper: MyCharactersDBWrapper

    init(dbWrapper: MyCharactersDBWrapper) {
        self.dbWrapper = dbWrapper
    }

    func create(
        _ myCharacter: MyCharacter,
        in table: String
    ) -> EventLoopFuture<MyCharacter> {
        dbWrapper.create(myCharacter, in: table)
    }

    func getMyCharacters(
        for userID: String,
        from table: String
    ) -> EventLoopFuture<[MyCharacter]> {
        dbWrapper.getMyCharacters(for: userID, from: table)
    }
    
    func getMyCharacter(
        withID characterID: String,
        for userID: String,
        in table: String
    ) -> EventLoopFuture<MyCharacter> {
        dbWrapper.getMyCharacter(withID: characterID, for: userID, in: table)
    }

    func update(
        _ myCharacter: MyCharacter,
        in table: String
    ) -> EventLoopFuture<MyCharacter> {
        dbWrapper.update(myCharacter, in: table)
    }

    func delete(
        withID characterID: String,
        for userID: String,
        in table: String
    ) -> EventLoopFuture<MyCharacter> {
        dbWrapper.delete(withID: characterID, for: userID, in: table)
    }

}
