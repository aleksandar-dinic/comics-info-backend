//
//  Lambda.Context+Environment.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 25/11/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import AWSLambdaRuntime
import Foundation

extension Lambda.Context {

    var environment: String? {
        guard let environment = invokedFunctionARN.split(separator: ":").last, !environment.isEmpty else {
            return nil
        }

        return String(environment)
    }

}
