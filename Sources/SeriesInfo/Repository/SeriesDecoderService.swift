//
//  SeriesDecoderService.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

protocol SeriesDecoderService {

    func decodeAllSeries(from items: [[String: Any]]?) throws -> [Series]

    func decodeSeries(from items: [String: Any]?) throws -> Series

}
