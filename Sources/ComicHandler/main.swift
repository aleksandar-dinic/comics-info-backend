//
//  main.swift
//  ComicListHandler
//
//  Created by Aleksandar Dinic on 26/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import ComicInfo
import Foundation

let comicInfo = ComicInfo()

do {
    try comicInfo.run()
} catch {
    print("😱 An error occurred: \(error)")
}
