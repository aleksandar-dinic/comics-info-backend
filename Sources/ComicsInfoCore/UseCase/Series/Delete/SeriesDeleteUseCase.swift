//
//  SeriesDeleteUseCase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 30/04/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Logging.Logger
import Foundation
import NIO

public final class SeriesDeleteUseCase: DeleteUseCase {
    
    public typealias Item = Series
    
    public let deleteRepository: DeleteRepository
    let seriesUseCase: SeriesUseCase

    public init(deleteRepository: DeleteRepository, seriesUseCase: SeriesUseCase) {
        self.deleteRepository = deleteRepository
        self.seriesUseCase = seriesUseCase
    }
    
    public func getItem(
        withID ID: String,
        on eventLoop: EventLoop,
        from table: String,
        logger: Logger?
    ) -> EventLoopFuture<Item> {
        seriesUseCase.getItem(
            on: eventLoop,
            withID: ID,
            fields: nil,
            from: table,
            logger: logger,
            dataSource: .database
        )
    }
    
}
