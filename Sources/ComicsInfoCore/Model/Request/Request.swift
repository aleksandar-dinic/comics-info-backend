//
//  Request.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 10/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

struct Request: Codable {

    let pathParameters: [String: String]?
    let context: Context

}

extension Request {

    enum CodingKeys: String, CodingKey {
        case pathParameters
        case context = "requestContext"
    }

}
