//
//  MyComicsDBWrapperFactory.swift
//  
//
//  Created by Aleksandar Dinic on 2/5/22.
//

import Foundation

protocol MyComicsDBWrapperFactory {

    var dbService: MyComicsDBService { get }
    
    func makeDBWrapper() -> MyComicsDBWrapper
    
}

extension MyComicsDBWrapperFactory {
    
    func makeDBWrapper() -> MyComicsDBWrapper {
        MyComicsDBWrapper(dbService: dbService)
    }

}
