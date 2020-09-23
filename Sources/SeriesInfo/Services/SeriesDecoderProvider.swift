//
//  SeriesDecoderProvider.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

struct SeriesDecoderProvider: SeriesDecoderService {

    func decodeAllSeries(from items: [[String : Any]]?) throws -> [Series] {
        guard let items = items else {
            throw APIError.seriesNotFound
        }

        return try items.compactMap { try Series(from: $0) }
    }

    func decodeSeries(from items: [String : Any]?) throws -> Series {
        guard let items = items else {
            throw APIError.seriesNotFound
        }
        return try Series(from: items)
    }

}
