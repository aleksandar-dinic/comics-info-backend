//
//  SeriesSummaryHandler.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 03/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

protocol SeriesSummaryHandler {

    var decoderService: DecoderService { get }

    func handleSeriesSummary(_ items: [DatabaseItem]) -> [SeriesSummary]?

}

extension SeriesSummaryHandler {

    func handleSeriesSummary(_ items: [DatabaseItem]) -> [SeriesSummary]? {
        var series = [SeriesSummary]()

        for item in items {
            guard let seriesSummary: SeriesSummary = try? decoderService.decode(from: item) else { continue }
            series.append(seriesSummary)
        }

        return !series.isEmpty ? series : nil
    }

}
