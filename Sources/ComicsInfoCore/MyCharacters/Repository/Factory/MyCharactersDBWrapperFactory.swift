//
//  MyCharactersDBWrapperFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 16/01/2022.
//

import Foundation

protocol MyCharactersDBWrapperFactory {

    var dbService: MyCharactersDBService { get }
    
    func makeDBWrapper() -> MyCharactersDBWrapper
    
}

extension MyCharactersDBWrapperFactory {
    
    func makeDBWrapper() -> MyCharactersDBWrapper {
        MyCharactersDBWrapper(dbService: dbService)
    }

}
