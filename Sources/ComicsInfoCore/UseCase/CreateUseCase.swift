//
//  CreateUseCase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 08/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public protocol CreateUseCase {

    associatedtype Item: ComicInfoItem

    var createRepository: CreateRepository { get }

    func create(
        _ item: Item,
        on eventLoop: EventLoop,
        in table: String
    ) -> EventLoopFuture<Void>
    
    func createSummaries<Summary: ItemSummary>(
        _ summaries: [Summary],
        in table: String
    ) -> EventLoopFuture<Void>
    
}

extension CreateUseCase {
    
    public func createSummaries<Summary: ItemSummary>(
        _ summaries: [Summary],
        in table: String
    ) -> EventLoopFuture<Void> {
        createRepository.createSummaries(summaries, in: table)
    }
    
}
