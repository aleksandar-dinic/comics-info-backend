//
//  MyCharactersRepositoryBuilder.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 16/01/2022.
//

import struct SotoDynamoDB.DynamoDB
import Foundation
import NIO

public protocol MyCharactersRepositoryBuilder  {

    var eventLoop: EventLoop { get }
    var isLocalServer: Bool { get }
    
    func makeRepository() -> MyCharactersRepository

}

extension MyCharactersRepositoryBuilder {
    
    public func makeRepository() -> MyCharactersRepository {
        MyCharactersRepositoryFactory(dbService: makeDBService())
            .make()
    }

    private func makeDBService() -> MyCharactersDBService {
        SotoDynamoDB.DynamoDB(eventLoop: eventLoop)
    }
    
}
