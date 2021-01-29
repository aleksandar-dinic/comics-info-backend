//
//  LocalServer.swift
//  CharacterInfo
//
//  Created by Aleksandar Dinic on 20/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

public struct LocalServer {

    // FIXME: -
    static let characterInMemoryCache = InMemoryCacheProvider<Character>()
    static let seriesInMemoryCache = InMemoryCacheProvider<Series>()
    static let comicInMemoryCache = InMemoryCacheProvider<Comic>()

    public static var isEnabled = false

    public init(enabled: Bool = ProcessInfo.isLocalServerEnabled()) {
        LocalServer.isEnabled = enabled
    }

}
