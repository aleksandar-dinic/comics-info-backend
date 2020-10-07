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

public protocol DatabaseItem {

    var attributes: [String: Any] { get set }
    var table: String { get }

    subscript(key: String) -> Any? { get }

}

extension DatabaseItem {

    public subscript(key: String) -> Any? {
        get {
            attributes[key]
        }
        set {
            attributes[key] = newValue
        }
    }

}
