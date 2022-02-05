//
//  DynamoDB+MyComicsDBService.swift
//  
//
//  Created by Aleksandar Dinic on 2/5/22.
//

import Foundation
import SotoDynamoDB

extension DynamoDB: MyComicsDBService {
    
    func create(
        _ myComic: MyComic,
        table: String
    ) -> EventLoopFuture<MyComic> {
        let input = DynamoDB.PutItemCodableInput(
            item: myComic,
            tableName: table
        )
        print("Create MyComic: \(input)")
        return putItem(input)
            .map { _ in myComic }
            .flatMapErrorThrowing {
                print("Create MyComic ERROR: \($0)")
                throw $0
            }
    }

    func getMyComics(
        seriesID: String,
        userID: String,
        table: String
    ) -> EventLoopFuture<[MyComic]> {
        let queryInput = DynamoDB.QueryInput(
            expressionAttributeValues: [
                ":userID": .s(userID),
                ":comicInSeriesID": .s(seriesID)
            ],
            indexName: "userID-comicInSeriesID-index",
            keyConditionExpression: "userID = :userID AND comicInSeriesID = :comicInSeriesID",
            tableName: table
        )
        
        print("Get MyComics: \(queryInput)")
        return query(queryInput, type: MyComic.self).flatMapThrowing {
            guard let items = $0.items, !items.isEmpty else {
                throw DatabaseError.itemsNotFound(withIDs: nil)
            }
            return items
        }.flatMapErrorThrowing {
            print("Get MyComics ERROR: \($0)")
            throw $0
        }
    }
    
    func getMyComic(
        withID itemID: String,
        userID: String,
        table: String
    ) -> EventLoopFuture<MyComic> {
        let queryInput = DynamoDB.QueryInput(
            expressionAttributeValues: [
                ":userID": .s(userID),
                ":itemID": .s(itemID)
            ],
            keyConditionExpression: "userID = :userID AND itemID = :itemID",
            tableName: table
        )
        
        print("Get MyComic: \(queryInput)")
        return query(queryInput, type: MyComic.self).flatMapThrowing {
            guard let item = $0.items?.first else {
                throw DatabaseError.itemNotFound(withID: itemID)
            }
            return item
        }.flatMapErrorThrowing {
            print("Get MyComic ERROR: \($0)")
            throw $0
        }
    }

    func update(
        _ myComic: MyComic,
        table: String
    ) -> EventLoopFuture<MyComic> {
        delete(
            withID: myComic.itemID,
            userID: myComic.userID,
            table: table
        ).flatMap { _ in
            let updateInput = DynamoDB.UpdateItemCodableInput(
                key: ["userID", "itemID"],
                returnValues: .updatedOld,
                tableName: table,
                updateItem: myComic
            )
            
            print("Update MyComic: \(updateInput)")
            return updateItem(updateInput)
                .map { _ in myComic }
                .flatMapErrorThrowing {
                    print("Update MyComic ERROR: \($0)")
                    throw $0
                }
        }
    }

    func delete(
        withID itemID: String,
        userID: String,
        table: String
    ) -> EventLoopFuture<MyComic> {
        getMyComic(withID: itemID, userID: userID, table: table)
            .flatMap { myComic in
                let input = DynamoDB.DeleteItemInput(
                    key: [
                        "userID": .s(userID),
                        "itemID": .s(itemID)
                    ],
                    tableName: table
                )

                print("Delete MyComic: \(input)")
                
                return deleteItem(input)
                    .map { _ in myComic }
                    .flatMapErrorThrowing {
                        print("Delete MyComic ERROR: \($0)")
                        throw $0
                    }
            }
    }
    
}
