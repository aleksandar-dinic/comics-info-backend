//
//  main.swift
//  ComicsInfoBackend
//
//  Created by Aleksandar Dinic on 11/08/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import class ComicsInfoCore.ComicsInfo

let comicsInfo = ComicsInfo()

do {
    try comicsInfo.run()
} catch {
    print("😱 An error occurred: \(error)")
}
