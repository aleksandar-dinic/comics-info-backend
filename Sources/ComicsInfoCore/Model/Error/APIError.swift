//
//  APIError.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 26/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

enum APIError: Error, Equatable {

    case requestError
    case charactersNotFound
    case characterNotFound

}
