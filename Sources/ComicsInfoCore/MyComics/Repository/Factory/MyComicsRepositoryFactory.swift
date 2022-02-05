//
//  MyComicsRepositoryFactory.swift
//  
//
//  Created by Aleksandar Dinic on 2/5/22.
//

import Foundation

public struct MyComicsRepositoryFactory: MyComicsDBWrapperFactory {

    let dbService: MyComicsDBService
    
    public func make() -> MyComicsRepository {
        MyComicsRepository(dbWrapper: makeDBWrapper())
    }

}
