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

    associatedtype APIWrapper: CreateRepositoryAPIWrapper

    typealias Item = APIWrapper.Item

    var repository: CreateRepository<APIWrapper> { get }

    func create(_ item: Item, in table: String) -> EventLoopFuture<Void>

}

public extension CreateUseCase {

    func create(_ item: Item, in table: String) -> EventLoopFuture<Void> {
        repository.create(item, in: table)
    }

}
