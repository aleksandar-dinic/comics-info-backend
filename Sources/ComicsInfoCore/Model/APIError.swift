//
//  APIError.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 24/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

public enum APIError: Error {

    case requestError
    case itemNotFound
    case itemsNotFound
    case invalidItemID(_ description: String)
    case invalidSummaryID(_ description: String)
    case handlerUnknown



}

