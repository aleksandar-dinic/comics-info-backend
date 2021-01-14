//
//  DatabaseGetItem.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 14/01/2021.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import SotoDynamoDB
import Foundation
import NIO

public struct DatabaseGetItem: DatabaseItem {

    private var attributeValues: [String: DynamoDB.AttributeValue]
    public var table: String
    public var attributes: [String: Any]

    init(_ attributeValues: [String: DynamoDB.AttributeValue], table: String) {
        self.attributeValues = attributeValues
        self.table = table
        attributes = attributeValues.compactMapValues { $0.value }
    }

}
