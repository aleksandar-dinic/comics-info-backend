//
//  APIError.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 24/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

public enum APIError: Error, Equatable {

    case requestError
    case itemNotFound
    case itemsNotFound
    case handlerUnknown

}

