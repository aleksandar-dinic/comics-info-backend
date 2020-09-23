//
//  SeriesAPIWrapperFactory.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

protocol SeriesAPIWrapperFactory {

    var seriesAPIService: SeriesAPIService { get }
    var seriesDecoderService: SeriesDecoderService { get }

    func makeSeriesAPIWrapper() -> SeriesAPIWrapper

}

extension SeriesAPIWrapperFactory {

    public func makeSeriesAPIWrapper() -> SeriesAPIWrapper {
        SeriesAPIWrapper(
            seriesAPIService: seriesAPIService,
            seriesDecoderService: seriesDecoderService
        )
    }

}
