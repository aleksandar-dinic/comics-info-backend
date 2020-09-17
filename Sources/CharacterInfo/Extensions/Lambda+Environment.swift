//
//  Lambda+Environment.swift
//  CharacterInfo
//
//  Created by Aleksandar Dinic on 17/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import enum AWSLambdaRuntime.Lambda
import Foundation

extension Lambda {

    static var characterTableName: String? {
        Lambda.env("CHARACTER_TABLE_NAME")
    }

}
