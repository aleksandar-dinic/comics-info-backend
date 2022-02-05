//
//  DynamoDB+FeedbackDBService.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 02/09/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import SotoDynamoDB

extension DynamoDB: FeedbackDBService {
    
    func create(_ feedback: Feedback, in table: String) -> EventLoopFuture<Feedback> {
        let item = DynamoDB.PutItemCodableInput(
            conditionExpression: "attribute_not_exists(itemID)",
            item: feedback,
            tableName: table
        )
        print("Create feedback: \(item)")
        return putItem(item)
            .map { _ in feedback }
            .flatMapErrorThrowing {
                print("Create feedback ERROR: \($0)")
                throw $0
            }
    }
    
}
