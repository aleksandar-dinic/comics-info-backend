//
//  String+DatabaseField.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

extension String {

    enum DatabaseField: String {

        case identifier
        case popularity
        case title
        case description
        case startYear
        case endYear
        case thumbnail
        case charactersID
        case nextIdentifier

    }

    static var identifier: String {
        DatabaseField.identifier.rawValue
    }

    static var popularity: String {
        DatabaseField.popularity.rawValue
    }

    static var title: String {
        DatabaseField.title.rawValue
    }

    static var thumbnail: String {
        DatabaseField.thumbnail.rawValue
    }

    static var description: String {
        DatabaseField.description.rawValue
    }

    static var startYear: String {
        DatabaseField.startYear.rawValue
    }

    static var endYear: String {
        DatabaseField.endYear.rawValue
    }

    static var charactersID: String {
        DatabaseField.charactersID.rawValue
    }

    static var nextIdentifier: String {
        DatabaseField.nextIdentifier.rawValue
    }

}
