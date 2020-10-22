//
//  DatabaseUpdateItem.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 06/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import SotoDynamoDB
import Foundation
import NIO

public struct DatabaseUpdateItem: DatabaseItem {

    public var attributes: [String: Any]
    public var table: String
    private let itemID: String
    private let summaryID: String
    let conditionExpression: String?

    var attributeNames: [String: String] {
        attributes.keys.reduce(into: [String: String]()) { $0["#\($1)"] = $1 }
    }

    var attributeValues: [String: DynamoDB.AttributeValue] {
        attributes.reduce(into: [String: DynamoDB.AttributeValue]()) {
            $0[":\($1.key)"] = ($1.value as? AttributeValueMapper)?.attributeValue
        }
    }

    var key: [String: DynamoDB.AttributeValue] {
        [
            "itemID": itemID.attributeValue,
            "summaryID": summaryID.attributeValue
        ]
    }

    var updateExpression: String {
        var expression = "SET"

        for attribute in attributes.keys {
            expression = "\(expression) #\(attribute) = :\(attribute),"
        }
        expression.removeLast()

        return expression
    }

    init(
        _ attributes: [String: Any] = [:],
        table: String,
        itemID: String,
        summaryID: String,
        conditionExpression: String? = "attribute_exists(itemID) AND attribute_exists(summaryID)"
    ) {
        self.attributes = attributes
        self.table = table
        self.itemID = itemID
        self.summaryID = summaryID
        self.conditionExpression = conditionExpression
    }

}
