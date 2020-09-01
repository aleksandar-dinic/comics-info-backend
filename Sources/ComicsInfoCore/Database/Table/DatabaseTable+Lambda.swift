//
//  DatabaseTable+Lambda.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 31/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import enum AWSLambdaRuntime.Lambda
import Foundation

extension DatabaseTable {

    func getName() -> String {
        switch self {
        case .character:
            return Lambda.characterTableName ?? ""
        case .series:
            return Lambda.seriesTableName ?? ""
        case .comic:
            return Lambda.comicTableName ?? ""
        }
    }

}
