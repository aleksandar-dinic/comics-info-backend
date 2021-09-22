//
//  Request.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 10/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

public struct Request: Codable {

    public let pathParameters: [String: String]?
    public let queryParameters: [String: String]?
    public let headers: [String: String]?
    public let body: String?
    
    init(
        pathParameters: [String: String]? = nil,
        queryParameters: [String: String]? = nil,
        headers: [String: String]? = nil,
        body: String? = nil
    ) {
        self.pathParameters = pathParameters
        self.queryParameters = queryParameters
        self.headers = headers
        self.body = body
    }
    
    enum CodingKeys: String, CodingKey {
        case pathParameters
        case queryParameters    = "queryStringParameters"
        case headers
        case body
    }

}
