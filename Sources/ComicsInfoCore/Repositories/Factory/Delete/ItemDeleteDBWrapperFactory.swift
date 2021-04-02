//
//  ItemDeleteDBWrapperFactory.swift
//  ComicInfo
//
//  Created by Aleksandar Dinic on 02/04/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation

protocol ItemDeleteDBWrapperFactory {

    var itemDeleteDBService: ItemDeleteDBService { get }
    
    func makeItemDeleteDBWrapper() -> ItemDeleteDBWrapper
    
}

extension ItemDeleteDBWrapperFactory {
    
    func makeItemDeleteDBWrapper() -> ItemDeleteDBWrapper {
        ItemDeleteDBWrapper(itemDeleteDBService: itemDeleteDBService)
    }

}
