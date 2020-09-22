//
//  LocalServer.swift
//  CharacterInfo
//
//  Created by Aleksandar Dinic on 20/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import ComicsInfoCore
import Foundation

public struct LocalServer {

    static var isEnabled = false

    public init(enabled: Bool = ProcessInfo.isLocalServerEnabled) {
        LocalServer.isEnabled = enabled
    }

}
