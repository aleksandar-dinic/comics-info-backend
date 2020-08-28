//
//  DatabaseTable.swift
//  ComicsInfoBackend
//
//  Created by Aleksandar Dinic on 27/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import enum AWSLambdaRuntime.Lambda
import Foundation

enum DatabaseTable {

    case character
    case series
    case comic

    func getName() -> String {
        switch self {
        case .character:
            return Lambda.env("CHARACTER_TABLE_NAME") ?? ""
        case .series:
            return Lambda.env("SERIES_TABLE_NAME") ?? ""
        case .comic:
            return Lambda.env("COMIC_TABLE_NAME") ?? ""
        }
    }

}
