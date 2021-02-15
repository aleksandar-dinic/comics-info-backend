//
//  GetSeries.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 24/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Logging.Logger
import Foundation
import NIO

protocol GetSeries: MissingIDsHandler {
    
    var seriesUseCase: SeriesUseCase { get }
    
}

extension GetSeries {
    
    func getSeries(
        on eventLoop: EventLoop,
        forIDs seriesID: Set<String>?,
        from table: String,
        logger: Logger?
    ) -> EventLoopFuture<[Series]> {
        guard let seriesID = seriesID else {
            return eventLoop.submit { [] }
        }

        return seriesUseCase.getItems(on: eventLoop, withIDs: seriesID, from: table, logger: logger)
            .flatMapThrowing { try handleMissingIDs($0, IDs: seriesID) }
    }
    
}
