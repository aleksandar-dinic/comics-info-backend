//
//  DecoderService.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 24/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

public protocol DecoderService {

    func decode<Item: DatabaseDecodable>(from items: DatabaseItem) throws -> Item

}