//
//  Loggable.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 14/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation

public protocol Loggable {
    
    func getLogs() -> [Log]
    
}
