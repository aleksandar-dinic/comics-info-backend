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
    private var attributes: [String: Any]

    init(id: String, attributes: [String: DynamoDB.AttributeValue] = [:]) {
        self.id = id
        self.attributes = attributes.compactMapValues { $0.value }
    }
    
    func getAllAttributes() -> [String: Any] {
        attributes
    }
    
    func getItemID() -> String {
        attributes["itemID"] as? String ?? ""
    }
    
}
