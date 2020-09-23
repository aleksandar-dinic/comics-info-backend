//
//  Series.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

struct Series: Codable {

    /// The unique ID of the series resource.
    let identifier: String

    /// The value of Series popularity
    let popularity: Int

    /// The canonical title of the series.
    let title: String

    /// A description of the series.
    let description: String?

    /// The first year of publication for the series.
    let startYear: Int?

    /// The last year of publication for the series (conventionally, nil for ongoing series) .
    let endYear: Int?

    /// The representative image for this series.
    let thumbnail: String?

    /// A resource list containing characters ID which appear in comics in this series.
    let charactersID: Set<String>

    /// ID of the series which follows this series.
    let nextIdentifier: String?

}
