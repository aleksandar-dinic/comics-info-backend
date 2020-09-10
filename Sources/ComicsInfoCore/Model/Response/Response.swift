//
//  Response.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 09/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

struct Response {

    static let defaultHeaders = [
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "OPTIONS,GET,POST,PUT,DELETE",
        "Access-Control-Allow-Credentials": "true",
    ]

    let statusCode: HTTPResponseStatus
    let headers: [String: String]?
    let multiValueHeaders: [String: [String]]?
    let body: String?
    let isBase64Encoded: Bool?
    let cookies: [String]?

    init(
        statusCode: HTTPResponseStatus,
        headers: [String: String]? = nil,
        multiValueHeaders: [String: [String]]? = nil,
        body: String? = nil,
        isBase64Encoded: Bool? = nil,
        cookies: [String]? = nil
    ) {
        self.statusCode = statusCode
        self.headers = headers
        self.multiValueHeaders = multiValueHeaders
        self.body = body
        self.isBase64Encoded = isBase64Encoded
        self.cookies = cookies
    }

}

extension Response {

    init<Out: Encodable>(
        with object: Out,
        statusCode: HTTPResponseStatus,
        headers: [String: String]? = Self.defaultHeaders,
        multiValueHeaders: [String: [String]]? = nil,
        isBase64Encoded: Bool? = nil,
        cookies: [String]? = nil
    ) {
        var body = "{}"
        if let data = try? JSONEncoder().encode(object) {
            body = String(data: data, encoding: .utf8) ?? body
        }

        self.init(
            statusCode: statusCode,
            headers: headers,
            multiValueHeaders: multiValueHeaders,
            body: body,
            isBase64Encoded: isBase64Encoded,
            cookies: cookies
        )
    }

}

extension Response {

    init(
        with error: Error,
        statusCode: HTTPResponseStatus,
        headers: [String: String]? = Self.defaultHeaders,
        multiValueHeaders: [String: [String]]? = nil,
        isBase64Encoded: Bool? = nil,
        cookies: [String]? = nil
    ) {
        self.init(
            statusCode: statusCode,
            headers: headers,
            multiValueHeaders: multiValueHeaders,
            body: "{\"message\":\"\(String(describing: error))\"}",
            isBase64Encoded: isBase64Encoded,
            cookies: cookies
        )
    }

}
