//
//  APIError.swift
//  ComicsInfoBackend
//
//  Created by Aleksandar Dinic on 26/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

enum APIError: Error {

    case decodingError(_ error: DecodingError)
    case requestError
    case characterNotFound

}

enum DecodingError {

    case keyNotFound(_ key: String)
    case typeMismatch(forKey: String)

}
