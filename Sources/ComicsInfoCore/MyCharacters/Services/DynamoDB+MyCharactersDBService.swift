//
//  DynamoDB+MyCharactersDBService.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 16/01/2022.
//

import Foundation
import SotoDynamoDB

extension DynamoDB: MyCharactersDBService {
    
    func create(
        _ myCharacter: MyCharacter,
        in table: String
    ) -> EventLoopFuture<MyCharacter> {
        let input = DynamoDB.PutItemCodableInput(
            item: myCharacter,
            tableName: table
        )
        print("Create MyCharacter: \(input)")
        return putItem(input)
            .map { _ in myCharacter }
            .flatMapErrorThrowing {
                print("Create MyCharacter ERROR: \($0)")
                throw $0
            }
    }

    func getMyCharacters(
        for userID: String,
        from table: String
    ) -> EventLoopFuture<[MyCharacter]> {
        let queryInput = DynamoDB.QueryInput(
            expressionAttributeValues: [
                ":userID": .s(userID),
                ":itemType": .s(String.getType(from: MyCharacter.self))
            ],
            indexName: "userID-itemType-index",
            keyConditionExpression: "userID = :userID AND itemType = :itemType",
            tableName: table
        )
        
        print("Get MyCharacters: \(queryInput)")
        return query(queryInput, type: MyCharacter.self).flatMapThrowing {
            guard let items = $0.items, !items.isEmpty else {
                throw DatabaseError.itemsNotFound(withIDs: nil)
            }
            return items
        }.flatMapErrorThrowing {
            print("Get MyCharacters ERROR: \($0)")
            throw $0
        }
    }
    
    func getMyCharacter(
        withID myCharacterID: String,
        for userID: String,
        in table: String
    ) -> EventLoopFuture<MyCharacter> {
        let queryInput = DynamoDB.QueryInput(
            expressionAttributeValues: [
                ":userID": .s(userID),
                ":itemID": .s(myCharacterID)
            ],
            keyConditionExpression: "userID = :userID AND itemID = :itemID",
            tableName: table
        )
        
        print("Get MyCharacter: \(queryInput)")
        return query(queryInput, type: MyCharacter.self).flatMapThrowing {
            guard let item = $0.items?.first else {
                throw DatabaseError.itemNotFound(withID: myCharacterID)
            }
            return item
        }.flatMapErrorThrowing {
            print("Get MyCharacter ERROR: \($0)")
            throw $0
        }
    }

    func update(
        _ myCharacter: MyCharacter,
        in table: String
    ) -> EventLoopFuture<MyCharacter> {
        let input = DynamoDB.DeleteItemInput(
            key: [
                "userID": .s(myCharacter.userID),
                "itemID": .s(myCharacter.itemID)
            ],
            tableName: table
        )

        print("Delete MyCharacter: \(input)")
        return deleteItem(input)
            .flatMap { _ in
                print("Update MyCharacter: \(myCharacter)")
                
                let updateInput = DynamoDB.UpdateItemCodableInput(
                    key: ["userID", "itemID"],
                    returnValues: .updatedOld,
                    tableName: table,
                    updateItem: myCharacter
                )
                return updateItem(updateInput)
                    .map { _ in myCharacter }
                    .flatMapErrorThrowing {
                        print("Update MyCharacter ERROR: \($0)")
                        throw $0
                    }
            }
            .flatMapErrorThrowing {
                print("Delete MyCharacter ERROR: \($0)")
                throw $0
            }
    }

    func delete(
        withID myCharacterID: String,
        for userID: String,
        in table: String
    ) -> EventLoopFuture<MyCharacter> {
        getMyCharacter(withID: myCharacterID, for: userID, in: table)
            .flatMap { myCharacter in
                let input = DynamoDB.DeleteItemInput(
                    key: [
                        "userID": .s(userID),
                        "itemID": .s(myCharacterID)
                    ],
                    tableName: table
                )

                print("Delete MyCharacter: \(input)")
                return deleteItem(input)
                    .map { _ in myCharacter }
                    .flatMapErrorThrowing {
                        print("Delete MyCharacter ERROR: \($0)")
                        throw $0
                    }
            }
    }
    
}
