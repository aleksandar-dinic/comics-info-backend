//
//  Lambda+Environment.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import enum AWSLambdaRuntime.Lambda
import Foundation

extension Lambda {

    static var seriesTableName: String? {
        Lambda.env("SERIES_TABLE_NAME")
    }

}
