//
//  Lambda+Environment.swift
//  ComicsInfoBackend
//
//  Created by Aleksandar Dinic on 30/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import enum AWSLambdaRuntime.Lambda
import Foundation

extension Lambda {

    static var region: String? {
        Lambda.env("AWS_REGION")
    }

    static var handler: String? {
        Lambda.env("_HANDLER")
    }

    static var characterTableName: String? {
        Lambda.env("CHARACTER_TABLE_NAME")
    }

    static var seriesTableName: String? {
        Lambda.env("SERIES_TABLE_NAME")
    }

    static var comicTableName: String? {
        Lambda.env("COMIC_TABLE_NAME")
    }

}
