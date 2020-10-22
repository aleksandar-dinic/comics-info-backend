//
//  DatabaseDecodable.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 24/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

public protocol DatabaseDecodable {

    var itemID: String { get }
    var summaryID: String { get }
    var tableName: String { get }

    init(from item: DatabaseItem, tableName: String) throws

}

protocol DatabaseMapper: DatabaseDecodable {

    associatedtype Item: Identifiable

    init(item: Item, tableName: String)

}
