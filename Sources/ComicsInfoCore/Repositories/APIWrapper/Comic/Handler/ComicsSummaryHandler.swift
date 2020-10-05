//
//  ComicsSummaryHandler.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 05/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

protocol ComicsSummaryHandler {

    var decoderService: DecoderService { get }

    func handleComicsSummary(_ items: [DatabaseItem]) -> [ComicSummary]?

}

extension ComicsSummaryHandler {

    func handleComicsSummary(_ items: [DatabaseItem]) -> [ComicSummary]? {
        var comics = [ComicSummary]()

        for item in items {
            guard let comicSummary: ComicSummary = try? decoderService.decode(from: item) else { continue }
            comics.append(comicSummary)
        }

        return !comics.isEmpty ? comics : nil
    }

}
