//
//  DatabaseItemMapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 04/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

protocol DatabaseItemMapper {

    associatedtype DBItem: DatabaseDecodable

    init(from item: DBItem)

}
