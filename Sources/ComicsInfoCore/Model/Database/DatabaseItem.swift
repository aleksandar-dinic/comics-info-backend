//
//  DatabaseItem.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 02/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import SotoDynamoDB
import Foundation
import NIO

public struct DatabaseItem {

    private var storage: [String: Any]
    var table: String
    var conditionExpression: String

    var attributeValues: [String: DynamoDB.AttributeValue] {
        storage.compactMapValues { ($0 as? AttributeValueMapper)?.attributeValue }
    }

    init(
        _ storage: [String: Any] = [:],
        table: String,
        conditionExpression: String = "attribute_not_exists(itemID) AND attribute_not_exists(summaryID)"
    ) {
        self.storage = storage
        self.table = table
        self.conditionExpression = conditionExpression
    }

    public subscript(key: String) -> Any? {
        get {
            storage[key]
        }
        set {
            storage[key] = newValue
        }
    }

}
