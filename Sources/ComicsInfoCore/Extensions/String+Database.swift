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

    static var characterTableName: String {
        Lambda.characterTableName ?? ""
    }

    static var seriesTableName: String {
        Lambda.seriesTableName ?? ""
    }

    static var characterType: String {
        "character"
    }

    static var seriesType: String {
        "series"
    }

}
