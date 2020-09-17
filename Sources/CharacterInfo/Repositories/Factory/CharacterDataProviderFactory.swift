//
//  CharacterDataProviderFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 01/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

protocol CharacterDataProviderFactory: CharacterAPIWrapperFactory {

    var characterCacheService: CharacterCacheService { get }

    func makeCharacterDataProvider() -> CharacterDataProvider

}

extension CharacterDataProviderFactory {

    public func makeCharacterDataProvider() -> CharacterDataProvider {
        CharacterDataProvider(
            characterAPIWrapper: makeCharacterAPIWrapper(),
            characterCacheService: characterCacheService
        )
    }

}
