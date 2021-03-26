//
//  Int+Database.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 26/03/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import enum AWSLambdaRuntime.Lambda
import Foundation

extension Int {
    
    static var queryLimit: Int {
        let `default` = 20
        guard let limit = Lambda.queryLimit else {
            return `default`
        }
        return Int(limit) ?? `default`
    }
    
}
