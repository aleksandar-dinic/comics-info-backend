//
//  DatabasePutItem.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 06/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import SotoDynamoDB
import Foundation
import NIO

public struct DatabasePutItem: DatabaseItem {

    public var attributes: [String: Any]
    public var table: String
    var conditionExpression: String

    var attributeValues: [String: DynamoDB.AttributeValue] {
        attributes.compactMapValues { ($0 as? AttributeValueMapper)?.attributeValue }
    }

    init(
        _ attributes: [String: Any] = [:],
        table: String,
        conditionExpression: String = "attribute_not_exists(itemID) AND attribute_not_exists(summaryID)"
    ) {
        self.attributes = attributes
        self.table = table
        self.conditionExpression = conditionExpression
    }

}
