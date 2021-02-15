//
//  GetComics.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 24/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Logging.Logger
import Foundation
import NIO

protocol GetComics: MissingIDsHandler {
    
    var comicUseCase: ComicUseCase { get }
    
}

extension GetComics {
    
    func getComics(
        on eventLoop: EventLoop,
        forIDs comicsID: Set<String>?,
        from table: String,
        logger: Logger?
    ) -> EventLoopFuture<[Comic]> {
        guard let comicsID = comicsID else {
            return eventLoop.submit { [] }
        }
        
        return comicUseCase.getItems(on: eventLoop, withIDs: comicsID, from: table, logger: logger)
            .flatMapThrowing { try handleMissingIDs($0, IDs: comicsID) }
    }
    
}
