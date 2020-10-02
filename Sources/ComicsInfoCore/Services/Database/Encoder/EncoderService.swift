//
//  EncoderService.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 24/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

public protocol EncoderService {

    func encode<Item>(_ item: Item, table: String) -> DatabaseItem

}
