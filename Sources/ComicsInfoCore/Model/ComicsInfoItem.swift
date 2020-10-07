//
//  ComicsInfoItem.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 07/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

protocol ComicsInfoItem: Codable, Identifiable {

    mutating func removeID(_ itemID: String)

}
