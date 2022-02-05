//
//  MyComicsRepositoryBuilder.swift
//  
//
//  Created by Aleksandar Dinic on 2/5/22.
//

import struct SotoDynamoDB.DynamoDB
import Foundation
import NIO

public protocol MyComicsRepositoryBuilder  {

    var eventLoop: EventLoop { get }
    var isLocalServer: Bool { get }
    
    func makeRepository() -> MyComicsRepository

}

extension MyComicsRepositoryBuilder {
    
    public func makeRepository() -> MyComicsRepository {
        MyComicsRepositoryFactory(dbService: makeDBService())
            .make()
    }

    private func makeDBService() -> MyComicsDBService {
        SotoDynamoDB.DynamoDB(eventLoop: eventLoop)
    }
    
}

