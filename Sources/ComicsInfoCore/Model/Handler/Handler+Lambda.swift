//
//  Handler+Lambda.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 30/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import enum AWSLambdaRuntime.Lambda
import Foundation

extension Handler {

    static var current: Handler? {
        Handler(rawValue: Lambda.handler)
    }

}
