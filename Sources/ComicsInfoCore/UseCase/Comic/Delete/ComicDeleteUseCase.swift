//
//  ComicDeleteUseCase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 30/04/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Logging.Logger
import Foundation
import NIO

public final class ComicDeleteUseCase: DeleteUseCase {
    
    public typealias Item = Comic
    
    public let deleteRepository: DeleteRepository
    let comicUseCase: ComicUseCase

    public init(deleteRepository: DeleteRepository, comicUseCase: ComicUseCase) {
        self.deleteRepository = deleteRepository
        self.comicUseCase = comicUseCase
    }
    
    public func getItem(
        withID ID: String,
        on eventLoop: EventLoop,
        from table: String,
        logger: Logger?
    ) -> EventLoopFuture<Item> {
        comicUseCase.getItem(
            on: eventLoop,
            withID: ID,
            fields: nil,
            from: table,
            logger: logger,
            dataSource: .database
        )
    }
    
}
