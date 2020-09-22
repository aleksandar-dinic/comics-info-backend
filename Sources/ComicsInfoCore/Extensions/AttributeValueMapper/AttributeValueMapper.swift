//
//  AttributeValueMapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 22/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import SotoDynamoDB
import Foundation

protocol AttributeValueMapper {

    var attributeValue: DynamoDB.AttributeValue { get }

}

extension String: AttributeValueMapper {

    var attributeValue: DynamoDB.AttributeValue {
        .s(self)
    }

}

extension Bool: AttributeValueMapper {

    var attributeValue: DynamoDB.AttributeValue {
        .bool(self)
    }

}

extension Double: AttributeValueMapper {

    var attributeValue: DynamoDB.AttributeValue {
        .n(String(self))
    }

}

extension Int: AttributeValueMapper {

    var attributeValue: DynamoDB.AttributeValue {
        .n(String(self))
    }

}

extension Array: AttributeValueMapper where Element == String {

    var attributeValue: DynamoDB.AttributeValue {
        .ss(self)
    }

}

extension Optional: AttributeValueMapper {

    var attributeValue: DynamoDB.AttributeValue {
        .null(self != nil)
    }

}
