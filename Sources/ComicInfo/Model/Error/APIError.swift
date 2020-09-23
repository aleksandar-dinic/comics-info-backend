//
//  APIError.swift
//  ComicInfo
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

enum APIError: Error, Equatable {

    case requestError
    case comicsNotFound
    case comicNotFound
    case handlerUnknown

}
