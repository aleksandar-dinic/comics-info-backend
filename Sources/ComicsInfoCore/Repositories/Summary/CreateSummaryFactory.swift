//
//  CreateSummaryFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 24/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

protocol CreateSummaryFactory {
    
    var repository: CreateRepository { get }
    
}

extension CreateSummaryFactory {
    
    func createSummaries<Summary: ItemSummary>(
        _ summaries: [Summary]?,
        on eventLoop: EventLoop,
        in table: String
    ) -> EventLoopFuture<Void> {
        guard let summaries = summaries else { return eventLoop.makeSucceededFuture(()) }
        return repository.createSummaries(summaries, in: table)
            .hop(to: eventLoop)
    }
    
}
