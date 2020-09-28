//
//  DatabaseDecodable.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 24/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

public protocol DatabaseDecodable {

    associatedtype ID: Hashable

    var identifier: Self.ID { get }

    init(from items: [String: Any]) throws

}
