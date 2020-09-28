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

extension Data: AttributeValueMapper {

    var attributeValue: DynamoDB.AttributeValue {
        .b(self)
    }

}

extension Bool: AttributeValueMapper {

    var attributeValue: DynamoDB.AttributeValue {
        .bool(self)
    }

}

extension String: AttributeValueMapper {

    var attributeValue: DynamoDB.AttributeValue {
        .s(self)
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

extension Array where Element == Data {

    var attributeValue: DynamoDB.AttributeValue {
        .bs(self)
    }

}

extension Array where Element == Int {

    var attributeValue: DynamoDB.AttributeValue {
        .ns(self.map(String.init))
    }

}

extension Array where Element == Double {

    var attributeValue: DynamoDB.AttributeValue {
        .ns(self.map { String($0) })
    }

}

extension Array where Element: AttributeValueMapper {

    var attributeValue: DynamoDB.AttributeValue {
        .l(self.map { $0.attributeValue })
    }

}

extension Optional: AttributeValueMapper {

    var attributeValue: DynamoDB.AttributeValue {
        switch self {
        case let .some(value):
            guard let attributeValue = (value as? AttributeValueMapper)?.attributeValue else {
                return .null(false)
            }
            return attributeValue
        case .none:
            return .null(true)
        }
    }

}

extension Set: AttributeValueMapper {

    var attributeValue: DynamoDB.AttributeValue {
        if let value = self as? Set<String> {
            return .ss(Array(value).sorted())

        } else if let value = self as? Set<Int> {
            return .ns(value.map(String.init).sorted())

        } else if let value = self as? Set<Double> {
            return .ns(value.map { String($0) }.sorted())
        }

        return .null(true)
    }

}

extension Dictionary: AttributeValueMapper where Key: LosslessStringConvertible, Value: AttributeValueMapper {

    var attributeValue: DynamoDB.AttributeValue {
        var dict = [String: DynamoDB.AttributeValue]()

        for (_, el) in self.enumerated() {
            dict[String(el.key)] = el.value.attributeValue
        }

        return .m(dict)
    }

}
