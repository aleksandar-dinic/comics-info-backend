//
//  main.swift
//  CharacterHandler
//
//  Created by Aleksandar Dinic on 17/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import class CharacterInfo.CharacterInfo

let characterInfo = CharacterInfo()

do {
    try characterInfo.run()
} catch {
    print("😱 An error occurred: \(error)")
}
