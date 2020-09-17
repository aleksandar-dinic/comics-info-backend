//
//  HTTPMethod.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 04/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

public struct HTTPMethod: Hashable {

    static var GET: HTTPMethod { HTTPMethod(rawValue: "GET") }
    static var POST: HTTPMethod { HTTPMethod(rawValue: "POST") }
    static var PUT: HTTPMethod { HTTPMethod(rawValue: "PUT") }
    static var PATCH: HTTPMethod { HTTPMethod(rawValue: "PATCH") }
    static var DELETE: HTTPMethod { HTTPMethod(rawValue: "DELETE") }
    static var OPTIONS: HTTPMethod { HTTPMethod(rawValue: "OPTIONS") }
    static var HEAD: HTTPMethod { HTTPMethod(rawValue: "HEAD") }

    let rawValue: String

}

extension HTTPMethod: Codable {

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawMethod = try container.decode(String.self)

        self = HTTPMethod(rawValue: rawMethod)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }

}
