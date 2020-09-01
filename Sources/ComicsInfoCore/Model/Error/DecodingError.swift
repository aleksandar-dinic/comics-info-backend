//
//  DecodingError.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 01/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

enum DecodingError {

    case keyNotFound(_ key: String)
    case typeMismatch(forKey: String)

}
