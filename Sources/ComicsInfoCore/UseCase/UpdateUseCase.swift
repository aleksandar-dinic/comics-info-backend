//
//  UpdateUseCase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 07/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public protocol UpdateUseCase {

    associatedtype APIWrapper: UpdateRepositoryAPIWrapper

    typealias Item = APIWrapper.Item

    var repository: UpdateRepository<APIWrapper> { get }

    func update(_ item: Item, in table: String) -> EventLoopFuture<Void>

}

public extension UpdateUseCase {

    func update(_ item: Item, in table: String) -> EventLoopFuture<Void> {
        repository.update(item, in: table)
    }

}
