//
//  Response.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 09/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

public struct Response: Codable {

    public static let defaultHeaders = [
        "Content-Type": "application/json",
        "Access-Control-Allow-Methods": "GET,POST,PUT,DELETE"
    ]

    public let statusCode: HTTPResponseStatus
    public let headers: [String: String]?
    public let multiValueHeaders: [String: [String]]?
    public let body: String?
    public let isBase64Encoded: Bool?
    public let cookies: [String]?

    public init(
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

    public init<Out: Encodable>(
        with object: Out,
        statusCode: HTTPResponseStatus,
        headers: [String: String]? = Self.defaultHeaders,
        multiValueHeaders: [String: [String]]? = nil,
        isBase64Encoded: Bool? = nil,
        cookies: [String]? = nil
    ) {
        var body = "{}"
        if let data = try? JSONEncoder().encode(object), let dataEncoded = String(data: data, encoding: .utf8) {
            body = dataEncoded
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
