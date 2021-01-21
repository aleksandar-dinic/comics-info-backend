//
//  SummaryMapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 21/01/2021.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

protocol SummaryMapper: Identifiable {
    
    var popularity: Int { get }
    var name: String { get }
    var thumbnail: String? { get }
    var description: String? { get }
    
}
