//
//  String+Database.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 27/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import enum AWSLambdaRuntime.Lambda
import Foundation

public extension String {

    static func tableName(for environment: String?) -> String {
        Lambda.tableName(for: environment) ?? ""
    }

    static func getType(from item: Any.Type) -> String {
        "\(item.self)".lowercased()
    }

}
