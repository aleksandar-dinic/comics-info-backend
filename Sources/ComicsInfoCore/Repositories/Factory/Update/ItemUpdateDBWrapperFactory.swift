//
//  ItemUpdateDBWrapperFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 04/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation

protocol ItemUpdateDBWrapperFactory {

    var itemUpdateDBService: ItemUpdateDBService { get }
    
    func makeItemUpdateDBWrapper() -> ItemUpdateDBWrapper
    
}

extension ItemUpdateDBWrapperFactory {
    
    func makeItemUpdateDBWrapper() -> ItemUpdateDBWrapper {
        ItemUpdateDBWrapper(itemUpdateDBService: itemUpdateDBService)
    }

}
