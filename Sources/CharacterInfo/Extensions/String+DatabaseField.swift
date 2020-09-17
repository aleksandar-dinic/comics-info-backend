//
//  String+DatabaseField.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 27/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

extension String {

    enum DatabaseField: String {

        case identifier
        case popularity
        case name
        case thumbnail
        case description

    }

    static var identifier: String {
        DatabaseField.identifier.rawValue
    }

    static var popularity: String {
        DatabaseField.popularity.rawValue
    }

    static var name: String {
        DatabaseField.name.rawValue
    }

    static var thumbnail: String {
        DatabaseField.thumbnail.rawValue
    }

    static var description: String {
        DatabaseField.description.rawValue
    }

}
