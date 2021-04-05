//
//  DeleteRepositoryBuilder.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 05/04/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public protocol DeleteRepositoryBuilder  {

    var eventLoop: EventLoop { get }
    var isLocalServer: Bool { get }

    func makeDeleteRepository() -> DeleteRepository
    
}

extension DeleteRepositoryBuilder {
    
    public func makeDeleteRepository() -> DeleteRepository {
        DeleteRepositoryFactory(itemDeleteDBService: makeItemDeleteDBService())
            .make()
    }

    func makeItemDeleteDBService() -> ItemDeleteDBService {
        DatabaseFectory(isLocalServer: isLocalServer, eventLoop: eventLoop)
            .makeDatabase()
    }

}
