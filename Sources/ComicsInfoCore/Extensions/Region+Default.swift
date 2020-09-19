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

    static var `default`: Region {
        guard let envRegion = Lambda.region else {
            return .eucentral1
        }

        return Region(rawValue: envRegion)
    }

}
