//
//  TableMock.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 11/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct SotoDynamoDB.DynamoDB
import Foundation

public struct TableMock {
    
    private var id: String
    private(set) var attributesValue: [String: DynamoDB.AttributeValue]
    private(set) var attributes: [String: Any]

    init(id: String, attributesValue: [String: DynamoDB.AttributeValue]) {
        self.id = id
        self.attributesValue = attributesValue
        self.attributes = attributesValue.compactMapValues { $0.value }
    }
    
    func getItemID() -> String {
        attributes["itemID"] as? String ?? ""
    }
    
}
