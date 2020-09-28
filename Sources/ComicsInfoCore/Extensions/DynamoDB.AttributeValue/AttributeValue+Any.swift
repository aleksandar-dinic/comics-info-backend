//
//  AttributeValue+Any.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 27/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import SotoDynamoDB
import Foundation

extension DynamoDB.AttributeValue {

    var value: Any? {
        switch self {
        case let .b(value):
            return value

        case let .bool(value):
            return value

        case let .bs(value):
            return value

        case let .l(value):
            return value

        case let .m(value):
            return value.mapValues { $0.value }

        case let .n(value):
            guard let valueInt = Int(value) else {
                return Double(value)
            }
            return valueInt

        case let .ns(value):
            let valueInt = value.compactMap(Int.init)

            guard !valueInt.isEmpty else {
                return value.compactMap(Double.init)
            }

            return valueInt

        case let .null(value):
            return value

        case let .s(value):
            return value

        case let .ss(value):
            return Set(value)
        }
    }

}
