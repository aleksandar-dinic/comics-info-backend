//
//  main.swift
//  SeriesHandler
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import SeriesInfo

let seriesInfo = SeriesInfo()

do {
    try seriesInfo.run()
} catch {
    print("😱 An error occurred: \(error)")
}
