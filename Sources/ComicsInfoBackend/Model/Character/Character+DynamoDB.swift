//
//  Character+DynamoDB.swift
//  ComicsInfoBackend
//
//  Created by Aleksandar Dinic on 27/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import struct AWSDynamoDB.DynamoDB
import Foundation

extension Character {

    init(from items: [String: Any]) throws {
        guard
            let identifier = items[.identifier] as? String,
            let popularity = items[.popularity] as? Int,
            let name = items[.name] as? String
        else {
            throw APIError.decodingError
        }

        self.identifier = identifier
        self.popularity = popularity
        self.name = name
        self.thumbnail = items[.thumbnail] as? String
        self.description = items[.description] as? String
    }

    init(from items: [String: AWSDynamoDB.DynamoDB.AttributeValue]) throws {
        guard
            case let .s(identifier) = items[.identifier],
            case let .n(popularityString) = items[.popularity],
            let popularity = Int(popularityString),
            case let .s(name) = items[.name]
        else {
            throw APIError.decodingError
        }

        var thumbnail: String?
        if case let .s(thumbnailValue) = items[.thumbnail] {
            thumbnail = thumbnailValue
        }

        var description: String?
        if case let .s(descriptionValue) = items[.description] {
            description = descriptionValue
        }

        self.identifier = identifier
        self.popularity = popularity
        self.name = name
        self.thumbnail = thumbnail
        self.description = description
    }

}
