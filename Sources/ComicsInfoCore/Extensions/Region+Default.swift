//
//  Region+Default.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 27/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import enum AWSLambdaRuntime.Lambda
import Foundation
import SotoDynamoDB

extension Region {

    static func getFromEnvironment(_ region: String? = Lambda.region) -> Region {
        guard let region = region else {
            return .eucentral1
        }

        return Region(rawValue: region)
    }

}
