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

    func create(with criteria: CreateItemCriteria<Item>) -> EventLoopFuture<Void>
    
    func createSummaries<Summary: ItemSummary>(
        with criteria: CreateSummariesCriteria<Summary>
    ) -> EventLoopFuture<Void>
    
}

extension CreateUseCase {
    
    public func createSummaries<Summary: ItemSummary>(
        with criteria: CreateSummariesCriteria<Summary>
    ) -> EventLoopFuture<Void> {
        createRepository.createSummaries(with: criteria)
    }
    
}
