//
//  String+DynamoDBField.swift
//  ComicsInfoBackend
//
//  Created by Aleksandar Dinic on 27/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

extension String {

    enum DynamoDBField: String {

        case identifier
        case popularity
        case name
        case thumbnail
        case description

    }

    static var identifier: String {
        DynamoDBField.identifier.rawValue
    }

    static var popularity: String {
        DynamoDBField.popularity.rawValue
    }

    static var name: String {
        DynamoDBField.name.rawValue
    }

    static var thumbnail: String {
        DynamoDBField.thumbnail.rawValue
    }

    static var description: String {
        DynamoDBField.description.rawValue
    }

}
