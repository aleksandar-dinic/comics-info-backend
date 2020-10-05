//
//  Series.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

public struct Series: Codable, Identifiable {

    /// The unique ID of the series resource.
    public let id: String

    /// The value of Series popularity
    let popularity: Int

    /// The canonical title of the series.
    let title: String

    /// The representative image for this series.
    let thumbnail: String?

    /// A description of the series.
    let description: String?

    /// The first year of publication for the series.
    let startYear: Int?

    /// The last year of publication for the series (conventionally, nil for ongoing series) .
    let endYear: Int?

    /// ID of the series which follows this series.
    let nextIdentifier: String?

    /// A resource list containing charactersID which appear in comics in this series.
    let charactersID: Set<String>?

    /// A resource list containing characters which appear in comics in this series.
    let characters: [Character]?

    /// A resource list containing comicsID in this series.
    let comicsID: Set<String>?

    /// A resource list containing comics in this series.
    let comics: [Comic]?

}
