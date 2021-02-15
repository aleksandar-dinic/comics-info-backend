//
//  GetUseCaseFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 17/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public protocol GetUseCaseFactory  {

    associatedtype UseCaseType: GetUseCase

    var eventLoop: EventLoop { get }
    var isLocalServer: Bool { get }

    func makeUseCase() -> UseCaseType

}

extension GetUseCaseFactory {
    
    func makeItemGetDBService() -> ItemGetDBService {
        DatabaseFectory(isLocalServer: isLocalServer, eventLoop: eventLoop)
            .makeDatabase()
    }

}
