//
//  HTTPMethod.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 04/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

public struct HTTPMethod {

    static var GET: HTTPMethod { HTTPMethod(rawValue: "GET") }
    static var POST: HTTPMethod { HTTPMethod(rawValue: "POST") }
    static var PUT: HTTPMethod { HTTPMethod(rawValue: "PUT") }
    static var PATCH: HTTPMethod { HTTPMethod(rawValue: "PATCH") }
    static var DELETE: HTTPMethod { HTTPMethod(rawValue: "DELETE") }
    static var OPTIONS: HTTPMethod { HTTPMethod(rawValue: "OPTIONS") }
    static var HEAD: HTTPMethod { HTTPMethod(rawValue: "HEAD") }

    let rawValue: String

}
