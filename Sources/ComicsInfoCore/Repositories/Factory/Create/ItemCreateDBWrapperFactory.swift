//
//  ItemCreateDBWrapperFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 04/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation

protocol ItemCreateDBWrapperFactory {

    var itemCreateDBService: ItemCreateDBService { get }
    
    func makeItemCreateDBService() -> ItemCreateDBWrapper
    
}

extension ItemCreateDBWrapperFactory {
    
    func makeItemCreateDBService() -> ItemCreateDBWrapper {
        ItemCreateDBWrapper(itemCreateDBService: itemCreateDBService)
    }

}
