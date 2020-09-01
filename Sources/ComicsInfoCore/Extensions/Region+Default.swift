//
//  Region+Default.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 27/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import AWSDynamoDB
import enum AWSLambdaRuntime.Lambda
import Foundation

extension Region {

    static var `default`: Region {
        guard let envRegion = Lambda.region else {
            return .eucentral1
        }

        return Region(rawValue: envRegion)
    }

}
