//
//  UpdateRepositoryBuilder.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 11/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public protocol UpdateRepositoryBuilder  {

    var eventLoop: EventLoop { get }
    var isLocalServer: Bool { get }

    func makeUpdateRepository() -> UpdateRepository
    
}

extension UpdateRepositoryBuilder {
    
    public func makeUpdateRepository() -> UpdateRepository {
        UpdateRepositoryFactory(itemUpdateDBService: makeItemUpdateDBService())
            .make()
    }

    func makeItemUpdateDBService() -> ItemUpdateDBService {
        DatabaseFectory(isLocalServer: isLocalServer, eventLoop: eventLoop)
            .makeDatabase()
    }

}
