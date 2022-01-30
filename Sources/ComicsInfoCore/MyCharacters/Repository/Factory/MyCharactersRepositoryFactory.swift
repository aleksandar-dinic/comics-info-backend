//
//  MyCharactersRepositoryFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 16/01/2022.
//

import Foundation

public struct MyCharactersRepositoryFactory: MyCharactersDBWrapperFactory {

    let dbService: MyCharactersDBService
    
    public func make() -> MyCharactersRepository {
        MyCharactersRepository(dbWrapper: makeDBWrapper())
    }

}
