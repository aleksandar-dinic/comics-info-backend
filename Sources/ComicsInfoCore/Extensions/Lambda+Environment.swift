//
//  Lambda+Environment.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 30/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import enum AWSLambdaRuntime.Lambda
import Foundation

public extension Lambda {

    static var region: String? {
        Lambda.env("AWS_REGION")
    }

    static var handler: String {
        Lambda.env("_HANDLER") ?? ""
    }

    static func tableName(for environment: String?) -> String? {
        let tableName = "TABLE_NAME"
        guard let environment = environment else {
            return Lambda.env(tableName)
        }
        return Lambda.env("\(tableName)_\(environment)")
    }
    
    static var queryLimit: String? {
        Lambda.env("QUERY_LIMIT")
    }

}
